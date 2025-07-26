@echo off
chcp 65001 >nul
echo.
echo ========================================
echo 🚀 机器人小狗超简LED测试版本
echo ========================================
echo.

set "GCC_PATH=C:\ST\STM32CubeIDE_1.19.0\STM32CubeIDE\plugins\com.st.stm32cube.ide.mcu.externaltools.gnu-tools-for-stm32.13.3.rel1.win32_1.0.0.202411081344\tools\bin"

echo 🏗️ 创建构建目录...
if not exist "build" mkdir build

echo.
echo 🧹 清理旧文件...
del /q build\robot_dog_led.* 2>nul

echo.
echo 🔧 一次性编译链接...
"%GCC_PATH%\arm-none-eabi-gcc.exe" ^
    -mcpu=cortex-m3 ^
    -mthumb ^
    -Wall ^
    -O1 ^
    -g ^
    -fno-common ^
    -ffunction-sections ^
    -fdata-sections ^
    -DUSE_STDPERIPH_DRIVER ^
    -I./src ^
    -I./lib/CMSIS/Include ^
    -I./lib/CMSIS/Device/ST/STM32F10x/Include ^
    -Wl,--gc-sections ^
    -Wl,-Map=build\robot_dog_led.map ^
    -Wl,--cref ^
    -T stm32f103c8.ld ^
    -nostartfiles ^
    --specs=nano.specs ^
    startup_stm32f103xb.s ^
    src\system_stm32f1xx.c ^
    src\main_simple.c ^
    -o build\robot_dog_led.elf

if %ERRORLEVEL% neq 0 (
    echo ❌ 编译失败！
    echo.
    echo 🔍 让我们尝试详细诊断...
    echo 检查文件是否存在:
    if exist "startup_stm32f103xb.s" echo ✅ startup_stm32f103xb.s
    if exist "src\system_stm32f1xx.c" echo ✅ src\system_stm32f1xx.c
    if exist "src\main_simple.c" echo ✅ src\main_simple.c
    if exist "stm32f103c8.ld" echo ✅ stm32f103c8.ld
    pause
    exit /b 1
)
echo ✅ 编译成功！

echo.
echo 📦 生成固件文件...
"%GCC_PATH%\arm-none-eabi-objcopy.exe" -O ihex build\robot_dog_led.elf build\robot_dog_led.hex
"%GCC_PATH%\arm-none-eabi-objcopy.exe" -O binary build\robot_dog_led.elf build\robot_dog_led.bin

echo.
echo 📊 程序信息...
"%GCC_PATH%\arm-none-eabi-size.exe" build\robot_dog_led.elf

echo.
echo 📁 检查输出文件...
if exist "build\robot_dog_led.hex" (
    for %%f in (build\robot_dog_led.hex) do (
        echo ✅ HEX文件: build\robot_dog_led.hex ^(%%~zf 字节^)
        if %%~zf GTR 0 (
            echo    ✅ 文件大小正常，可以烧录！
        ) else (
            echo    ❌ 文件大小为0，有问题！
        )
    )
) else (
    echo ❌ HEX文件生成失败！
)

if exist "build\robot_dog_led.bin" (
    for %%f in (build\robot_dog_led.bin) do (
        echo ✅ BIN文件: build\robot_dog_led.bin ^(%%~zf 字节^)
        if %%~zf GTR 0 (
            echo    ✅ 文件大小正常！
        ) else (
            echo    ❌ 文件大小为0，有问题！
        )
    )
) else (
    echo ❌ BIN文件生成失败！
)

echo.
echo ========================================
echo ✅ LED测试固件构建完成！
echo ========================================
echo.
echo 🎯 烧录指南:
echo    1. 打开FlyMCU软件
echo    2. 选择芯片型号: STM32F103C8
echo    3. 选择HEX文件: build\robot_dog_led.hex
echo    4. 烧录地址: 0x08000000
echo    5. 点击"开始编程"
echo    6. 成功后重启开发板，LED会闪烁
echo.
echo 💡 预期效果: PC13引脚的LED每500ms闪烁一次
echo.
pause
