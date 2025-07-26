@echo off
chcp 65001 >nul
echo.
echo ========================================
echo 🚀 机器人小狗最简构建脚本
echo ========================================
echo.

set "GCC_PATH=C:\ST\STM32CubeIDE_1.19.0\STM32CubeIDE\plugins\com.st.stm32cube.ide.mcu.externaltools.gnu-tools-for-stm32.13.3.rel1.win32_1.0.0.202411081344\tools\bin"

echo 🏗️ 创建构建目录...
if not exist "build" mkdir build

echo.
echo 🧹 清理旧文件...
del /q build\*.o 2>nul
del /q build\*.elf 2>nul
del /q build\*.hex 2>nul
del /q build\*.bin 2>nul

echo.
echo 🔧 单文件编译链接...
"%GCC_PATH%\arm-none-eabi-gcc.exe" ^
    -mcpu=cortex-m3 ^
    -mthumb ^
    -Wall ^
    -O2 ^
    -g ^
    -DUSE_STDPERIPH_DRIVER ^
    -I./src ^
    -I./lib/CMSIS/Include ^
    -I./lib/CMSIS/Device/ST/STM32F10x/Include ^
    -Wl,--gc-sections ^
    -Wl,-Map=build\robot_dog_simple.map ^
    -T stm32f103c8.ld ^
    startup_stm32f103xb.s ^
    src\system_stm32f1xx.c ^
    src\main.c ^
    src\custom_features.c ^
    -o build\robot_dog_simple.elf

if %ERRORLEVEL% neq 0 (
    echo ❌ 编译失败！
    pause
    exit /b 1
)
echo ✅ 编译成功！

echo.
echo 📦 生成固件文件...
"%GCC_PATH%\arm-none-eabi-objcopy.exe" -O ihex build\robot_dog_simple.elf build\robot_dog_simple.hex
"%GCC_PATH%\arm-none-eabi-objcopy.exe" -O binary build\robot_dog_simple.elf build\robot_dog_simple.bin

echo.
echo 📊 程序信息...
"%GCC_PATH%\arm-none-eabi-size.exe" build\robot_dog_simple.elf

echo.
echo ========================================
echo ✅ 构建完成！
echo ========================================
echo.
echo 📁 输出文件:
if exist "build\robot_dog_simple.hex" (
    echo    - HEX文件: build\robot_dog_simple.hex
    for %%f in (build\robot_dog_simple.hex) do echo      大小: %%~zf 字节
)
if exist "build\robot_dog_simple.bin" (
    echo    - BIN文件: build\robot_dog_simple.bin
    for %%f in (build\robot_dog_simple.bin) do echo      大小: %%~zf 字节
)
echo.
echo 🎯 烧录步骤:
echo    1. 在FlyMCU中选择 build\robot_dog_simple.hex
echo    2. 烧录地址设置为: 0x08000000
echo    3. 点击"开始编程"
echo.
pause
