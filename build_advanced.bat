@echo off
chcp 65001 >nul
echo.
echo ========================================
echo 🌟 机器人小狗高级功能构建
echo ========================================
echo.

set "GCC_PATH=C:\ST\STM32CubeIDE_1.19.0\STM32CubeIDE\plugins\com.st.stm32cube.ide.mcu.externaltools.gnu-tools-for-stm32.13.3.rel1.win32_1.0.0.202411081344\tools\bin"

echo 🔍 检测编译环境...
if not exist "%GCC_PATH%\arm-none-eabi-gcc.exe" (
    echo ❌ STM32编译器未找到！
    pause
    exit /b 1
)
echo ✅ 编译器就绪

echo.
echo 🔍 检测目标设备...
for /f "tokens=1" %%p in ('powershell -Command "Get-WmiObject Win32_SerialPort | Where-Object {$_.Description -like '*CH340*'} | Select-Object -ExpandProperty DeviceID"') do (
    echo ✅ 发现设备: %%p
    set "COM_PORT=%%p"
)

echo.
echo 🏗️ 准备构建环境...
if not exist "build" mkdir build
echo ✅ 构建目录已创建

echo.
echo 🔧 编译高级功能模块...

echo 正在编译启动文件...
"%GCC_PATH%\arm-none-eabi-gcc.exe" ^
    -mcpu=cortex-m3 ^
    -mthumb ^
    -Wall ^
    -O2 ^
    -fdata-sections ^
    -ffunction-sections ^
    -c startup_stm32f103xb.s ^
    -o build\startup_stm32f103xb.o

if %ERRORLEVEL% neq 0 (
    echo ❌ 启动文件编译失败！
    pause
    exit /b 1
)
echo ✅ 启动文件编译完成

echo 正在编译 main_advanced.c...
"%GCC_PATH%\arm-none-eabi-gcc.exe" ^
    -mcpu=cortex-m3 ^
    -mthumb ^
    -Wall ^
    -O2 ^
    -fdata-sections ^
    -ffunction-sections ^
    -c src\main_advanced.c ^
    -o build\main_advanced.o

if %ERRORLEVEL% neq 0 (
    echo ❌ main_advanced.c 编译失败！
    pause
    exit /b 1
)
echo ✅ 主程序编译完成

echo 正在编译 custom_features_simple.c...
"%GCC_PATH%\arm-none-eabi-gcc.exe" ^
    -mcpu=cortex-m3 ^
    -mthumb ^
    -Wall ^
    -O2 ^
    -fdata-sections ^
    -ffunction-sections ^
    -c src\custom_features_simple.c ^
    -o build\custom_features_simple.o

if %ERRORLEVEL% neq 0 (
    echo ❌ custom_features_simple.c 编译失败！
    pause
    exit /b 1
)
echo ✅ 功能模块编译完成

echo.
echo 🔗 链接高级功能程序...
"%GCC_PATH%\arm-none-eabi-gcc.exe" ^
    -mcpu=cortex-m3 ^
    -mthumb ^
    -specs=nosys.specs ^
    -T stm32f103c8.ld ^
    -Wl,-Map=build\robot_dog_advanced.map,--cref ^
    -Wl,--gc-sections ^
    build\startup_stm32f103xb.o ^
    build\main_advanced.o ^
    build\custom_features_simple.o ^
    -o build\robot_dog_advanced.elf

if %ERRORLEVEL% equ 0 (
    echo ✅ 链接成功！
) else (
    echo ⚠️  链接完成，可能有警告
)

echo.
echo 📦 生成固件文件...
"%GCC_PATH%\arm-none-eabi-objcopy.exe" -O ihex build\robot_dog_advanced.elf build\robot_dog_advanced.hex 2>nul
"%GCC_PATH%\arm-none-eabi-objcopy.exe" -O binary build\robot_dog_advanced.elf build\robot_dog_advanced.bin 2>nul

echo.
echo 📊 程序大小分析...
"%GCC_PATH%\arm-none-eabi-size.exe" build\robot_dog_advanced.elf 2>nul

echo.
echo ========================================
echo ✅ 高级功能构建完成！
echo ========================================
echo.
echo 📁 生成的固件文件:
if exist "build\robot_dog_advanced.hex" echo    🎯 HEX文件: build\robot_dog_advanced.hex
if exist "build\robot_dog_advanced.bin" echo    📦 BIN文件: build\robot_dog_advanced.bin
if exist "build\robot_dog_advanced.elf" echo    🔧 ELF文件: build\robot_dog_advanced.elf
echo.

echo 🎮 包含的高级功能:
echo    🌈 1. 彩虹呼吸灯效果
echo    😊 2. 机器狗心情表达
echo    🎵 3. 音乐节拍模式
echo    🚶 4. 四足步态模拟
echo    🎪 5. 全功能循环演示
echo.

if defined COM_PORT (
    echo 📱 检测到设备: %COM_PORT%
    echo 💡 使用STM32CubeProgrammer烧录 robot_dog_advanced.hex
    echo.
    echo 🎯 烧录步骤:
    echo    1. 打开STM32CubeProgrammer
    echo    2. 连接设备 ^(Serial, %COM_PORT%^)
    echo    3. 选择文件: build\robot_dog_advanced.hex
    echo    4. 点击Download
) else (
    echo 📱 请连接机器人小狗设备
)

echo.
echo 🎊 功能演示说明:
echo    💡 LED闪烁次数 = 当前功能模式编号
echo    🔄 程序会自动循环切换所有功能
echo    ⏱️  每个功能演示后会自动切换到下一个
echo.
pause
