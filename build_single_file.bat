@echo off
chcp 65001 >nul
echo.
echo ========================================
echo 🚀 最简LED测试 - 单文件版本
echo ========================================
echo.

set "GCC_PATH=C:\ST\STM32CubeIDE_1.19.0\STM32CubeIDE\plugins\com.st.stm32cube.ide.mcu.externaltools.gnu-tools-for-stm32.13.3.rel1.win32_1.0.0.202411081344\tools\bin"

echo 🏗️ 创建构建目录...
if not exist "build" mkdir build

echo.
echo 🧹 清理旧文件...
del /q build\test_led.* 2>nul

echo.
echo 🔧 编译LED测试...
"%GCC_PATH%\arm-none-eabi-gcc.exe" ^
    -mcpu=cortex-m3 ^
    -mthumb ^
    -Wall ^
    -O1 ^
    -ffunction-sections ^
    -fdata-sections ^
    -Wl,--gc-sections ^
    -Wl,-Map=build\test_led.map ^
    -T stm32f103c8.ld ^
    --specs=nano.specs ^
    -nostartfiles ^
    startup_stm32f103xb.s ^
    test_led.c ^
    -o build\test_led.elf

if %ERRORLEVEL% neq 0 (
    echo ❌ 编译失败！
    pause
    exit /b 1
)
echo ✅ 编译成功！

echo.
echo 📦 生成固件文件...
"%GCC_PATH%\arm-none-eabi-objcopy.exe" -O ihex build\test_led.elf build\test_led.hex
"%GCC_PATH%\arm-none-eabi-objcopy.exe" -O binary build\test_led.elf build\test_led.bin

echo.
echo 📊 程序信息...
"%GCC_PATH%\arm-none-eabi-size.exe" build\test_led.elf

echo.
echo 📁 输出文件检查...
for %%f in (build\test_led.hex) do (
    if %%~zf GTR 0 (
        echo ✅ HEX文件: %%f ^(%%~zf 字节^) - 可以烧录！
    ) else (
        echo ❌ HEX文件大小为0
    )
)

for %%f in (build\test_led.bin) do (
    if %%~zf GTR 0 (
        echo ✅ BIN文件: %%f ^(%%~zf 字节^) - 文件正常！
    ) else (
        echo ❌ BIN文件大小为0
    )
)

echo.
echo ========================================
echo 🎯 烧录说明
echo ========================================
echo.
echo 1. 保持开发板连接状态
echo 2. 在FlyMCU中选择: build\test_led.hex
echo 3. 烧录地址: 0x08000000
echo 4. 点击"开始编程"
echo 5. 成功后LED应该每500ms闪烁
echo.
echo 💡 如果LED不在PC13，请检查开发板原理图
echo    或使用万用表测试PC13引脚电平变化
echo.
pause
