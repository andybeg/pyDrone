#!/usr/bin/env bash
# =============================================================================
# Скачивает все изображения PyDrone wiki локально и обновляет пути в документе.
# Запуск: bash /Volumes/dev/pyDrone/doc/download_images.sh
# =============================================================================

set -e
DOC="/Volumes/dev/pyDrone/doc/pyDrone_документация_RU.md"
BASE_URL="https://raw.githubusercontent.com/01studio-lab/01studio_wiki/main/docs/pydrone"
DEST="/Volumes/dev/pyDrone/doc/img"

echo "=== PyDrone: загрузка изображений ==="

declare -a URLS=(
"https://raw.githubusercontent.com/01studio-lab/01studio_wiki/main/docs/pydrone/basic_examples/img/adc/adc1.png"
"https://raw.githubusercontent.com/01studio-lab/01studio_wiki/main/docs/pydrone/basic_examples/img/adc/adc2.png"
"https://raw.githubusercontent.com/01studio-lab/01studio_wiki/main/docs/pydrone/basic_examples/img/exti/exti0.png"
"https://raw.githubusercontent.com/01studio-lab/01studio_wiki/main/docs/pydrone/basic_examples/img/exti/exti1.png"
"https://raw.githubusercontent.com/01studio-lab/01studio_wiki/main/docs/pydrone/basic_examples/img/exti/exti2.png"
"https://raw.githubusercontent.com/01studio-lab/01studio_wiki/main/docs/pydrone/basic_examples/img/gpio_intro/pinout.png"
"https://raw.githubusercontent.com/01studio-lab/01studio_wiki/main/docs/pydrone/basic_examples/img/gpio_intro/pinout2.png"
"https://raw.githubusercontent.com/01studio-lab/01studio_wiki/main/docs/pydrone/basic_examples/img/gpio_intro/pinout3.png"
"https://raw.githubusercontent.com/01studio-lab/01studio_wiki/main/docs/pydrone/basic_examples/img/key/key1.png"
"https://raw.githubusercontent.com/01studio-lab/01studio_wiki/main/docs/pydrone/basic_examples/img/key/key3.png"
"https://raw.githubusercontent.com/01studio-lab/01studio_wiki/main/docs/pydrone/basic_examples/img/key/key4.png"
"https://raw.githubusercontent.com/01studio-lab/01studio_wiki/main/docs/pydrone/basic_examples/img/led/led1.png"
"https://raw.githubusercontent.com/01studio-lab/01studio_wiki/main/docs/pydrone/basic_examples/img/led/led2.png"
"https://raw.githubusercontent.com/01studio-lab/01studio_wiki/main/docs/pydrone/basic_examples/img/led/led3.png"
"https://raw.githubusercontent.com/01studio-lab/01studio_wiki/main/docs/pydrone/basic_examples/img/pwm/pwm1.gif"
"https://raw.githubusercontent.com/01studio-lab/01studio_wiki/main/docs/pydrone/basic_examples/img/pwm/pwm2.png"
"https://raw.githubusercontent.com/01studio-lab/01studio_wiki/main/docs/pydrone/basic_examples/img/pwm/pwm3.png"
"https://raw.githubusercontent.com/01studio-lab/01studio_wiki/main/docs/pydrone/basic_examples/img/pwm/pwm5.png"
"https://raw.githubusercontent.com/01studio-lab/01studio_wiki/main/docs/pydrone/basic_examples/img/timer/timer1.png"
"https://raw.githubusercontent.com/01studio-lab/01studio_wiki/main/docs/pydrone/drone/img/basic/basic1.jpg"
"https://raw.githubusercontent.com/01studio-lab/01studio_wiki/main/docs/pydrone/drone/img/basic/basic2.png"
"https://raw.githubusercontent.com/01studio-lab/01studio_wiki/main/docs/pydrone/drone/img/basic/basic3.jpg"
"https://raw.githubusercontent.com/01studio-lab/01studio_wiki/main/docs/pydrone/drone/img/basic/basic4.png"
"https://raw.githubusercontent.com/01studio-lab/01studio_wiki/main/docs/pydrone/drone/img/basic/basic5.jpg"
"https://raw.githubusercontent.com/01studio-lab/01studio_wiki/main/docs/pydrone/drone/img/basic/basic6.png"
"https://raw.githubusercontent.com/01studio-lab/01studio_wiki/main/docs/pydrone/drone/img/basic/basic7.jpg"
"https://raw.githubusercontent.com/01studio-lab/01studio_wiki/main/docs/pydrone/drone/img/basic/basic8.png"
"https://raw.githubusercontent.com/01studio-lab/01studio_wiki/main/docs/pydrone/drone/img/basic/basic9.png"
"https://raw.githubusercontent.com/01studio-lab/01studio_wiki/main/docs/pydrone/drone/img/ble_control/ble_control1.png"
"https://raw.githubusercontent.com/01studio-lab/01studio_wiki/main/docs/pydrone/drone/img/ble_control/ble_control10.png"
"https://raw.githubusercontent.com/01studio-lab/01studio_wiki/main/docs/pydrone/drone/img/ble_control/ble_control11.png"
"https://raw.githubusercontent.com/01studio-lab/01studio_wiki/main/docs/pydrone/drone/img/ble_control/ble_control12.png"
"https://raw.githubusercontent.com/01studio-lab/01studio_wiki/main/docs/pydrone/drone/img/ble_control/ble_control13.png"
"https://raw.githubusercontent.com/01studio-lab/01studio_wiki/main/docs/pydrone/drone/img/ble_control/ble_control2.png"
"https://raw.githubusercontent.com/01studio-lab/01studio_wiki/main/docs/pydrone/drone/img/ble_control/ble_control3.png"
"https://raw.githubusercontent.com/01studio-lab/01studio_wiki/main/docs/pydrone/drone/img/ble_control/ble_control4.png"
"https://raw.githubusercontent.com/01studio-lab/01studio_wiki/main/docs/pydrone/drone/img/ble_control/ble_control5.png"
"https://raw.githubusercontent.com/01studio-lab/01studio_wiki/main/docs/pydrone/drone/img/ble_control/ble_control6.png"
"https://raw.githubusercontent.com/01studio-lab/01studio_wiki/main/docs/pydrone/drone/img/ble_control/ble_control7.png"
"https://raw.githubusercontent.com/01studio-lab/01studio_wiki/main/docs/pydrone/drone/img/ble_control/ble_control8.png"
"https://raw.githubusercontent.com/01studio-lab/01studio_wiki/main/docs/pydrone/drone/img/ble_control/ble_control9.png"
"https://raw.githubusercontent.com/01studio-lab/01studio_wiki/main/docs/pydrone/drone/img/wifi_control/wifi_control1.png"
"https://raw.githubusercontent.com/01studio-lab/01studio_wiki/main/docs/pydrone/drone/img/wifi_control/wifi_control2.png"
"https://raw.githubusercontent.com/01studio-lab/01studio_wiki/main/docs/pydrone/drone/img/wifi_control/wifi_control3.png"
"https://raw.githubusercontent.com/01studio-lab/01studio_wiki/main/docs/pydrone/drone/img/wifi_control/wifi_control4.png"
"https://raw.githubusercontent.com/01studio-lab/01studio_wiki/main/docs/pydrone/drone/img/wifi_control/wifi_control5.png"
"https://raw.githubusercontent.com/01studio-lab/01studio_wiki/main/docs/pydrone/drone/img/wifi_control/wifi_control6.png"
"https://raw.githubusercontent.com/01studio-lab/01studio_wiki/main/docs/pydrone/drone/img/wifi_control/wifi_control7.png"
"https://raw.githubusercontent.com/01studio-lab/01studio_wiki/main/docs/pydrone/drone/img/wifi_control/wifi_control8.png"
"https://raw.githubusercontent.com/01studio-lab/01studio_wiki/main/docs/pydrone/drone/img/wifi_control/wifi_control9.png"
"https://raw.githubusercontent.com/01studio-lab/01studio_wiki/main/docs/pydrone/getting_start/img/demo/demo1.png"
"https://raw.githubusercontent.com/01studio-lab/01studio_wiki/main/docs/pydrone/getting_start/img/demo/demo2.png"
"https://raw.githubusercontent.com/01studio-lab/01studio_wiki/main/docs/pydrone/getting_start/img/demo/demo3.png"
"https://raw.githubusercontent.com/01studio-lab/01studio_wiki/main/docs/pydrone/getting_start/img/driver/driver1.png"
"https://raw.githubusercontent.com/01studio-lab/01studio_wiki/main/docs/pydrone/getting_start/img/driver/driver2.png"
"https://raw.githubusercontent.com/01studio-lab/01studio_wiki/main/docs/pydrone/getting_start/img/file_system/file_system1.png"
"https://raw.githubusercontent.com/01studio-lab/01studio_wiki/main/docs/pydrone/getting_start/img/file_system/file_system2.png"
"https://raw.githubusercontent.com/01studio-lab/01studio_wiki/main/docs/pydrone/getting_start/img/file_system/file_system3.png"
"https://raw.githubusercontent.com/01studio-lab/01studio_wiki/main/docs/pydrone/getting_start/img/file_system/file_system4.png"
"https://raw.githubusercontent.com/01studio-lab/01studio_wiki/main/docs/pydrone/getting_start/img/firmware/firmware1.png"
"https://raw.githubusercontent.com/01studio-lab/01studio_wiki/main/docs/pydrone/getting_start/img/firmware/firmware2.png"
"https://raw.githubusercontent.com/01studio-lab/01studio_wiki/main/docs/pydrone/getting_start/img/firmware/firmware3.png"
"https://raw.githubusercontent.com/01studio-lab/01studio_wiki/main/docs/pydrone/getting_start/img/firmware/firmware4.png"
"https://raw.githubusercontent.com/01studio-lab/01studio_wiki/main/docs/pydrone/getting_start/img/firmware/firmware5.png"
"https://raw.githubusercontent.com/01studio-lab/01studio_wiki/main/docs/pydrone/getting_start/img/firmware/firmware6.png"
"https://raw.githubusercontent.com/01studio-lab/01studio_wiki/main/docs/pydrone/getting_start/img/firmware/firmware7.png"
"https://raw.githubusercontent.com/01studio-lab/01studio_wiki/main/docs/pydrone/getting_start/img/ide/ide1.png"
"https://raw.githubusercontent.com/01studio-lab/01studio_wiki/main/docs/pydrone/getting_start/img/ide/ide2.png"
"https://raw.githubusercontent.com/01studio-lab/01studio_wiki/main/docs/pydrone/getting_start/img/repl/repl1.png"
"https://raw.githubusercontent.com/01studio-lab/01studio_wiki/main/docs/pydrone/getting_start/img/repl/repl10.png"
"https://raw.githubusercontent.com/01studio-lab/01studio_wiki/main/docs/pydrone/getting_start/img/repl/repl11.png"
"https://raw.githubusercontent.com/01studio-lab/01studio_wiki/main/docs/pydrone/getting_start/img/repl/repl12.png"
"https://raw.githubusercontent.com/01studio-lab/01studio_wiki/main/docs/pydrone/getting_start/img/repl/repl2.png"
"https://raw.githubusercontent.com/01studio-lab/01studio_wiki/main/docs/pydrone/getting_start/img/repl/repl3.png"
"https://raw.githubusercontent.com/01studio-lab/01studio_wiki/main/docs/pydrone/getting_start/img/repl/repl4.png"
"https://raw.githubusercontent.com/01studio-lab/01studio_wiki/main/docs/pydrone/getting_start/img/repl/repl5.png"
"https://raw.githubusercontent.com/01studio-lab/01studio_wiki/main/docs/pydrone/getting_start/img/repl/repl6.png"
"https://raw.githubusercontent.com/01studio-lab/01studio_wiki/main/docs/pydrone/getting_start/img/repl/repl7.png"
"https://raw.githubusercontent.com/01studio-lab/01studio_wiki/main/docs/pydrone/getting_start/img/repl/repl8.png"
"https://raw.githubusercontent.com/01studio-lab/01studio_wiki/main/docs/pydrone/getting_start/img/repl/repl9.png"
"https://raw.githubusercontent.com/01studio-lab/01studio_wiki/main/docs/pydrone/getting_start/img/run_offline/run_offline1.png"
"https://raw.githubusercontent.com/01studio-lab/01studio_wiki/main/docs/pydrone/getting_start/img/run_offline/run_offline2.png"
"https://raw.githubusercontent.com/01studio-lab/01studio_wiki/main/docs/pydrone/getting_start/img/run_offline/run_offline3.png"
"https://raw.githubusercontent.com/01studio-lab/01studio_wiki/main/docs/pydrone/intro/img/assembly/assembly1.png"
"https://raw.githubusercontent.com/01studio-lab/01studio_wiki/main/docs/pydrone/intro/img/assembly/assembly10.jpg"
"https://raw.githubusercontent.com/01studio-lab/01studio_wiki/main/docs/pydrone/intro/img/assembly/assembly11.jpg"
"https://raw.githubusercontent.com/01studio-lab/01studio_wiki/main/docs/pydrone/intro/img/assembly/assembly12.png"
"https://raw.githubusercontent.com/01studio-lab/01studio_wiki/main/docs/pydrone/intro/img/assembly/assembly13.png"
"https://raw.githubusercontent.com/01studio-lab/01studio_wiki/main/docs/pydrone/intro/img/assembly/assembly14.png"
"https://raw.githubusercontent.com/01studio-lab/01studio_wiki/main/docs/pydrone/intro/img/assembly/assembly15.png"
"https://raw.githubusercontent.com/01studio-lab/01studio_wiki/main/docs/pydrone/intro/img/assembly/assembly16.png"
"https://raw.githubusercontent.com/01studio-lab/01studio_wiki/main/docs/pydrone/intro/img/assembly/assembly17.png"
"https://raw.githubusercontent.com/01studio-lab/01studio_wiki/main/docs/pydrone/intro/img/assembly/assembly18.png"
"https://raw.githubusercontent.com/01studio-lab/01studio_wiki/main/docs/pydrone/intro/img/assembly/assembly19.png"
"https://raw.githubusercontent.com/01studio-lab/01studio_wiki/main/docs/pydrone/intro/img/assembly/assembly2.png"
"https://raw.githubusercontent.com/01studio-lab/01studio_wiki/main/docs/pydrone/intro/img/assembly/assembly20.png"
"https://raw.githubusercontent.com/01studio-lab/01studio_wiki/main/docs/pydrone/intro/img/assembly/assembly21.png"
"https://raw.githubusercontent.com/01studio-lab/01studio_wiki/main/docs/pydrone/intro/img/assembly/assembly22.png"
"https://raw.githubusercontent.com/01studio-lab/01studio_wiki/main/docs/pydrone/intro/img/assembly/assembly3.png"
"https://raw.githubusercontent.com/01studio-lab/01studio_wiki/main/docs/pydrone/intro/img/assembly/assembly4.png"
"https://raw.githubusercontent.com/01studio-lab/01studio_wiki/main/docs/pydrone/intro/img/assembly/assembly5.png"
"https://raw.githubusercontent.com/01studio-lab/01studio_wiki/main/docs/pydrone/intro/img/assembly/assembly6.png"
"https://raw.githubusercontent.com/01studio-lab/01studio_wiki/main/docs/pydrone/intro/img/assembly/assembly7.png"
"https://raw.githubusercontent.com/01studio-lab/01studio_wiki/main/docs/pydrone/intro/img/assembly/assembly8.png"
"https://raw.githubusercontent.com/01studio-lab/01studio_wiki/main/docs/pydrone/intro/img/assembly/assembly9.png"
"https://raw.githubusercontent.com/01studio-lab/01studio_wiki/main/docs/pydrone/intro/img/charge/charge1.png"
"https://raw.githubusercontent.com/01studio-lab/01studio_wiki/main/docs/pydrone/intro/img/charge/charge2.png"
"https://raw.githubusercontent.com/01studio-lab/01studio_wiki/main/docs/pydrone/intro/img/fly/fly1.png"
"https://raw.githubusercontent.com/01studio-lab/01studio_wiki/main/docs/pydrone/intro/img/fly/fly10.png"
"https://raw.githubusercontent.com/01studio-lab/01studio_wiki/main/docs/pydrone/intro/img/fly/fly11.png"
"https://raw.githubusercontent.com/01studio-lab/01studio_wiki/main/docs/pydrone/intro/img/fly/fly12.png"
"https://raw.githubusercontent.com/01studio-lab/01studio_wiki/main/docs/pydrone/intro/img/fly/fly2.png"
"https://raw.githubusercontent.com/01studio-lab/01studio_wiki/main/docs/pydrone/intro/img/fly/fly3.png"
"https://raw.githubusercontent.com/01studio-lab/01studio_wiki/main/docs/pydrone/intro/img/fly/fly4.png"
"https://raw.githubusercontent.com/01studio-lab/01studio_wiki/main/docs/pydrone/intro/img/fly/fly5.png"
"https://raw.githubusercontent.com/01studio-lab/01studio_wiki/main/docs/pydrone/intro/img/fly/fly6.png"
"https://raw.githubusercontent.com/01studio-lab/01studio_wiki/main/docs/pydrone/intro/img/fly/fly7.png"
"https://raw.githubusercontent.com/01studio-lab/01studio_wiki/main/docs/pydrone/intro/img/fly/fly8.png"
"https://raw.githubusercontent.com/01studio-lab/01studio_wiki/main/docs/pydrone/intro/img/fly/fly9.png"
"https://raw.githubusercontent.com/01studio-lab/01studio_wiki/main/docs/pydrone/intro/img/intro/intro1.gif"
"https://raw.githubusercontent.com/01studio-lab/01studio_wiki/main/docs/pydrone/intro/img/intro/intro1_1.png"
"https://raw.githubusercontent.com/01studio-lab/01studio_wiki/main/docs/pydrone/intro/img/intro/intro2.png"
"https://raw.githubusercontent.com/01studio-lab/01studio_wiki/main/docs/pydrone/intro/img/intro/intro3.png"
"https://raw.githubusercontent.com/01studio-lab/01studio_wiki/main/docs/pydrone/intro/img/intro/intro4.png"
"https://raw.githubusercontent.com/01studio-lab/01studio_wiki/main/docs/pydrone/intro/img/intro/intro5.png"
"https://raw.githubusercontent.com/01studio-lab/01studio_wiki/main/docs/pydrone/intro/img/intro/size.png"
)

ok=0; fail=0

for url in "${URLS[@]}"; do
  # Извлечь относительный путь из URL
  rel="${url#$BASE_URL/}"                # SECTION/img/SUBSECTION/FILE
  section="${rel%%/*}"
  rest="${rel#*/img/}"
  local_path="$DEST/$section/$rest"

  mkdir -p "$(dirname "$local_path")"

  if curl -sSf -o "$local_path" "$url"; then
    echo "  OK  $section/$rest"
    ((ok++))
  else
    echo "  FAIL $url"
    ((fail++))
  fi
done

echo ""
echo "=== Скачано: $ok  Ошибок: $fail ==="

# Обновить пути в документе
echo ""
echo "Обновление путей в документе..."

python3 - <<'PYEOF'
import re

DOC = "/Volumes/dev/pyDrone/doc/pyDrone_документация_RU.md"
BASE_URL = "https://raw.githubusercontent.com/01studio-lab/01studio_wiki/main/docs/pydrone"

with open(DOC, "r", encoding="utf-8") as f:
    content = f.read()

def to_local(url):
    rel = url.replace(BASE_URL + "/", "")
    parts = rel.split("/img/", 1)
    if len(parts) == 2:
        section, rest = parts
        return f"img/{section}/{rest}"
    return f"img/{rel}"

urls = sorted(set(re.findall(r'https://raw\.githubusercontent\.com/[^\)]+', content)))
for url in urls:
    content = content.replace(url, to_local(url))

with open(DOC, "w", encoding="utf-8") as f:
    f.write(content)

print(f"Обновлено {len(urls)} путей в документе.")
print(f"Документ готов: {DOC}")
PYEOF
