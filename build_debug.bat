@echo off
chcp 65001 >nul
echo.
echo ========================================
echo 🚀 机器人小狗详细构建脚本（调试版）
echo ========================================
echo.

set "GCC_PATH=C:\ST\STM32CubeIDE_1.19.0\STM32CubeIDE\plugins\com.st.stm32cube.ide.mcu.externaltools.gnu-tools-for-stm32.13.3.rel1.win32_1.0.0.202411081344\tools\bin"

echo 🔍 检测编译器...
if not exist "%GCC_PATH%\arm-none-eabi-gcc.exe" (
    echo ❌ 未找到STM32编译器！
    pause
    exit /b 1
)
echo ✅ 编译器检测成功

echo.
echo 🏗️ 创建构建目录...
if not exist "build" mkdir build

echo.
echo 🧹 清理旧文件...
del /q build\*.o 2>nul
del /q build\*.elf 2>nul
del /q build\*.hex 2>nul
del /q build\*.bin 2>nul
del /q build\*.map 2>nul

echo.
echo 🔧 详细编译所有文件...

echo 编译启动文件...
"%GCC_PATH%\arm-none-eabi-gcc.exe" -v -mcpu=cortex-m3 -mthumb -Wall -O2 -g -DUSE_STDPERIPH_DRIVER -I./src -I./lib/CMSIS/Include -I./lib/CMSIS/Device/ST/STM32F10x/Include -I./lib/STM32F10x_StdPeriph_Driver/inc -c startup_stm32f103xb.s -o build\startup_stm32f103xb.o

echo.
echo 编译系统文件...
"%GCC_PATH%\arm-none-eabi-gcc.exe" -v -mcpu=cortex-m3 -mthumb -Wall -O2 -g -DUSE_STDPERIPH_DRIVER -I./src -I./lib/CMSIS/Include -I./lib/CMSIS/Device/ST/STM32F10x/Include -I./lib/STM32F10x_StdPeriph_Driver/inc -c src\system_stm32f1xx.c -o build\system_stm32f1xx.o

echo.
echo 编译自定义功能...
"%GCC_PATH%\arm-none-eabi-gcc.exe" -v -mcpu=cortex-m3 -mthumb -Wall -O2 -g -DUSE_STDPERIPH_DRIVER -I./src -I./lib/CMSIS/Include -I./lib/CMSIS/Device/ST/STM32F10x/Include -I./lib/STM32F10x_StdPeriph_Driver/inc -c src\custom_features.c -o build\custom_features.o

echo.
echo 编译主程序...
"%GCC_PATH%\arm-none-eabi-gcc.exe" -v -mcpu=cortex-m3 -mthumb -Wall -O2 -g -DUSE_STDPERIPH_DRIVER -I./src -I./lib/CMSIS/Include -I./lib/CMSIS/Device/ST/STM32F10x/Include -I./lib/STM32F10x_StdPeriph_Driver/inc -c src\main.c -o build\main.o

echo.
echo 🔗 详细链接程序...
"%GCC_PATH%\arm-none-eabi-gcc.exe" -v -mcpu=cortex-m3 -mthumb -Wl,--gc-sections -Wl,-Map=build\robot_dog.map -T stm32f103c8.ld build\startup_stm32f103xb.o build\system_stm32f1xx.o build\custom_features.o build\main.o -o build\robot_dog.elf

if %ERRORLEVEL% neq 0 (
    echo ❌ 链接失败！
    echo.
    echo 检查目标文件中的符号...
    "%GCC_PATH%\arm-none-eabi-objdump.exe" -t build\custom_features.o | findstr Custom
    echo.
    "%GCC_PATH%\arm-none-eabi-objdump.exe" -t build\main.o | findstr Custom
    pause
    exit /b 1
)
echo ✅ 链接成功！

echo.
echo 📦 生成固件文件...
"%GCC_PATH%\arm-none-eabi-objcopy.exe" -O ihex build\robot_dog.elf build\robot_dog.hex
"%GCC_PATH%\arm-none-eabi-objcopy.exe" -O binary build\robot_dog.elf build\robot_dog.bin

echo.
echo 📊 程序信息...
"%GCC_PATH%\arm-none-eabi-size.exe" build\robot_dog.elf

echo.
echo ========================================
echo ✅ 构建完成！
echo ========================================
echo.
echo 📁 输出文件:
if exist "build\robot_dog.hex" echo    - HEX文件: build\robot_dog.hex
if exist "build\robot_dog.bin" echo    - BIN文件: build\robot_dog.bin
if exist "build\robot_dog.elf" echo    - ELF文件: build\robot_dog.elf
echo.
echo 💡 现在可以使用FlyMCU烧录 build\robot_dog.hex 文件
echo    烧录地址: 0x08000000
echo.
pause
