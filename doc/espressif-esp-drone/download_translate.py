#!/usr/bin/env python3
"""
Скачивает документацию ESP-Drone с сайта Espressif,
переводит на русский язык и сохраняет в виде Markdown-файлов.

Зависимости: pip install requests beautifulsoup4 deep_translator
"""

import re
import time
import textwrap
from pathlib import Path
from deep_translator import GoogleTranslator
import requests
from bs4 import BeautifulSoup, NavigableString, Tag

BASE_URL = "https://docs.espressif.com/projects/espressif-esp-drone/en/latest/"
OUT_DIR  = Path(__file__).parent

PAGES = [
    ("index",         "index.html",         "ESP-Drone — Главная"),
    ("gettingstarted","gettingstarted.html", "Начало работы"),
    ("getespidf",     "getespidf.html",      "Настройка среды разработки"),
    ("developerguide","developerguide.html", "Руководство разработчика"),
    ("hardware",      "hardware.html",       "Аппаратная часть"),
    ("drivers",       "drivers.html",        "Драйверы"),
    ("system",        "system.html",         "Система управления полётом"),
    ("communication", "communication.html",  "Протоколы связи"),
]

DELAY = 0.15        # задержка между запросами к Google Translate
MAX_CHUNK = 4500    # максимальная длина одного запроса к переводчику

_trans_cache: dict[str, str] = {}

def translate(text: str) -> str:
    text = text.strip()
    if not text or len(text) < 4:
        return text
    if text in _trans_cache:
        return _trans_cache[text]

    # Разбиваем очень длинные тексты на части по ~4500 символов
    if len(text) > MAX_CHUNK:
        parts = []
        sentences = re.split(r'(?<=[.!?])\s+', text)
        chunk = ""
        for s in sentences:
            if len(chunk) + len(s) + 1 > MAX_CHUNK:
                if chunk:
                    parts.append(translate(chunk))
                    chunk = s
                else:
                    parts.append(translate(s))
            else:
                chunk = (chunk + " " + s).strip() if chunk else s
        if chunk:
            parts.append(translate(chunk))
        result = " ".join(parts)
        _trans_cache[text] = result
        return result

    try:
        result = GoogleTranslator(source='en', target='ru').translate(text) or text
        _trans_cache[text] = result
        time.sleep(DELAY)
        return result
    except Exception as e:
        print(f"  [!] Ошибка перевода: {e}")
        return text


def node_to_md(node, code_lang: str = "") -> str:
    """Рекурсивно преобразует HTML-узел в Markdown."""
    if isinstance(node, NavigableString):
        t = str(node)
        if t.strip():
            return t
        return t  # сохраняем пробелы

    tag = node.name
    children_md = "".join(node_to_md(c) for c in node.children)

    if tag in ("script", "style", "nav", "header", "footer"):
        return ""
    if tag in ("p",):
        text = node.get_text(" ", strip=True)
        if not text:
            return ""
        return "\n\n" + translate(text) + "\n\n"
    if tag == "h1":
        text = node.get_text(" ", strip=True)
        return "\n\n# " + translate(text) + "\n\n"
    if tag == "h2":
        text = node.get_text(" ", strip=True)
        return "\n\n## " + translate(text) + "\n\n"
    if tag == "h3":
        text = node.get_text(" ", strip=True)
        return "\n\n### " + translate(text) + "\n\n"
    if tag == "h4":
        text = node.get_text(" ", strip=True)
        return "\n\n#### " + translate(text) + "\n\n"
    if tag == "h5":
        text = node.get_text(" ", strip=True)
        return "\n\n##### " + translate(text) + "\n\n"
    if tag in ("strong", "b"):
        text = node.get_text(" ", strip=True)
        return f"**{text}**"
    if tag in ("em", "i"):
        text = node.get_text(" ", strip=True)
        return f"*{text}*"
    if tag == "code":
        # Инлайн-код — не переводим
        return f"`{node.get_text()}`"
    if tag == "pre":
        code = node.get_text()
        # Определяем язык по классу
        lang = ""
        code_tag = node.find("code")
        if code_tag and code_tag.get("class"):
            cls = " ".join(code_tag.get("class", []))
            if "c" in cls or "cpp" in cls:
                lang = "c"
            elif "python" in cls:
                lang = "python"
            elif "bash" in cls or "shell" in cls:
                lang = "bash"
        return f"\n\n```{lang}\n{code}\n```\n\n"
    if tag == "a":
        text = node.get_text(" ", strip=True)
        href = node.get("href", "")
        if not text:
            return ""
        # Локальные ссылки оставляем как есть
        return f"[{translate(text)}]({href})"
    if tag in ("ul", "ol"):
        items = []
        for li in node.find_all("li", recursive=False):
            li_text = li.get_text(" ", strip=True)
            if li_text:
                items.append(f"- {translate(li_text)}")
        return "\n" + "\n".join(items) + "\n"
    if tag == "li":
        text = node.get_text(" ", strip=True)
        return f"- {translate(text)}\n"
    if tag == "table":
        return table_to_md(node)
    if tag == "img":
        alt = node.get("alt", "")
        src = node.get("src", "")
        return f"\n![{alt}]({src})\n"
    if tag == "br":
        return "\n"
    if tag in ("div", "section", "article", "main", "span"):
        return children_md
    return children_md


def table_to_md(table_node) -> str:
    """Преобразует HTML-таблицу в Markdown."""
    rows = table_node.find_all("tr")
    if not rows:
        return ""

    md_rows = []
    for i, row in enumerate(rows):
        cells = row.find_all(["th", "td"])
        cell_texts = []
        for cell in cells:
            raw = cell.get_text(" ", strip=True)
            if raw:
                cell_texts.append(translate(raw))
            else:
                cell_texts.append("")
        if not any(cell_texts):
            continue
        md_rows.append("| " + " | ".join(cell_texts) + " |")
        if i == 0:
            md_rows.append("| " + " | ".join(["---"] * len(cell_texts)) + " |")

    return "\n\n" + "\n".join(md_rows) + "\n\n"


def fetch_page(url: str) -> BeautifulSoup | None:
    try:
        r = requests.get(url, timeout=30,
                         headers={"User-Agent": "Mozilla/5.0 (compatible; DocTranslator/1.0)"})
        r.raise_for_status()
        return BeautifulSoup(r.text, "html.parser")
    except Exception as e:
        print(f"  [!] Ошибка загрузки {url}: {e}")
        return None


def page_to_md(soup: BeautifulSoup, title_ru: str) -> str:
    """Извлекает основной контент и конвертирует в Markdown."""
    # Ищем основной блок контента
    content = (
        soup.find("div", role="main") or
        soup.find("div", class_="document") or
        soup.find("article") or
        soup.find("main") or
        soup.find("body")
    )
    if not content:
        return f"# {title_ru}\n\n*Контент не найден*\n"

    # Убираем ненужные блоки: навигация, TOC-кнопки, breadcrumbs и т.п.
    for selector in [
        "div.sphinxsidebar", "div.related", "div.navigation",
        "div.footer", "div.docutils", "a.headerlink",
        "div#searchbox", "div.toctree-wrapper",
        "nav", "header", "footer",
    ]:
        for el in content.select(selector):
            el.decompose()

    md = node_to_md(content)

    # Чистим многократные пустые строки
    md = re.sub(r'\n{3,}', '\n\n', md)
    md = md.strip()

    header = textwrap.dedent(f"""\
        <!-- Переведено с https://docs.espressif.com/projects/espressif-esp-drone/en/latest/ -->
        <!-- Оригинал: английский | Перевод: русский | Инструмент: Google Translate API -->

    """)
    return header + md + "\n"


def main():
    OUT_DIR.mkdir(parents=True, exist_ok=True)
    print(f"Выходная папка: {OUT_DIR}\n")

    for slug, html_name, title_ru in PAGES:
        url = BASE_URL + html_name
        out_path = OUT_DIR / f"{slug}.md"
        print(f"▶  {html_name}  →  {out_path.name}")

        soup = fetch_page(url)
        if soup is None:
            print("   Пропущено (ошибка загрузки)\n")
            continue

        md = page_to_md(soup, title_ru)
        out_path.write_text(md, encoding="utf-8")
        print(f"   ✓ Сохранено ({len(md):,} байт)\n")
        time.sleep(0.5)

    # Создаём README с оглавлением
    readme = "# Документация ESP-Drone (перевод на русский)\n\n"
    readme += "Источник: https://docs.espressif.com/projects/espressif-esp-drone/en/latest/\n\n"
    readme += "## Содержание\n\n"
    for slug, _, title_ru in PAGES:
        readme += f"- [{title_ru}]({slug}.md)\n"
    (OUT_DIR / "README.md").write_text(readme, encoding="utf-8")
    print("✓ README.md создан")
    print("\nГотово!")


if __name__ == "__main__":
    main()
