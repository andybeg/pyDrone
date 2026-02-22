# pyDrone — Полная документация на русском языке

> Перевод официальной документации 01Studio с изображениями  
> Оригинал: https://wiki.01studio.cc/en/docs/pydrone  
> Исходники вики: https://github.com/01studio-lab/01studio_wiki  
> Дата перевода: февраль 2026

---

## Содержание

1. [Введение в pyDrone](#1-введение-в-pydrone)
2. [Зарядка](#2-зарядка)
3. [Сборка дрона](#3-сборка-дрона)
4. [Руководство по полёту](#4-руководство-по-полёту)
5. [Установка драйверов](#5-установка-драйверов)
6. [Установка Thonny IDE](#6-установка-thonny-ide)
7. [REPL — интерактивная отладка](#7-repl--интерактивная-отладка)
8. [Файловая система](#8-файловая-система)
9. [Первый запуск кода](#9-первый-запуск-кода)
10. [Автозапуск кода при включении](#10-автозапуск-кода-при-включении)
11. [Обновление прошивки](#11-обновление-прошивки)
12. [GPIO — введение](#12-gpio--введение)
13. [LED — светодиод](#13-led--светодиод)
14. [Кнопки](#14-кнопки)
15. [Внешние прерывания](#15-внешние-прерывания)
16. [Таймеры](#16-таймеры)
17. [PWM — управление моторами](#17-pwm--управление-моторами)
18. [ADC — измерение заряда батареи](#18-adc--измерение-заряда-батареи)
19. [Подключение к WiFi-роутеру](#19-подключение-к-wifi-роутеру)
20. [Socket-связь](#20-socket-связь)
21. [MQTT-связь](#21-mqtt-связь)
22. [Основы квадрокоптера](#22-основы-квадрокоптера)
23. [Заводской пример](#23-заводской-пример)
24. [Управление по Bluetooth](#24-управление-по-bluetooth)
25. [Управление по WiFi](#25-управление-по-wifi)
26. [Справочник API: объект DRONE](#26-справочник-api-объект-drone)

---

## 1. Введение в pyDrone

![pyDrone в полёте](img/intro/intro/intro1.gif)

**pyDrone** — это открытый проект квадрокоптера на MicroPython, инициированный компанией 01Studio (01 Technologies).

MicroPython — это использование Python для программирования встраиваемых аппаратных устройств. MicroPython активно развивается, и 01Studio, посвятившая себя Python-программированию для встраиваемых систем, запустила проект pyDrone с целью популяризации MicroPython.

![pyDrone общий вид](img/intro/intro/intro1_1.png)

### Основной контроллер

pyDrone использует ESP32-S3 (N8R8) от Espressif в качестве главного контроллера.

![ESP32-S3 модуль](img/intro/intro/intro2.png)

![pyDrone плата](img/intro/intro/intro3.png)

### Основные параметры

![Основные параметры](img/intro/intro/intro4.png)

![Дополнительные параметры](img/intro/intro/intro5.png)

### Технические характеристики

| Параметр | Значение |
|---|---|
| Главный контроллер | ESP32-S3-WROOM-1 (N8R8, Flash: 8 МБ, RAM: 8 МБ); поддержка WiFi/BLE |
| Светодиоды | ×4: питание (красный), зарядка (оранжевый), калибровка (синий), беспроводное подключение (зелёный) |
| Кнопки | ×2: программируемая кнопка + кнопка сброса |
| Акселерометр | MPU6050 (6-осевой) |
| Барометр | SPL06-001 |
| Электронный компас | QMC5883L |
| MicroUSB | прошивка / отладка / зарядка (всё в одном) |
| Моторы | ×4: полый стакан 716, диаметр вала 0.8 мм |
| Пропеллеры | ×4: лопасти 46 мм |
| Аккумулятор | ×1: стандарт 400 мАч, опция 550 мАч |
| Защитное кольцо | ×1 |

### Чертёж размеров

![Размеры pyDrone](img/intro/intro/size.png)

---

## 2. Зарядка

### Способ 1 — зарядный кабель (рекомендуется)

Используйте входящий в комплект USB-кабель. Красный светодиод горит во время зарядки, гаснет после полного заряда.

![Зарядка кабелем](img/intro/charge/charge1.png)

### Способ 2 — через плату

Подключите кабель MicroUSB напрямую. Оранжевый светодиод горит во время зарядки, гаснет после завершения.

![Зарядка через плату](img/intro/charge/charge2.png)

> **Примечание:** Поскольку у pyDrone нет выключателя питания, при зарядке через плату устройство одновременно работает. Напряжение выше 4.1В считается полным зарядом.

---

## 3. Сборка дрона

> Видеоурок по сборке и полёту: https://b23.tv/BV1ct4y1V7qG

После получения комплекта проверьте наличие всех компонентов.

![Комплект поставки](img/intro/assembly/assembly1.png)

### Шаг 1 — Установка стоек моторов

Вставьте стойки моторов в 4 отверстия платы. При первой установке потребуется усилие.

![Установка стоек](img/intro/assembly/assembly2.png)

![Стойки установлены](img/intro/assembly/assembly3.png)

Все 4 стойки установлены:

![4 стойки готовы](img/intro/assembly/assembly4.png)

### Шаг 2 — Установка моторов с полым стаканом

Скрутите провода мотора в жгут — это уменьшает помехи.

![Скручивание проводов](img/intro/assembly/assembly5.png)

Вставьте мотор сверху вниз в стойку.

![Вставка мотора](img/intro/assembly/assembly6.png)

Подключите разъём проводов мотора к плате. **Будьте осторожны — не повредите разъём платы.**

![Подключение мотора](img/intro/assembly/assembly7.png)

Установите все 4 мотора таким же образом.

![4 мотора установлены](img/intro/assembly/assembly8.png)

![Вид снизу](img/intro/assembly/assembly9.png)

### Шаг 3 — Установка защитного кольца

Наденьте кольцо на моторы и нажмите до упора.

![Установка кольца](img/intro/assembly/assembly10.jpg)

![Кольцо установлено](img/intro/assembly/assembly11.jpg)

### Шаг 4 — Установка пропеллеров A и B

Пропеллеры делятся на типы A и B (маркировка шелкографией сверху).

![Типы пропеллеров](img/intro/assembly/assembly12.png)

Вставьте пропеллеры шелкографией вверх, следуя маркировке A/B на плате. **Неправильная установка приведёт к невозможности полёта.**

![Установка пропеллеров](img/intro/assembly/assembly13.png)

### Шаг 5 — Установка держателя аккумулятора

Вставьте 2 штырька в плату снизу.

![Штырьки](img/intro/assembly/assembly14.png)

![Крышка](img/intro/assembly/assembly15.png)

Установите крышку аккумулятора, оставив место для вставки аккумулятора.

![Установка крышки](img/intro/assembly/assembly16.png)

### Шаг 6 — Установка аккумулятора

Наклейте противоскользящую накладку на аккумулятор.

![Противоскользящая накладка](img/intro/assembly/assembly17.png)

![Накладка наклеена](img/intro/assembly/assembly18.png)

Поместите аккумулятор в отсек и прижмите крышку.

![Установка аккумулятора](img/intro/assembly/assembly19.png)

**Правильная фиксация аккумулятора очень важна — это предотвращает его смещение во время полёта.**

![Фиксация аккумулятора](img/intro/assembly/assembly20.png)

Подключите кабель питания (кабель можно убрать под стойки моторов).

![Кабель питания](img/intro/assembly/assembly21.png)

Сборка завершена!

![Готовый дрон](img/intro/assembly/assembly22.png)

---

## 4. Руководство по полёту

> Видеоурок: https://b23.tv/BV1ct4y1V7qG

Заводской пример управляется джойстиком pyController через Bluetooth BLE.

### Система координат pyDrone

![Координаты pyDrone](img/intro/fly/fly1.png)

### Джойстик pyController

![Джойстик pyController](img/intro/fly/fly2.png)

### Калибровка

Подключите аккумулятор, установите дрон **горизонтально** (неровная поверхность сбивает калибровку) и нажмите кнопку сброса.

![Калибровка дрона](img/intro/fly/fly3.png)

Во время калибровки мигает синий светодиод; после успешной калибровки он горит постоянно (обычно до 10 секунд).

![Синий LED после калибровки](img/intro/fly/fly4.png)

### Подключение джойстика

Включите джойстик, дождитесь экрана "pyDrone" и нажмите **START**.

![Меню джойстика](img/intro/fly/fly5.png)

Отобразится список найденных дронов с MAC-адресами и уровнем сигнала.

![Поиск дрона](img/intro/fly/fly6.png)

Уровень сигнала: 0 ~ -99 (ближе к 0 = лучше).

![Уровень сигнала](img/intro/fly/fly7.png)

При нескольких дронах — выбирайте кнопками вверх/вниз, затем долго нажмите START.

![Выбор дрона](img/intro/fly/fly8.png)

Постоянно горящий зелёный LED = успешное подключение.

![Зелёный LED подключен](img/intro/fly/fly9.png)

На экране джойстика отображаются данные дрона в реальном времени.

![Данные на экране](img/intro/fly/fly10.png)

### Режимы полёта

![Режимы полёта](img/intro/fly/fly11.png)

- **Безголовый режим (по умолчанию):** направления вперёд/назад/влево/вправо привязаны к окружающей среде. Используется в помещении.
- **Режим с головой:** направления привязаны к корпусу дрона. Используется на улице.

### Управление джойстиком

![Схема управления](img/intro/fly/fly12.png)

| Кнопка | Действие |
|---|---|
| **Y** | Взлёт |
| **A** | Посадка (управление сохраняется) |
| **X** | Аварийная остановка |
| Левый джойстик | Газ + Рыскание |
| Правый джойстик | Крен + Тангаж |

> **Безопасность:** Наклон более 60° = потеря управления, моторы останавливаются.

---

## 5. Установка драйверов

Подключите MicroUSB к компьютеру.

![Подключение USB](img/getting_start/driver/driver1.png)

Компьютер установит драйвер автоматически. Проверьте в Диспетчере устройств — должен появиться COM-порт.

![COM-порт в Диспетчере устройств](img/getting_start/driver/driver2.png)

---

## 6. Установка Thonny IDE

Скачайте с **https://thonny.org/** и установите.

![Выбор платформы на сайте Thonny](img/getting_start/ide/ide1.png)

После установки запустите Thonny:

![Окно Thonny IDE](img/getting_start/ide/ide2.png)

---

## 7. REPL — интерактивная отладка

**REPL** (Read-Eval-Print-Loop) — интерактивный интерпретатор Python для отладки.

### Подключение к плате

Нажмите на правый нижний угол Thonny:

![Нижний угол Thonny](img/getting_start/repl/repl1.png)

Выберите **Configure interpreter**:

![Configure interpreter](img/getting_start/repl/repl2.png)

Выберите "MicroPython (ESP32)" и нужный COM-порт:

![Настройка интерпретатора](img/getting_start/repl/repl3.png)

После успешного подключения в Shell отображается информация о прошивке:

![Успешное подключение](img/getting_start/repl/repl4.png)

Если появляется ошибка — проверьте драйвер и COM-порт:

![Ошибка подключения](img/getting_start/repl/repl5.png)

Нажмите **Выполнить → Прервать выполнение** для остановки блокирующей программы:

![Прервать выполнение](img/getting_start/repl/repl6.png)

Или нажмите кнопку "Стоп/Перезапустить бэкенд":

![Кнопка стоп](img/getting_start/repl/repl7.png)

### Тестирование REPL

Введите `print("Hello 01Studio!")` и нажмите Enter:

![Hello в REPL](img/getting_start/repl/repl8.png)

Введите `1+1`:

![Вычисление в REPL](img/getting_start/repl/repl9.png)

Управление светодиодом через REPL:

```python
from machine import Pin
LED = Pin(46, Pin.OUT)
LED.value(1)
```

![Код LED в REPL](img/getting_start/repl/repl10.png)

![LED загорелся](img/getting_start/repl/repl11.png)

При ошибке в коде REPL выведет подробное сообщение об ошибке:

![Сообщение об ошибке](img/getting_start/repl/repl12.png)

---

## 8. Файловая система

Нажмите **Вид → Файлы**:

![Меню файлы](img/getting_start/file_system/file_system1.png)

Появится панель с локальными файлами и файлами на плате:

![Файловый менеджер](img/getting_start/file_system/file_system2.png)

Проверьте свободное место: выпадающий список → Пространство хранения:

![Пространство хранения](img/getting_start/file_system/file_system3.png)

Общее пространство pyDrone — 6 МБ (прошивка занимает 2 МБ):

![6 МБ флеш](img/getting_start/file_system/file_system4.png)

---

## 9. Первый запуск кода

Откройте файл `main.py` примера LED в Thonny:

![Открытие файла](img/getting_start/demo/demo1.png)

Нажмите **Выполнить → Запустить текущий скрипт** или зелёную кнопку:

![Кнопка запуска](img/getting_start/demo/demo2.png)

Синий светодиод на плате загорается:

![LED загорелся](img/getting_start/demo/demo3.png)

---

## 10. Автозапуск кода при включении

Запуск в IDE хранит код в RAM — теряется при отключении питания. Для постоянного хранения используйте `main.py` на плате.

**Механизм загрузки MicroPython:**
- `boot.py` — выполняется первым (для инициализации)
- `main.py` — выполняется вторым (основной код)

Сохраните файл на плату через Thonny:

![Сохранение на плату](img/getting_start/run_offline/run_offline1.png)

После нажатия кнопки Reset LED загорается автоматически:

![Автозапуск](img/getting_start/run_offline/run_offline2.png)

![LED при включении](img/getting_start/run_offline/run_offline3.png)

---

## 11. Обновление прошивки

**Вход в режим загрузки:** удерживайте **BOOT (KEY)** и нажмите Reset.

![Кнопки BOOT и RST](img/getting_start/firmware/firmware1.png)

Откройте `flash_download_tools_v3.9.2.exe`:

![Инструмент прошивки](img/getting_start/firmware/firmware2.png)

Настройте: чип ESP32S3, режим develop, загрузка USB → OK:

![Конфигурация](img/getting_start/firmware/firmware3.png)

Выберите файл прошивки (адрес 0x000):

![Выбор прошивки](img/getting_start/firmware/firmware4.png)

Поставьте галочку перед файлом:

![Галочка](img/getting_start/firmware/firmware5.png)

Нажмите **ERASE** для стирания памяти:

![Стирание](img/getting_start/firmware/firmware6.png)

Нажмите **START** для прошивки:

![Прошивка](img/getting_start/firmware/firmware7.png)

---

## 12. GPIO — введение

Таблица соответствия GPIO-пинов pyDrone:

![Таблица GPIO](img/basic_examples/gpio_intro/pinout.png)

Расширительный интерфейс:

![Расширительный интерфейс](img/basic_examples/gpio_intro/pinout2.png)

![Расширительный интерфейс 2](img/basic_examples/gpio_intro/pinout3.png)

---

## 13. LED — светодиод

### Описание

На pyDrone есть 1 синий LED, подключённый к **GPIO46**.

![Схема подключения LED](img/basic_examples/led/led1.png)

### Объект Pin

**Конструктор:**

```python
from machine import Pin
LED = Pin(id, mode, pull)
```

- `id` — номер пина (например: 46)
- `mode` — `Pin.OUT` (вывод) или `Pin.IN` (ввод)
- `pull` — `Pin.PULL_UP`, `Pin.PULL_DOWN` или `None`

**Методы:**

```python
LED.value(1)   # Высокий уровень (включить)
LED.value(0)   # Низкий уровень (выключить)
LED.on()       # 3.3В
LED.off()      # 0В
```

### Пример кода

```python
'''
Эксперимент: Зажечь синий LED
Версия: v1.0 | Дата: 2022.6 | Автор: 01Studio
'''
from machine import Pin

led = Pin(46, Pin.OUT)   # GPIO46, режим вывода
led.value(1)              # Зажечь LED

while True:
    pass
```

### Результат

![LED горит в Thonny](img/basic_examples/led/led2.png)

![Синий LED на плате](img/basic_examples/led/led3.png)

---

## 14. Кнопки

### Описание

На pyDrone есть 1 кнопка (KEY), подключённая к **GPIO0**. При нажатии — низкий уровень "0".

![Схема кнопки](img/basic_examples/key/key1.png)

При нажатии кнопки возникает дребезг контактов — нужна программная защита:

![Дребезг контактов](img/basic_examples/key/key3.png)

### Пример кода

```python
'''
Эксперимент: Кнопка — переключение LED
Версия: v1.0 | Дата: 2022.6 | Автор: 01Studio
'''
from machine import Pin
import time

LED = Pin(46, Pin.OUT)
KEY = Pin(0, Pin.IN, Pin.PULL_UP)
state = 0

while True:
    if KEY.value() == 0:           # Нажата
        time.sleep_ms(10)          # Защита от дребезга
        if KEY.value() == 0:       # Подтверждение
            state = not state      # Переключить (не ~!)
            LED.value(state)
            while not KEY.value(): # Ждать отпускания
                pass
```

### Результат

![Результат нажатия кнопки](img/basic_examples/key/key4.png)

---

## 15. Внешние прерывания

### Описание

Кнопка KEY (GPIO0) в режиме прерывания — эффективнее постоянного опроса.

![Схема для прерывания](img/basic_examples/exti/exti0.png)

Концепция нарастающего и спадающего фронтов:

![Фронты сигнала](img/basic_examples/exti/exti1.png)

### Пример кода

```python
'''
Эксперимент: Внешнее прерывание
Версия: v1.0 | Дата: 2022.6 | Автор: 01Studio
'''
from machine import Pin
import time

LED = Pin(46, Pin.OUT)
KEY = Pin(0, Pin.IN, Pin.PULL_UP)
state = 0

def fun(KEY):
    global state
    time.sleep_ms(10)
    if KEY.value() == 0:
        state = not state
        LED.value(state)

KEY.irq(fun, Pin.IRQ_FALLING)   # Прерывание по спадающему фронту
```

### Результат

![Результат прерывания](img/basic_examples/exti/exti2.png)

---

## 16. Таймеры

### Описание

Таймер периодически вызывает функцию, не блокируя ЦП.

### Пример кода

```python
'''
Эксперимент: Таймер — мигание LED каждую секунду
Версия: v1.0 | Дата: 2022.4 | Автор: 01Studio
'''
from machine import Pin, Timer

led = Pin(46, Pin.OUT)
Counter = 0

def fun(tim):
    global Counter
    Counter += 1
    print(Counter)
    led.value(Counter % 2)

tim = Timer(-1)
tim.init(period=1000, mode=Timer.PERIODIC, callback=fun)
```

### Результат

![LED мигает каждую секунду](img/basic_examples/timer/timer1.png)

---

## 17. PWM — управление моторами

### Описание

ШИМ (PWM) — управление скоростью мотора через скважность сигнала.

При фиксированной частоте: больше скважность → выше напряжение → быстрее мотор:

![Принцип PWM](img/basic_examples/pwm/pwm1.gif)

Мотор M1 подключён к **GPIO4**:

![Схема мотора M1](img/basic_examples/pwm/pwm2.png)

### Объект PWM

```python
from machine import Pin, PWM
pwm = PWM(Pin(id), freq, duty)
```

- `freq` — частота в Гц (1–40 МГц)
- `duty` — скважность (0–1023)

### Пример кода

```python
'''
Эксперимент: PWM — управление мотором M1
Версия: v1.0 | Дата: 2022.4 | Автор: 01Studio
'''
from machine import Pin, PWM
import time

M1 = PWM(Pin(4), freq=10000, duty=0)

M1.duty(200)    # Малая скорость
time.sleep(1)
M1.duty(500)    # Средняя скорость
time.sleep(1)
M1.duty(1000)   # Высокая скорость
time.sleep(1)
M1.deinit()
```

### Результат

![Мотор вращается](img/basic_examples/pwm/pwm3.png)

Осциллограмма PWM-сигнала:

![Осциллограмма](img/basic_examples/pwm/pwm5.png)

---

## 18. ADC — измерение заряда батареи

### Описание

Аккумулятор (3.7–4.2В) подключён через делитель напряжения к **GPIO2**.

Схема делителя (40.2 кОм + 10 кОм):

![Схема делителя напряжения](img/basic_examples/adc/adc1.png)

**Формула:** `VBAT = ADC_value / 4095 * 5.02`

### Пример кода

```python
'''
Эксперимент: Измерение заряда батареи (ADC)
Версия: v1.0 | Дата: 2022.4 | Автор: 01Studio
'''
from machine import Pin, ADC, Timer

adc = ADC(Pin(2))   # GPIO2

def ADC_Test(tim):
    # 0.96 — коэффициент коррекции погрешности
    v = adc.read() / 4095 * 5.02 * 0.96
    print('Батарея: ' + str('%.2f' % v) + 'В')

tim = Timer(1)
tim.init(period=1000, mode=Timer.PERIODIC, callback=ADC_Test)
```

### Результат

![Вывод напряжения в REPL](img/basic_examples/adc/adc2.png)

> Уровень заряда батареи ниже 3.1В во время полёта = низкий заряд, необходимо приземлиться.

---

## 19. Подключение к WiFi-роутеру

ESP32-S3 имеет встроенный WiFi-модуль. Подключение через режим STA:

```python
import network, time
from machine import Pin

def WIFI_Connect():
    WIFI_LED = Pin(46, Pin.OUT)
    wlan = network.WLAN(network.STA_IF)
    wlan.active(True)
    start_time = time.time()

    if not wlan.isconnected():
        print('Подключение...')
        wlan.connect('ИМЯ_WIFI', 'ПАРОЛЬ')   # ← введите свои данные
        while not wlan.isconnected():
            WIFI_LED.value(1); time.sleep_ms(300)
            WIFI_LED.value(0); time.sleep_ms(300)
            if time.time() - start_time > 15:
                print('Таймаут!')
                break

    if wlan.isconnected():
        WIFI_LED.value(1)
        print('IP:', wlan.ifconfig())
        return True
    return False

WIFI_Connect()
```

> **Важно:** Только WiFi 2.4 ГГц. Сети 5 ГГц не поддерживаются.

---

## 20. Socket-связь

### Описание

Socket — основа интернет-коммуникаций. Клиент (pyDrone) → подключается по IP + порт → Сервер (компьютер).

### Пример кода

```python
'''
Эксперимент: Socket TCP-соединение
Версия: v1.0 | Автор: 01Studio
'''
import network, usocket, time
from machine import Pin, Timer

def WIFI_Connect():
    # ... (см. раздел 19)
    pass

if WIFI_Connect():
    s = usocket.socket()
    addr = ('192.168.1.100', 10000)  # ← IP сервера и порт
    s.connect(addr)
    s.send('Hello from pyDrone!')

    while True:
        text = s.recv(128)
        if text:
            print(text)
            s.send('Получено: ' + text.decode('utf-8'))
        time.sleep_ms(300)
```

---

## 21. MQTT-связь

### Описание

MQTT — лёгкий протокол IoT по модели публикации/подписки.

- **Издатель** публикует данные в тему (topic)
- **Подписчик** получает данные из темы через брокер

### Пример кода — Издатель

```python
'''
MQTT — Издатель | Автор: 01Studio
'''
import network, time
from simple import MQTTClient    # simple.py нужно загрузить на плату!
from machine import Pin, Timer

def WIFI_Connect(): pass         # см. раздел 19

def MQTT_Send(tim):
    client.publish(TOPIC, 'Hello from pyDrone!')

if WIFI_Connect():
    SERVER = 'mq.tongxinmao.com'
    PORT = 18830
    CLIENT_ID = 'pyDrone-001'
    TOPIC = '/public/pydrone/data'

    client = MQTTClient(CLIENT_ID, SERVER, PORT)
    client.connect()
    tim = Timer(-1)
    tim.init(period=1000, mode=Timer.PERIODIC, callback=MQTT_Send)
```

### Пример кода — Подписчик

```python
'''
MQTT — Подписчик | Автор: 01Studio
'''
from simple import MQTTClient
from machine import Timer

def WIFI_Connect(): pass

def MQTT_callback(topic, msg):
    print('Тема:', topic)
    print('Сообщение:', msg)

def MQTT_Rev(tim):
    client.check_msg()

if WIFI_Connect():
    SERVER = 'mq.tongxinmao.com'
    PORT = 18830
    CLIENT_ID = 'pyDrone-002'
    TOPIC = '/public/pydrone/cmd'

    client = MQTTClient(CLIENT_ID, SERVER, PORT)
    client.set_callback(MQTT_callback)
    client.connect()
    client.subscribe(TOPIC)
    tim = Timer(1)
    tim.init(period=300, mode=Timer.PERIODIC, callback=MQTT_Rev)
```

> **Зависимость:** Перед запуском загрузите `simple.py` (библиотека MQTT) на плату через Thonny.

---

## 22. Основы квадрокоптера

### Ориентация летательного аппарата

Система координат X/Y/Z:

![Система координат летательного аппарата](img/drone/basic/basic1.jpg)

Roll, Pitch, Yaw — три угла ориентации:

![Roll Pitch Yaw](img/drone/basic/basic2.png)

### Принцип полёта вертолёта

Вертолёт — вертикальный взлёт за счёт несущего винта:

![Вертолёт](img/drone/basic/basic3.jpg)

Хвостовой винт компенсирует реактивный момент:

![Хвостовой ротор](img/drone/basic/basic4.png)

Наклон корпуса создаёт горизонтальную тягу:

![Движение вперёд](img/drone/basic/basic5.jpg)

### Принцип полёта квадрокоптера

Расположение моторов и направления вращения:

![Квадрокоптер — моторы](img/drone/basic/basic6.png)

M1, M3 — против часовой стрелки; M2, M4 — по часовой. Симметрия гасит реактивный момент.

При суммарной подъёмной силе > веса — квадрокоптер поднимается:

![Подъём](img/drone/basic/basic7.jpg)

Встроенный IMU непрерывно отслеживает ориентацию:

![IMU](img/drone/basic/basic8.png)

### Система координат pyDrone

![Координаты pyDrone](img/drone/basic/basic9.png)

---

## 23. Заводской пример

Заводской пример интегрирует BLE-управление (аналогично следующему разделу). pyController дополнительно включает: NES-игры, управление машинкой pyCar, тест джойстика — всё с графическим интерфейсом.

---

## 24. Управление по Bluetooth

### Платформа

pyDrone + джойстик pyController:

![pyDrone](img/drone/ble_control/ble_control1.png)

![pyController](img/drone/ble_control/ble_control2.png)

### Схема BLE-соединения

```
pyDrone (ведомый) → начинает рекламу "pyDrone"
pyController (ведущий) → сканирует → подключается → управляет
```

### Код pyDrone (BLE ведомое устройство)

```python
'''
Управление по Bluetooth — pyDrone
Версия: v1.0 | Дата: 2022.6 | Автор: 01Studio
'''
import bluetooth, ble_simple_peripheral, time
import drone

d = drone.DRONE(flightmode=0, debug=1)   # Безголовый режим

while True:
    print(d.read_cal_data())
    if d.read_calibrated():
        break
    time.sleep_ms(100)

ble = bluetooth.BLE()
p = ble_simple_peripheral.BLESimplePeripheral(ble, name='pyDrone')

def on_rx(text):
    control_data = [None] * 4
    for i in range(4):
        if 100 < text[i+1] < 155:
            control_data[i] = 0
        elif text[i+1] <= 100:
            control_data[i] = text[i+1] - 100
        else:
            control_data[i] = text[i+1] - 155

    d.control(rol=control_data[0], pit=control_data[1],
              yaw=control_data[2], thr=control_data[3])

    if text[5] == 24:    d.take_off(distance=120)   # Y — взлёт
    if text[5] == 72:    d.landing()                 # A — посадка
    if text[5] == 136:   d.stop()                    # X — стоп

    states = d.read_states()
    state_buf = [None] * 18
    for i in range(9):
        state_buf[i*2]   = int((states[i] + 32768) / 256)
        state_buf[i*2+1] = int((states[i] + 32768) % 256)
    p.send(bytes(state_buf))

p.on_write(on_rx)
```

### Процедура запуска

Загрузите код на обе платы (pyDrone и pyController):

![Загрузка кода](img/drone/ble_control/ble_control3.png)

![Файлы на плате](img/drone/ble_control/ble_control4.png)

Установите горизонтально, нажмите Reset:

![Горизонтальное положение](img/drone/ble_control/ble_control5.png)

Калибровка — синий LED мигает, затем горит постоянно:

![Калибровка завершена](img/drone/ble_control/ble_control6.png)

Включите джойстик — отображается список дронов с MAC и уровнем сигнала:

![Список дронов](img/drone/ble_control/ble_control7.png)

![Уровень сигнала](img/drone/ble_control/ble_control8.png)

Выбор нескольких устройств кнопками вверх/вниз, долгое нажатие START:

![Выбор устройства](img/drone/ble_control/ble_control9.png)

Зелёный LED = подключено:

![Подключено](img/drone/ble_control/ble_control10.png)

Данные дрона на экране джойстика:

![Данные на экране](img/drone/ble_control/ble_control11.png)

Схема управления:

![Управление](img/drone/ble_control/ble_control12.png)

Направление камеры = нос дрона:

![Направление носа](img/drone/ble_control/ble_control13.png)

---

## 25. Управление по WiFi

### Платформа

![pyDrone WiFi](img/drone/wifi_control/wifi_control1.png)

![pyController WiFi](img/drone/wifi_control/wifi_control2.png)

### Описание

WiFi обеспечивает дальность до **150 м** (Bluetooth — до 60 м).

Используется **Socket UDP** для максимальной реальности времени:
- pyDrone — точка доступа (AP) "pyDrone", без пароля
- pyController — клиент (STA), подключается к AP

### Код pyDrone (WiFi AP)

```python
'''
WiFi управление — pyDrone
Версия: v1.0 | Дата: 2022.6 | Автор: 01Studio
'''
import network, socket, time
from machine import Timer
import drone

d = drone.DRONE(flightmode=0)

while True:
    print(d.read_cal_data())
    if d.read_calibrated():
        break
    time.sleep_ms(100)

def startAP():
    wlan_ap = network.WLAN(network.AP_IF)
    wlan_ap.active(True)
    wlan_ap.config(essid='pyDrone', authmode=0)
    while not wlan_ap.isconnected():
        pass

startAP()

s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
s.bind(('0.0.0.0', 2390))

data, addr = s.recvfrom(128)
s.connect(addr)
s.setblocking(False)

def Socket_fun(tim):
    try:
        text = s.recv(128)
        control_data = [None] * 4
        for i in range(4):
            if 100 < text[i+1] < 155:    control_data[i] = 0
            elif text[i+1] <= 100:        control_data[i] = text[i+1] - 100
            else:                          control_data[i] = text[i+1] - 155

        d.control(rol=control_data[0], pit=control_data[1],
                  yaw=control_data[2], thr=control_data[3])

        if text[5] == 24:    d.take_off(distance=120)
        if text[5] == 72:    d.landing()
        if text[5] == 136:   d.stop()

        states = d.read_states()
        state_buf = [None] * 18
        for i in range(9):
            state_buf[i*2]   = int((states[i] + 32768) / 256)
            state_buf[i*2+1] = int((states[i] + 32768) % 256)
        s.send(bytes(state_buf))
    except OSError:
        pass

tim = Timer(1)
tim.init(period=50, mode=Timer.PERIODIC, callback=Socket_fun)
```

### Процедура запуска

Подключите аккумулятор горизонтально, нажмите Reset:

![Горизонтально](img/drone/wifi_control/wifi_control3.png)

Калибровка завершена — синий LED постоянно горит:

![Калибровка](img/drone/wifi_control/wifi_control4.png)

Джойстик подключается к WiFi-хот-споту pyDrone:

![Подключение WiFi](img/drone/wifi_control/wifi_control5.png)

Зелёный LED = успешное подключение:

![Подключено](img/drone/wifi_control/wifi_control6.png)

Данные дрона на экране:

![Данные](img/drone/wifi_control/wifi_control7.png)

Схема управления:

![Управление](img/drone/wifi_control/wifi_control8.png)

Направление камеры = нос дрона:

![Нос дрона](img/drone/wifi_control/wifi_control9.png)

---

## 26. Справочник API: объект DRONE

### Конструктор

```python
import drone
d = drone.DRONE(flightmode=0)
```

- `0` — безголовый режим (по умолчанию, для помещений)
- `1` — режим с головой (для улицы)

### Методы

| Метод | Описание |
|---|---|
| `d.read_cal_data()` | Данные калибровки (3 значения X/Y/Z, все < 5000 = пройдена) |
| `d.read_calibrated()` | Статус калибровки: 1 = пройдена, 0 = не пройдена |
| `d.take_off(distance=80)` | Взлёт и зависание на высоте `distance` см (диапазон: 30–2000 см) |
| `d.landing()` | Плавная посадка (управление направлением сохраняется) |
| `d.stop()` | Аварийная остановка (все моторы немедленно) |
| `d.control(rol, pit, yaw, thr)` | Управление ориентацией (все параметры: -100 ~ 100) |
| `d.read_states()` | Состояние дрона (кортеж из 9 значений) |

### d.control() — подробно

| Параметр | Движение | "-" | "+" |
|---|---|---|---|
| `rol` | Крен (влево/вправо) | Влево | Вправо |
| `pit` | Тангаж (вперёд/назад) | Назад | Вперёд |
| `yaw` | Рыскание (вращение) | Против часовой | По часовой |
| `thr` | Газ (вверх/вниз) | Вниз | Вверх |

### d.read_states() — расшифровка

| Индекс | Описание | Диапазон |
|---|---|---|
| 0 | Roll (крен) | -18000 ~ 18000 (×100°) |
| 1 | Pitch (тангаж) | -18000 ~ 18000 (×100°) |
| 2 | Yaw (рыскание) | -18000 ~ 18000 (×100°) |
| 3 | Roll от джойстика | -1000 ~ 1000 |
| 4 | Pitch от джойстика | -1000 ~ 1000 |
| 5 | Yaw от джойстика | -200 ~ 200 |
| 6 | Газ от джойстика | 0 ~ 100 (%, ~50 в центре) |
| 7 | Заряд батареи | единицы: 10 мВ |
| 8 | Относительная высота | единицы: см |

---

## Дополнительные ресурсы

| Ресурс | Ссылка |
|---|---|
| GitHub pyDrone | https://github.com/01studio-lab/pyDrone |
| GitHub вики (исходники) | https://github.com/01studio-lab/01studio_wiki |
| Официальная вики | https://wiki.01studio.cc/en/docs/pydrone |
| Схема (PDF) | https://www.01studio.cc/data/sch/pyDrone_Sch.pdf |
| Документация MicroPython | https://docs.micropython.org/en/latest/ |
| MicroPython на русском | https://micropython-ru.readthedocs.io/ru/latest/ |
| Видео сборки и полёта | https://b23.tv/BV1ct4y1V7qG |

---

*Перевод на основе открытого репозитория 01Studio (MIT License). Все изображения © 01Studio.*
