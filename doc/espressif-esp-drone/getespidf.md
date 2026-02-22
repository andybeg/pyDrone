<!-- Переведено с https://docs.espressif.com/projects/espressif-esp-drone/en/latest/ -->
<!-- Оригинал: английский | Перевод: русский | Инструмент: Google Translate API -->

# Настройка среды разработки

[中文]

## Настройка среды ESP-IDF

Пожалуйста, обратитесь к Руководству по программированию ESP-IDF и настройте среду ESP-IDF шаг за шагом.

- Предлагается версия ветки ESP-IDF /v4.4.
- Пожалуйста, следуйте и выполните все шаги настройки.
- Создайте пример ESP-IDF, чтобы убедиться, что установка прошла успешно.

## Получить исходный код проекта

Бета-код, который в настоящее время находится в репозитории GitHub, доступен с помощью git:

```
git clone https://github.com/espressif/esp-drone.git

```

Программное обеспечение проекта в основном состоит из ядра управления полетом, драйверов оборудования и библиотек зависимостей:

- Ядро управления полетом взято из Crazyflie и в основном включает в себя уровень аппаратной абстракции и программу управления полетом.
- Драйверы оборудования структурированы в файлы в соответствии с аппаратными интерфейсами, включая устройства I2C и устройства SPI.
- Библиотеки зависимостей включают компоненты по умолчанию, предоставляемые ESP-IDF, а также DSP сторонних производителей.

Структура файла кода следующая:

![espdrone_file_structure](_images/espdrone_file_structure.png)

```
.
├── components                        | project components directory
│   ├── config                              | system task configuration
│   │   └── include
│   ├── core                                 | system kernel directory
│   │   └── crazyflie                  | Crazyflie kernel
│   │       ├── hal                         | hardware abstraction code
│   │       └── modules             |  flight control code
│   ├── drivers                            | hardware driver directory
│   │   ├── deck                         | hardware extention interface driver
│   │   ├── general                    | general device directory
│   │   │   ├── adc                     | ADC driver for voltage monitoring
│   │   │   ├── buzzer              | buzzer driver for status feedback
│   │   │   ├── led                     | LED driver for status feedback
│   │   │   ├── motors             | motor driver for thrust output
│   │   │   └── wifi                    | Wi-Fi driver for communication
│   │   ├── i2c_bus                   | I2C driver
│   │   ├── i2c_devices           | I2C device directory
│   │   │   ├── eeprom           | EEPROM driver for parameter storage
│   │   │   ├── hmc5883l         | HMC5883l magnetic compass sensor
│   │   │   ├── mpu6050          | MPU6050 gyroscopic accelerometer sensor
│   │   │   ├── ms5611             | MS5611 air pressure sensor
│   │   │   ├── vl53l0                 | Vl53l0 laser sensor (maximum distance 2 m)
│   │   │   └── vl53l1                 |  Vl53l1 laser sensor（maximum distance 4 m）
│   │   └── spi_devices           | SPI devices directory
│   │       └── pmw3901           | PMW3901 optical flow sensor
│   ├── lib                                      | external repository directory
│   │   └── dsp_lib                    | DSP repository
│   ├── platform                         | support multi-platform
│   └── utils                                  | utility function directory
├── CMakeLists.txt                    | utility function
├── LICENSE                                | open source protocol
├── main                                       | entry function
├── README.md                        | project description
└── sdkconfig.defaults            | default parameter

```

Для получения дополнительной информации обратитесь к: espdrone_file_structure.

## Стиль исходного кода

Два способа поиска в одной и той же области (объединение)

Одну и ту же область памяти можно искать двумя способами:

```
typedef union {
  struct {
        float x;
        float y;
        float z;
  };
  float axis[3];
} Axis3f;

```

Подсчет с использованием типов перечисления

По умолчанию первый член перечисления имеет значение 0, поэтому элемент SensorImplementation_COUNT всегда может представлять общее количество определенных элементов перечисления перед ним.

```
typedef enum {
  #ifdef SENSOR_INCLUDED_BMI088_BMP388
  SensorImplementation_bmi088_bmp388,
  #endif

  #ifdef SENSOR_INCLUDED_BMI088_SPI_BMP388
  SensorImplementation_bmi088_spi_bmp388,
  #endif

  #ifdef SENSOR_INCLUDED_MPU9250_LPS25H
  SensorImplementation_mpu9250_lps25h,
  #endif

  #ifdef SENSOR_INCLUDED_MPU6050_HMC5883L_MS5611
  SensorImplementation_mpu6050_HMC5883L_MS5611,
  #endif

  #ifdef SENSOR_INCLUDED_BOSCH
  SensorImplementation_bosch,
  #endif

  SensorImplementation_COUNT,
} SensorImplementation_t;

```

Тип упакованных данных

```
struct cppmEmuPacket_s {
  struct {
      uint8_t numAuxChannels : 4;   // Set to 0 through MAX_AUX_RC_CHANNELS
      uint8_t reserved : 4;
  } hdr;
  uint16_t channelRoll;
  uint16_t channelPitch;
  uint16_t channelYaw;
  uint16_t channelThrust;
  uint16_t channelAux[MAX_AUX_RC_CHANNELS];
} __attribute__((packed));

```

Целью __attribute__ ((packed)) является отключение оптимизированного выравнивания при компиляции структуры. Таким образом, структура выравнивается на основе ее фактических байтов. Это синтаксис, специфичный для GCC, который не имеет ничего общего с вашей операционной системой, но связан с компилятором. В операционной системе Windows компилятор GCC и VC не поддерживает упакованный режим, тогда как компилятор TC поддерживает такой режим.

```
In TC：struct my{ char ch; int a;} sizeof(int)=2;sizeof(my)=3; (compact mode)
In GCC：struct my{ char ch; int a;} sizeof(int)=4;sizeof(my)=8; (non-compact mode)
In GCC：struct my{ char ch; int a;}__attrubte__ ((packed)) sizeof(int)=4;sizeof(my)=5

```
