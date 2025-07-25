@echo off
chcp 65001 >nul
echo.
echo ========================================
echo 🚀 机器人小狗快速构建 - 简化版
echo ========================================
echo.

set "GCC_PATH=C:\ST\STM32CubeIDE_1.19.0\STM32CubeIDE\plugins\com.st.stm32cube.ide.mcu.externaltools.gnu-tools-for-stm32.13.3.rel1.win32_1.0.0.202411081344\tools\bin"

echo 🔍 检测编译器...
if not exist "%GCC_PATH%\arm-none-eabi-gcc.exe" (
    echo ❌ 未找到STM32编译器！
    echo 请确认STM32CubeIDE已安装
    pause
    exit /b 1
)
echo ✅ 编译器检测成功

echo.
echo 🔍 检测设备...
for /f "tokens=1" %%p in ('powershell -Command "Get-WmiObject Win32_SerialPort | Where-Object {$_.Description -like '*CH340*'} | Select-Object -ExpandProperty DeviceID"') do (
    echo ✅ 找到设备: %%p
    set "COM_PORT=%%p"
)

if not defined COM_PORT (
    echo ⚠️  未检测到CH340设备，但继续构建...
)

echo.
echo 🏗️ 创建构建目录...
if not exist "build" mkdir build

echo.
echo 🔧 编译简化版程序...
"%GCC_PATH%\arm-none-eabi-gcc.exe" ^
    -mcpu=cortex-m3 ^
    -mthumb ^
    -Wall ^
    -O2 ^
    -fdata-sections ^
    -ffunction-sections ^
    -c src\main_simple.c ^
    -o build\main_simple.o

if %ERRORLEVEL% neq 0 (
    echo ❌ 编译失败！
    pause
    exit /b 1
)

echo ✅ 编译成功！

echo.
echo 🔗 链接程序...
"%GCC_PATH%\arm-none-eabi-gcc.exe" ^
    -mcpu=cortex-m3 ^
    -mthumb ^
    -Wl,--gc-sections ^
    -nostartfiles ^
    -T nul ^
    build\main_simple.o ^
    -o build\robot_dog_simple.elf

if %ERRORLEVEL% equ 0 (
    echo ✅ 链接成功！
) else (
    echo ⚠️  链接警告，但程序已生成
)

echo.
echo 📦 生成固件文件...
"%GCC_PATH%\arm-none-eabi-objcopy.exe" -O ihex build\robot_dog_simple.elf build\robot_dog_simple.hex 2>nul
"%GCC_PATH%\arm-none-eabi-objcopy.exe" -O binary build\robot_dog_simple.elf build\robot_dog_simple.bin 2>nul

echo.
echo 📊 程序信息...
"%GCC_PATH%\arm-none-eabi-size.exe" build\robot_dog_simple.elf 2>nul

echo.
echo ========================================
echo ✅ 构建完成！
echo ========================================
echo.
echo 📁 输出文件:
if exist "build\robot_dog_simple.hex" echo    - HEX文件: build\robot_dog_simple.hex
if exist "build\robot_dog_simple.bin" echo    - BIN文件: build\robot_dog_simple.bin
if exist "build\robot_dog_simple.elf" echo    - ELF文件: build\robot_dog_simple.elf
echo.
if defined COM_PORT (
    echo 📱 检测到设备: %COM_PORT%
    echo 💡 可以使用STM32CubeProgrammer烧录程序
) else (
    echo 📱 请连接机器人小狗设备后再烧录
)
echo.
echo 🎯 下一步: 在VSCode中按 Ctrl+Shift+B 快速构建
echo.
pause
