@echo off
chcp 65001 >nul
echo.
echo ========================================
echo 🚀 机器人小狗最简LED测试版本
echo ========================================
echo.

set "GCC_PATH=C:\ST\STM32CubeIDE_1.19.0\STM32CubeIDE\plugins\com.st.stm32cube.ide.mcu.externaltools.gnu-tools-for-stm32.13.3.rel1.win32_1.0.0.202411081344\tools\bin"

echo 🏗️ 创建构建目录...
if not exist "build" mkdir build

echo.
echo 🧹 清理旧文件...
del /q build\robot_dog_test.* 2>nul

echo.
echo 🔧 编译LED测试版本...
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
    -Wl,-Map=build\robot_dog_test.map ^
    -T stm32f103c8.ld ^
    startup_stm32f103xb.s ^
    src\system_stm32f1xx.c ^
    src\main_simple.c ^
    -o build\robot_dog_test.elf

if %ERRORLEVEL% neq 0 (
    echo ❌ 编译失败！
    pause
    exit /b 1
)
echo ✅ 编译成功！

echo.
echo 📦 生成固件文件...
"%GCC_PATH%\arm-none-eabi-objcopy.exe" -O ihex build\robot_dog_test.elf build\robot_dog_test.hex
"%GCC_PATH%\arm-none-eabi-objcopy.exe" -O binary build\robot_dog_test.elf build\robot_dog_test.bin

echo.
echo 📊 程序信息...
"%GCC_PATH%\arm-none-eabi-size.exe" build\robot_dog_test.elf

echo.
echo 📁 检查输出文件...
if exist "build\robot_dog_test.hex" (
    for %%f in (build\robot_dog_test.hex) do (
        echo ✅ HEX文件: build\robot_dog_test.hex ^(%%~zf 字节^)
        if %%~zf GTR 0 (
            echo    ✅ 文件大小正常，可以烧录！
        ) else (
            echo    ❌ 文件大小为0，有问题！
        )
    )
) else (
    echo ❌ HEX文件生成失败！
)

if exist "build\robot_dog_test.bin" (
    for %%f in (build\robot_dog_test.bin) do (
        echo ✅ BIN文件: build\robot_dog_test.bin ^(%%~zf 字节^)
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
echo 🎯 烧录步骤:
echo    1. 在FlyMCU中选择: build\robot_dog_test.hex
echo    2. 烧录地址设置为: 0x08000000
echo    3. 点击"开始编程"
echo    4. 成功后LED应该每500ms闪烁一次
echo.
pause
