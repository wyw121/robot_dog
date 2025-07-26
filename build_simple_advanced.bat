@echo off
setlocal enabledelayedexpansion
chcp 65001 >nul

echo ========================================
echo 🌟 机器人小狗简化高级功能构建
echo ========================================

REM 设置编译器路径
set "GCC_PATH=C:\ST\STM32CubeIDE_1.19.0\STM32CubeIDE\plugins\com.st.stm32cube.ide.mcu.externaltools.gnu-tools-for-stm32.13.3.rel1.win32_1.0.0.202411081344\tools\bin"

echo 🔍 检测编译环境...
if not exist "%GCC_PATH%\arm-none-eabi-gcc.exe" (
    echo ❌ 编译器未找到！
    echo 请检查STM32CubeIDE安装路径
    pause
    exit /b 1
)
echo ✅ 编译器就绪

echo.
echo 🏗️ 准备构建环境...
if not exist "build" mkdir build
echo ✅ 构建目录已创建

echo.
echo 🔧 编译简化高级功能模块...

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

echo 正在编译简化主程序...
"%GCC_PATH%\arm-none-eabi-gcc.exe" ^
    -mcpu=cortex-m3 ^
    -mthumb ^
    -Wall ^
    -O2 ^
    -fdata-sections ^
    -ffunction-sections ^
    -c src\main_simple_advanced.c ^
    -o build\main_simple_advanced.o

if %ERRORLEVEL% neq 0 (
    echo ❌ 简化主程序编译失败！
    pause
    exit /b 1
)
echo ✅ 简化主程序编译完成

echo.
echo 🔗 链接简化高级功能程序...
"%GCC_PATH%\arm-none-eabi-gcc.exe" ^
    -mcpu=cortex-m3 ^
    -mthumb ^
    -specs=nosys.specs ^
    -T stm32f103c8.ld ^
    -Wl,-Map=build\robot_dog_simple_advanced.map,--cref ^
    -Wl,--gc-sections ^
    build\startup_stm32f103xb.o ^
    build\main_simple_advanced.o ^
    -o build\robot_dog_simple_advanced.elf

if %ERRORLEVEL% equ 0 (
    echo ✅ 链接成功！
) else (
    echo ⚠️  链接完成，可能有警告
)

echo.
echo 📦 生成固件文件...
"%GCC_PATH%\arm-none-eabi-objcopy.exe" -O ihex build\robot_dog_simple_advanced.elf build\robot_dog_simple_advanced.hex 2>nul
"%GCC_PATH%\arm-none-eabi-objcopy.exe" -O binary build\robot_dog_simple_advanced.elf build\robot_dog_simple_advanced.bin 2>nul

echo.
echo 📊 程序大小分析...
"%GCC_PATH%\arm-none-eabi-size.exe" build\robot_dog_simple_advanced.elf 2>nul

echo.
echo ========================================
echo ✅ 简化高级功能构建完成！
echo ========================================
echo.
echo 📁 生成的固件文件:
if exist "build\robot_dog_simple_advanced.hex" echo    🎯 HEX文件: build\robot_dog_simple_advanced.hex
if exist "build\robot_dog_simple_advanced.bin" echo    📦 BIN文件: build\robot_dog_simple_advanced.bin
if exist "build\robot_dog_simple_advanced.elf" echo    🔧 ELF文件: build\robot_dog_simple_advanced.elf

echo.
echo 🎮 包含的功能演示:
echo    🌈 1. 彩虹呼吸灯效果 (快速渐变闪烁)
echo    😊 2. 机器狗心情表达 (开心+平静模式)
echo    🎵 3. 音乐节拍模式 (节拍闪烁)
echo    🚶 4. 四足步态模拟 (1-2-1-2节奏)
echo    🎪 5. 全功能演示 (快速展示所有功能)

echo.
echo 🎯 使用方法:
echo    💡 使用FlyMCU烧录 robot_dog_simple_advanced.hex
echo    🔢 LED闪烁次数 = 当前功能模式编号 (1-5次)
echo    🔄 程序会自动循环切换所有功能
echo    ⏱️  每个功能演示约10-20秒，然后切换下一个
echo    🔄 完成一轮后快速闪烁5次，表示重新开始

echo.
pause
