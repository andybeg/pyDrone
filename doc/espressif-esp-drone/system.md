<!-- Переведено с https://docs.espressif.com/projects/espressif-esp-drone/en/latest/ -->
<!-- Оригинал: английский | Перевод: русский | Инструмент: Google Translate API -->

# Система управления полетом

[中文]

## Процесс запуска

![start_from_app_main](_images/start_from_app_main.png)

Для исходного файла проверьте start_from_app_main .

## Управление задачами

### Задачи

Следующие ЗАДАЧИ запускаются, когда система работает правильно.

![task_dump](_images/task_dump.png)

Дамп задач

- Нагрузка: загрузка процессора
- Стек слева: оставшееся место в стеке.
- Имя: имя задачи
- PRI: приоритет задачи

ЗАДАЧИ описываются следующим образом:

- PWRMGNT: контроль напряжения системы
- CMDHL: прикладной уровень — обработка расширенных команд на основе протокола CRTP.
- CRTP-RX: уровень протокола - декодирование протокола полета CRTP
- CRTP-TX: уровень протокола — декодирование протокола полета CRTP
- UDP-RX: транспортный уровень — получение UDP-пакета
- UDP-TX: транспортный уровень — отправка UDP-пакета
- WIFILINK: работа с уровнем протокола CRTP и транспортным уровнем UDP.
- ДАТЧИКИ: считывание и предварительная обработка данных датчиков.
- КАЛМАН: оценить состояние дрона по данным датчиков, включая угол наклона дрона, угловую скорость и пространственное положение. Эта ЗАДАЧА потребляет большое количество ресурсов ЦП на чипе ESP, и пользователям следует внимательно относиться к распределению ее приоритетов.
- PARAM: удаленное изменение переменных по протоколу CRTP.
- LOG: мониторинг переменных в режиме реального времени в соответствии с протоколом CRTP.
- MEM: удаленное изменение памяти по протоколу CRTP.
- СТАБИЛИЗАТОР: самостоятельно стабилизирует свою нить и контролирует процесс программы управления полетом.
- СИСТЕМА: инициализация системы управления и процесс самотестирования.

### Настройка размера стека задач

Пользователи могут изменить размер стека в компонентах/config/include/config.h или изменить BASE_STACK_SIZE в менюcfg. Если целью является ESP32, вы можете настроить BASE_STACK_SIZE на 2048, чтобы избежать перекрытия памяти. Если целью является ESP32-S2, измените значение на 1024.

```
//Task stack size
#define SYSTEM_TASK_STACKSIZE         (4* configBASE_STACK_SIZE)
#define ADC_TASK_STACKSIZE            configBASE_STACK_SIZE
#define PM_TASK_STACKSIZE             (2*configBASE_STACK_SIZE)
#define CRTP_TX_TASK_STACKSIZE        (2*configBASE_STACK_SIZE)
#define CRTP_RX_TASK_STACKSIZE        (2* configBASE_STACK_SIZE)
#define CRTP_RXTX_TASK_STACKSIZE      configBASE_STACK_SIZE
#define LOG_TASK_STACKSIZE            (2*configBASE_STACK_SIZE)
#define MEM_TASK_STACKSIZE            (1 * configBASE_STACK_SIZE)
#define PARAM_TASK_STACKSIZE          (2*configBASE_STACK_SIZE)
#define SENSORS_TASK_STACKSIZE        (2 * configBASE_STACK_SIZE)
#define STABILIZER_TASK_STACKSIZE     (2 * configBASE_STACK_SIZE)
#define NRF24LINK_TASK_STACKSIZE      configBASE_STACK_SIZE
#define ESKYLINK_TASK_STACKSIZE       configBASE_STACK_SIZE
#define SYSLINK_TASK_STACKSIZE        configBASE_STACK_SIZE
#define USBLINK_TASK_STACKSIZE        configBASE_STACK_SIZE
#define WIFILINK_TASK_STACKSIZE        (2*configBASE_STACK_SIZE)
#define UDP_TX_TASK_STACKSIZE   (2*configBASE_STACK_SIZE)
#define UDP_RX_TASK_STACKSIZE   (2*configBASE_STACK_SIZE)
#define UDP_RX2_TASK_STACKSIZE   (1*configBASE_STACK_SIZE)
#define PROXIMITY_TASK_STACKSIZE      configBASE_STACK_SIZE
#define EXTRX_TASK_STACKSIZE          configBASE_STACK_SIZE
#define UART_RX_TASK_STACKSIZE        configBASE_STACK_SIZE
#define ZRANGER_TASK_STACKSIZE        (1* configBASE_STACK_SIZE)
#define ZRANGER2_TASK_STACKSIZE       (2* configBASE_STACK_SIZE)
#define FLOW_TASK_STACKSIZE           (2* configBASE_STACK_SIZE)
#define USDLOG_TASK_STACKSIZE         (1* configBASE_STACK_SIZE)
#define USDWRITE_TASK_STACKSIZE       (1* configBASE_STACK_SIZE)
#define PCA9685_TASK_STACKSIZE        (1* configBASE_STACK_SIZE)
#define CMD_HIGH_LEVEL_TASK_STACKSIZE (1* configBASE_STACK_SIZE)
#define MULTIRANGER_TASK_STACKSIZE    (1* configBASE_STACK_SIZE)
#define ACTIVEMARKER_TASK_STACKSIZE   configBASE_STACK_SIZE
#define AI_DECK_TASK_STACKSIZE        configBASE_STACK_SIZE
#define UART2_TASK_STACKSIZE          configBASE_STACK_SIZE

```

### Настроить приоритет задачи

Приоритет системных задач можно настроить вComponents/config/include/config.h. ESP32, благодаря своему двухъядерному преимуществу, имеет больше вычислительных ресурсов, чем ESP32-S2, поэтому его трудоемкому KALMAN_TASK можно установить более высокий приоритет. Но если целью является ESP32-S2, понизьте приоритет KALMAN_TASK, иначе сработает сторожевой таймер задачи из-за невозможности высвободить достаточно ресурсов ЦП.

```
//Task priority: the higher the number, the higher the priority.
#define STABILIZER_TASK_PRI     5
#define SENSORS_TASK_PRI        4
#define ADC_TASK_PRI            3
#define FLOW_TASK_PRI           3
#define MULTIRANGER_TASK_PRI    3
#define SYSTEM_TASK_PRI         2
#define CRTP_TX_TASK_PRI        2
#define CRTP_RX_TASK_PRI        2
#define EXTRX_TASK_PRI          2
#define ZRANGER_TASK_PRI        2
#define ZRANGER2_TASK_PRI       2
#define PROXIMITY_TASK_PRI      0
#define PM_TASK_PRI             0
#define USDLOG_TASK_PRI         1
#define USDWRITE_TASK_PRI       0
#define PCA9685_TASK_PRI        2
#define CMD_HIGH_LEVEL_TASK_PRI 2
#define BQ_OSD_TASK_PRI         1
#define GTGPS_DECK_TASK_PRI     1
#define LIGHTHOUSE_TASK_PRI     3
#define LPS_DECK_TASK_PRI       5
#define OA_DECK_TASK_PRI        3
#define UART1_TEST_TASK_PRI     1
#define UART2_TEST_TASK_PRI     1
//if task watchdog triggered, KALMAN_TASK_PRI should set lower or set lower flow frequency
#ifdef CONFIG_IDF_TARGET_ESP32
  #define KALMAN_TASK_PRI         2
  #define LOG_TASK_PRI            1
  #define MEM_TASK_PRI            1
  #define PARAM_TASK_PRI          1
#else
  #define KALMAN_TASK_PRI         1
  #define LOG_TASK_PRI            2
  #define MEM_TASK_PRI            2
  #define PARAM_TASK_PRI          2
#endif

#define SYSLINK_TASK_PRI        3
#define USBLINK_TASK_PRI        3
#define ACTIVE_MARKER_TASK_PRI  3
#define AI_DECK_TASK_PRI        3
#define UART2_TASK_PRI          3
#define WIFILINK_TASK_PRI       3
#define UDP_TX_TASK_PRI         3
#define UDP_RX_TASK_PRI         3
#define UDP_RX2_TASK_PRI        3

```

## Ключевые задачи

За исключением задач, включенных в систему по умолчанию, таких как ЗАДАЧА Wi-Fi, задача с наивысшим приоритетом — STABILIZER_TASK , что подчеркивает важность этой задачи. STABILIZER_TASK контролирует весь процесс: от считывания данных датчиков, расчета ориентации, приема цели до конечной выходной мощности двигателя, а также управляет алгоритмами на каждом этапе.

![stabilizerTask process](_images/General-framework-of-the-stabilization-structure-of-the-crazyflie-with-setpoint-handling.png)

СтабилизаторЗадача Процесс

![stabilizerTask](_images/stabilizerTask.png)

СтабилизаторЗадача

## Драйвер датчика

Код драйвера датчика можно найти в папкеComponents\drivers. Drivers применяет файловую структуру, аналогичную той, которая используется в esp-iot-solution. В такой структуре драйверы классифицируются по шине, к которой они принадлежат, включая i2c_devices, spi_devices и General. Дополнительную информацию см. в разделе Драйверы.

![drivers_flie_struture](_images/drivers_flie_struture.png)

Файловая структура драйверов

## Абстракция сенсорного оборудования

Components\core\crazyflie\hal\src\sensors.c предоставляет аппаратную абстракцию для датчиков. Пользователи могут комбинировать датчики для взаимодействия с приложением верхнего уровня, реализуя интерфейсы датчиков, определенные уровнем абстракции оборудования.

```
typedef struct {
  SensorImplementation_t implements;
  void (*init)(void);
  bool (*test)(void);
  bool (*areCalibrated)(void);
  bool (*manufacturingTest)(void);
  void (*acquire)(sensorData_t *sensors, const uint32_t tick);
  void (*waitDataReady)(void);
  bool (*readGyro)(Axis3f *gyro);
  bool (*readAcc)(Axis3f *acc);
  bool (*readMag)(Axis3f *mag);
  bool (*readBaro)(baro_t *baro);
  void (*setAccMode)(accModes accMode);
  void (*dataAvailableCallback)(void);
} sensorsImplementation_t;

```

Интерфейсы абстракции датчиков, реализованные ESP-Drone, перечислены в файлеComponents/core/crazyflie/hal/src/sensors_mpu6050_hm5883L_ms5611.c, который может взаимодействовать с приложением верхнего уровня посредством следующего процесса назначения.

```
#ifdef SENSOR_INCLUDED_MPU6050_HMC5883L_MS5611
  {
    .implements = SensorImplementation_mpu6050_HMC5883L_MS5611,
    .init = sensorsMpu6050Hmc5883lMs5611Init,
    .test = sensorsMpu6050Hmc5883lMs5611Test,
    .areCalibrated = sensorsMpu6050Hmc5883lMs5611AreCalibrated,
    .manufacturingTest = sensorsMpu6050Hmc5883lMs5611ManufacturingTest,
    .acquire = sensorsMpu6050Hmc5883lMs5611Acquire,
    .waitDataReady = sensorsMpu6050Hmc5883lMs5611WaitDataReady,
    .readGyro = sensorsMpu6050Hmc5883lMs5611ReadGyro,
    .readAcc = sensorsMpu6050Hmc5883lMs5611ReadAcc,
    .readMag = sensorsMpu6050Hmc5883lMs5611ReadMag,
    .readBaro = sensorsMpu6050Hmc5883lMs5611ReadBaro,
    .setAccMode = sensorsMpu6050Hmc5883lMs5611SetAccMode,
    .dataAvailableCallback = nullFunction,
  }
#endif

```

## Калибровка датчика

### Калибровка гироскопа

Из-за большого температурного дрейфа гироскоп необходимо калибровать перед каждым использованием, чтобы рассчитать его эталонные значения в текущих условиях. ESP-Drone продолжает схему калибровки гироскопа, предоставленную Crazyflie 2.0. При первом включении рассчитываются дисперсия и среднее значение по трем осям гироскопа.

Подробная калибровка гироскопа выглядит следующим образом:

- Сохраните последние 1024 набора измерений гироскопа в кольцевом буфере с максимальной длиной 1024.
- Рассчитайте отклонение выходных значений гироскопа, чтобы проверить, расположен ли дрон ровно и работает ли гироскоп правильно.
- Если шаг 2 выполнен правильно, рассчитайте среднее из 1024 наборов выходных значений гироскопа в качестве калибровочного значения.

Ниже приведен исходный код для расчета базы гироскопа:

```
/**
 * Adds a new value to the variance buffer and if it is full
 * replaces the oldest one. Thus a circular buffer.
 */
static void sensorsAddBiasValue(BiasObj* bias, int16_t x, int16_t y, int16_t z)
{
  bias->bufHead->x = x;
  bias->bufHead->y = y;
  bias->bufHead->z = z;
  bias->bufHead++;

  if (bias->bufHead >= &bias->buffer[SENSORS_NBR_OF_BIAS_SAMPLES])
  {
    bias->bufHead = bias->buffer;
    bias->isBufferFilled = true;
  }
}

/**
 * Checks if the variances is below the predefined thresholds.
 * The bias value should have been added before calling this.
 * @param bias  The bias object
 */
static bool sensorsFindBiasValue(BiasObj* bias)
{
  static int32_t varianceSampleTime;
  bool foundBias = false;

  if (bias->isBufferFilled)
  {
    sensorsCalculateVarianceAndMean(bias, &bias->variance, &bias->mean);

    if (bias->variance.x < GYRO_VARIANCE_THRESHOLD_X &&
        bias->variance.y < GYRO_VARIANCE_THRESHOLD_Y &&
        bias->variance.z < GYRO_VARIANCE_THRESHOLD_Z &&
        (varianceSampleTime + GYRO_MIN_BIAS_TIMEOUT_MS < xTaskGetTickCount()))
    {
      varianceSampleTime = xTaskGetTickCount();
      bias->bias.x = bias->mean.x;
      bias->bias.y = bias->mean.y;
      bias->bias.z = bias->mean.z;
      foundBias = true;
      bias->isBiasValueFound = true;
    }
  }

  return foundBias;
}

```

Подстройка выходных значений гироскопа

```
sensorData.gyro.x = (gyroRaw.x - gyroBias.x) * SENSORS_DEG_PER_LSB_CFG;
sensorData.gyro.y = (gyroRaw.y - gyroBias.y) * SENSORS_DEG_PER_LSB_CFG;
sensorData.gyro.z = (gyroRaw.z - gyroBias.z) * SENSORS_DEG_PER_LSB_CFG;
applyAxis3fLpf((lpf2pData *)(&gyroLpf), &sensorData.gyro); // LPF Filter, to avoid high-frequency interference

```

### Калибровка акселерометра

#### Гравитационное ускорение (g) Калибровка

Значения g обычно различны на разных широтах и ​​высотах Земли, поэтому для измерения фактического g требуется акселерометр. Схема калибровки акселерометра, предоставленная Crazyflie 2.0, может быть вам справочной, а процесс калибровки значения g выглядит следующим образом:

- После завершения калибровки гироскопа немедленно выполняется калибровка акселерометра.
- Сохраните 200 наборов измерений акселерометра в буфере.
- Рассчитайте значение g в состоянии покоя, синтезировав вес g по трем осям.

Дополнительную информацию см. в разделе Значения на различных широтах и ​​высотах.

Рассчитайте значения g в состоянии покоя

```
/**
 * Calculates accelerometer scale out of SENSORS_ACC_SCALE_SAMPLES samples. Should be called when
 * platform is stable.
 */
static bool processAccScale(int16_t ax, int16_t ay, int16_t az)
{
    static bool accBiasFound = false;
    static uint32_t accScaleSumCount = 0;

    if (!accBiasFound)
    {
        accScaleSum += sqrtf(powf(ax * SENSORS_G_PER_LSB_CFG, 2) + powf(ay * SENSORS_G_PER_LSB_CFG, 2) + powf(az * SENSORS_G_PER_LSB_CFG, 2));
        accScaleSumCount++;

        if (accScaleSumCount == SENSORS_ACC_SCALE_SAMPLES)
        {
            accScale = accScaleSum / SENSORS_ACC_SCALE_SAMPLES;
            accBiasFound = true;
        }
    }

    return accBiasFound;
}

```

Обрезать измерения акселерометра по фактическим значениям g

```
accScaled.x = (accelRaw.x) * SENSORS_G_PER_LSB_CFG / accScale;
accScaled.y = (accelRaw.y) * SENSORS_G_PER_LSB_CFG / accScale;
accScaled.z = (accelRaw.z) * SENSORS_G_PER_LSB_CFG / accScale;

```

#### Калибровка дрона на горизонтальном уровне

В идеале акселерометр устанавливается на дроне горизонтально, что позволяет использовать 0-е положение в качестве горизонтальной поверхности дрона. Однако из-за неизбежного наклона акселерометра при установке система управления полетом не может точно оценить горизонтальное положение, в результате чего дрон летит в определенном направлении. Следовательно, необходимо установить определенную стратегию калибровки, чтобы сбалансировать эту ошибку.

- Поместите дрон на горизонтальную поверхность и вычислите cosRoll , sinRoll , cosPitch и sinPitch . В идеале cosRoll и cosPitch равны 1. sinPitch и sinRoll равны 0. Если акселерометр установлен не горизонтально, sinPitch и sinRoll не равны 0. cosRoll и cosPitch не равны 1.
- Сохраните cosRoll , sinRoll , cosPitch и sinPitch, полученные на шаге 1, или соответствующие значения Roll и Pitch в дрон для калибровки.

Используйте значение калибровки для обрезки измерений акселерометра:

```
/**
 * Compensate for a miss-aligned accelerometer. It uses the trim
 * data gathered from the UI and written in the config-block to
 * rotate the accelerometer to be aligned with gravity.
 */
static void sensorsAccAlignToGravity(Axis3f *in, Axis3f *out)
{
    //TODO: need cosPitch calculate firstly
    Axis3f rx;
    Axis3f ry;

    // Rotate around x-axis
    rx.x = in->x;
    rx.y = in->y * cosRoll - in->z * sinRoll;
    rx.z = in->y * sinRoll + in->z * cosRoll;

    // Rotate around y-axis
    ry.x = rx.x * cosPitch - rx.z * sinPitch;
    ry.y = rx.y;
    ry.z = -rx.x * sinPitch + rx.z * cosPitch;

    out->x = ry.x;
    out->y = ry.y;
    out->z = ry.z;
}

```

Вышеупомянутый процесс можно вывести с помощью разрешения силы и теоремы Пифагора.

## Расчет отношения

### Поддерживаемые алгоритмы расчета отношения

- Дополнительная фильтрация
- Фильтрация Калмана

Расчет отношения, используемый в ESP-Drone, взят из Crazyflie. Прошивка ESP-Drone была протестирована на дополнительную фильтрацию и фильтрацию Калмана для эффективного расчета ориентации полета, включая угол, угловую скорость и пространственное положение, обеспечивая надежный ввод состояния для системы управления. Обратите внимание, что в режиме удержания позиции необходимо переключиться на алгоритм фильтрации Калмана, чтобы обеспечить правильную работу.

Оценку статуса Crazyflie можно найти в разделе Оценка состояния: Быть или не быть!

### Дополнительная фильтрация

![Extended-Kalman-Filter](_images/Schematic-overview-of-inputs-and-outputs-of-the-Complementary-filter.png)

Дополнительная фильтрация

### Фильтрация Калмана

![Extended-Kalman-Filter](_images/Schematic-overview-of-inputs-and-outputs-of-the-Extended-Kalman-Filter.png)

Расширенная фильтрация Калмана

## Алгоритмы управления боем

### Поддерживаемый контроллер

Код системы управления, используемый в ESP-Drone, взят от Crazyflie и продолжает все его алгоритмы. Обратите внимание, что ESP-Drone протестировал и настроил только параметры ПИД-регулятора. При использовании других контроллеров настраивайте параметры, обеспечивая безопасность.

![possible_controller_pathways](_images/possible_controller_pathways.png)

Возможные пути контроллера

Для получения дополнительной информации см. «Выход из-под контроля».

В коде вы можете изменить входные параметры контроллера ControllerInit (ControllerType Controller), чтобы переключить контроллер.

Настраиваемые контроллеры также можно добавить, реализовав следующие интерфейсы контроллеров.

```
static ControllerFcns controllerFunctions[] = {
  {.init = 0, .test = 0, .update = 0, .name = "None"}, // Any
  {.init = controllerPidInit, .test = controllerPidTest, .update = controllerPid, .name = "PID"},
  {.init = controllerMellingerInit, .test = controllerMellingerTest, .update = controllerMellinger, .name = "Mellinger"},
  {.init = controllerINDIInit, .test = controllerINDITest, .update = controllerINDI, .name = "INDI"},
};

```

### ПИД-регулятор

Как работает ПИД-регулятор

ПИД-регулятор (пропорционально-интегрально-производный регулятор) состоит из пропорционального, интегрального и производного блоков, соответствующих текущей ошибке, прошлой накопленной ошибке и будущей ошибке соответственно, а затем управляет системой на основе ошибки и скорости изменения ошибок. ПИД
Контроллер считается наиболее подходящим контроллером из-за его коррекции отрицательной обратной связи. Регулируя ПИД
Используя три параметра контроллера, вы можете настроить скорость реакции системы на ошибку, степень раскачивания и тряски контроллера, чтобы система могла достичь оптимального состояния.

Эта система дрона имеет три параметра управления: тангаж, крен и рыскание, поэтому необходимо спроектировать ПИД-регулятор с замкнутым контуром, как показано на рисунке ниже.

![Crazyflie Control System](https://img-blog.csdnimg.cn/20190929142813169.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzIwNTE1NDYx,size_16,color_FFFFFF,t_70)

Система управления Crazyflie

Для каждого измерения управления предоставляется ПИД-регулятор строкового уровня, состоящий из контроллера скорости и контроллера отношения. Регулятор скорости используется для управления скоростью коррекции угла на основе ввода угловой скорости. Контроллер ориентации используется для управления дроном для полета под заданным углом на основе введенных углов установки. Два контроллера могут работать вместе на разных частотах. Конечно, вы также можете использовать только
один одноуровневый ПИД-регулятор, в котором размеры управления по тангажу и крену по умолчанию контролируются с помощью Attitude и рыскания.
контролируется ставкой.

```
You can modify the parameters in crtp_commander_rpyt.c:
static RPYType stabilizationModeRoll  = ANGLE; // Current stabilization type of roll (rate or angle)
static RPYType stabilizationModePitch = ANGLE; // Current stabilization type of pitch (rate or angle)
static RPYType stabilizationModeYaw   = RATE;  // Current stabilization type of yaw (rate or angle)

```

Код реализации

```
void controllerPid(control_t *control, setpoint_t *setpoint,
                                         const sensorData_t *sensors,
                                         const state_t *state,
                                         const uint32_t tick)
{
  if (RATE_DO_EXECUTE(ATTITUDE_RATE, tick)) { // This macro controls PID calculation frequency based on the interrupts triggered by MPU6050
    // Rate-controled YAW is moving YAW angle setpoint
    if (setpoint->mode.yaw == modeVelocity) {                                                    //rate mode, correct yaw
       attitudeDesired.yaw += setpoint->attitudeRate.yaw * ATTITUDE_UPDATE_DT;
      while (attitudeDesired.yaw > 180.0f)
        attitudeDesired.yaw -= 360.0f;
      while (attitudeDesired.yaw < -180.0f)
        attitudeDesired.yaw += 360.0f;
    } else {                                                                                                               //attitude mode
      attitudeDesired.yaw = setpoint->attitude.yaw;
    }
  }

  if (RATE_DO_EXECUTE(POSITION_RATE, tick)) {                                               //Position control
    positionController(&actuatorThrust, &attitudeDesired, setpoint, state);
  }

  if (RATE_DO_EXECUTE(ATTITUDE_RATE, tick)) {
    // Switch between manual and automatic position control
    if (setpoint->mode.z == modeDisable) {
      actuatorThrust = setpoint->thrust;
    }
    if (setpoint->mode.x == modeDisable || setpoint->mode.y == modeDisable) {
      attitudeDesired.roll = setpoint->attitude.roll;
      attitudeDesired.pitch = setpoint->attitude.pitch;
    }

    attitudeControllerCorrectAttitudePID(state->attitude.roll, state->attitude.pitch, state->attitude.yaw,
                                attitudeDesired.roll, attitudeDesired.pitch, attitudeDesired.yaw,
                                &rateDesired.roll, &rateDesired.pitch, &rateDesired.yaw);

    // For roll and pitch, if velocity mode, overwrite rateDesired with the setpoint
    // value. Also reset the PID to avoid error buildup, which can lead to unstable
    // behavior if level mode is engaged later
    if (setpoint->mode.roll == modeVelocity) {
      rateDesired.roll = setpoint->attitudeRate.roll;
      attitudeControllerResetRollAttitudePID();
    }
    if (setpoint->mode.pitch == modeVelocity) {
      rateDesired.pitch = setpoint->attitudeRate.pitch;
      attitudeControllerResetPitchAttitudePID();
    }

    // TODO: Investigate possibility to subtract gyro drift.
    attitudeControllerCorrectRatePID(sensors->gyro.x, -sensors->gyro.y, sensors->gyro.z,
                             rateDesired.roll, rateDesired.pitch, rateDesired.yaw);

    attitudeControllerGetActuatorOutput(&control->roll,
                                        &control->pitch,
                                        &control->yaw);

    control->yaw = -control->yaw;
  }

  if (tiltCompensationEnabled)
  {
    control->thrust = actuatorThrust / sensfusion6GetInvThrustCompensationForTilt();
  }
  else
  {
    control->thrust = actuatorThrust;
  }

  if (control->thrust == 0)
  {
    control->thrust = 0;
    control->roll = 0;
    control->pitch = 0;
    control->yaw = 0;

    attitudeControllerResetAllPID();
    positionControllerResetAllPID();

    // Reset the calculated YAW angle for rate control
    attitudeDesired.yaw = state->attitude.yaw;
  }
}

```

### Контроллер Меллингера

Контроллер Меллингера — это универсальный контроллер, который напрямую рассчитывает необходимую тягу, распределяемую для всех двигателей, на основе целевого положения и вектора скорости в целевом положении.

Для справки: создание минимальной траектории привязки и контроль
квадроторы.

### ИНДИ-контроллер

Контроллер INDI — это контроллер, который немедленно обрабатывает угловые скорости для определения
надежность данных. Этот контроллер можно использовать вместе с традиционным ПИД-регулятором.
который обеспечивает более быструю обработку угла, чем ПИД-регулятор строкового уровня.

Для справки: Адаптивная инкрементальная нелинейная динамическая инверсия для управления ориентацией микровоздуха.
Транспортные средства.

## Настройка параметров ПИД-регулятора

ПИД-регулятор скорости Crazyflie настраивается следующим образом:

- Сначала отрегулируйте режим скорости: установите для RollType, PitchType и yawType значение RATE;
- Настройте режим ATTITUDE: установите KP, KI и KD крена, тангажа и рыскания на 0,0 и оставьте неизменными только параметры скорости.
- Настройте режим RATE: установите KI, KD крена, тангажа и рыскания на 0,0. Сначала установите КП.
- Запишите код и начните настройку КП онлайн, используя функцию param cfclient.
- Обратите внимание, что параметры, измененные с помощью cfclient, не будут сохранены при выключении питания;
- Во время настройки ПИД-регулятора может произойти тряска (перенастройка), будьте осторожны.
- Удерживайте дрон, чтобы убедиться, что он может вращаться только вокруг оси тангажа. Постепенно увеличивайте КП шага, пока дрон не начнет раскачиваться вперед и назад.
- Если дрон сильно трясется, немного уменьшите KP, обычно на 5–10 % ниже критической точки тряски.
- Таким же образом настройте крен и рыскание.
- Отрегулируйте KI, чтобы устранить установившиеся ошибки. Если только с пропорциональной регулировкой, но без этого параметра, дрон может раскачиваться вверх и вниз в положении 0 из-за помех, таких как сила тяжести. Установите начальное значение KI на 50% от KP.
- Когда КИ увеличивается до определенного значения, дрон начинает трястись. Но по сравнению с тряской, вызванной КИ, тряска, вызванная КП, является более низкочастотной. Запомните момент, когда дрон начнет трястись, и отметьте этот KI как критическую точку. Итоговый показатель KI должен быть на 5–10 % ниже этой критической точки.
- Таким же образом настройте крен и рыскание.
- В целом значение КИ должно быть более 80% от КП.

Настройка параметров ПИД-регулятора скорости завершена.

Приступим к настройке Attitude PID.

- Сначала убедитесь, что настройка PID скорости завершена.
- Установите для RollType, PitchType и yawType значение ANGLE, т. е. теперь дрон находится в режиме ориентации.
- Установите KI и KD крена и тангажа на 0,0, а затем установите KP, KI и KD рыскания на 0,0.
- Запишите код и начните настройку КП онлайн, используя функцию param cfclient.
- Установите КП крена и тангажа на 3,5. Проверьте наличие нестабильности, например тряски. Продолжайте увеличивать КП, пока не будет достигнут предел;
- Если KP уже вызывает нестабильность дрона или значение превышает 4, уменьшите KP и KI режима RATE на 5% ~ 10%. Таким образом, у нас будет больше свободы в настройке режима Attitude.
- Если вам все еще необходимо отрегулировать KI, снова медленно увеличивайте KI. Если возникают низкочастотные тряски, это указывает на то, что ваш дрон находится в нестабильном состоянии.
