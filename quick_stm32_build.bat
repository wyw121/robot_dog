@echo off
chcp 65001 >nul
echo.
echo ========================================
echo 🤖 STM32机器人小狗开发环境
echo ========================================
echo.

set "GCC_PATH=C:\ST\STM32CubeIDE_1.19.0\STM32CubeIDE\plugins\com.st.stm32cube.ide.mcu.externaltools.gnu-tools-for-stm32.13.3.rel1.win32_1.0.0.202411081344\tools\bin"
set "WORKSPACE=%~dp0"

echo 🔍 检测开发环境...
if not exist "%GCC_PATH%\arm-none-eabi-gcc.exe" (
    echo ❌ STM32CubeIDE编译器未找到！
    echo 请确认STM32CubeIDE已正确安装在 C:\ST\STM32CubeIDE_1.19.0\
    pause
    exit /b 1
)
echo ✅ 找到STM32CubeIDE编译器

echo.
echo 🔍 检测设备连接...
for /f "tokens=*" %%i in ('powershell -Command "(Get-WmiObject -Class Win32_PnPEntity | Where-Object {$_.Name -like '*CH340*' -or $_.Name -like '*USB*Serial*'}).Name"') do (
    echo ✅ 找到设备: %%i
    set "DEVICE_FOUND=1"
)

if not defined DEVICE_FOUND (
    echo ❌ 未找到机器人小狗设备！
    echo 请确保设备已连接并安装CH340驱动
    pause
    exit /b 1
)

echo.
echo 🏗️ 创建构建目录...
if not exist "build" mkdir build

echo.
echo 🔧 编译源代码...
echo 正在编译 main.c...
"%GCC_PATH%\arm-none-eabi-gcc.exe" ^
    -mcpu=cortex-m3 ^
    -mthumb ^
    -Wall ^
    -Wextra ^
    -g ^
    -Os ^
    -DSTM32F103xB ^
    -Isrc ^
    -Ilib\STM32F10x_StdPeriph_Driver\inc ^
    -Ilib\CMSIS\Device\ST\STM32F10x\Include ^
    -Ilib\CMSIS\Include ^
    -c src\main.c ^
    -o build\main.o

if %ERRORLEVEL% neq 0 (
    echo ❌ 编译失败！
    pause
    exit /b 1
)

echo 正在编译 custom_features.c...
if exist "src\custom_features.c" (
    "%GCC_PATH%\arm-none-eabi-gcc.exe" ^
        -mcpu=cortex-m3 ^
        -mthumb ^
        -Wall ^
        -Wextra ^
        -g ^
        -Os ^
        -DSTM32F103xB ^
        -Isrc ^
        -Ilib\STM32F10x_StdPeriph_Driver\inc ^
        -Ilib\CMSIS\Device\ST\STM32F10x\Include ^
        -Ilib\CMSIS\Include ^
        -c src\custom_features.c ^
        -o build\custom_features.o

    if %ERRORLEVEL% neq 0 (
        echo ❌ custom_features.c 编译失败！
        pause
        exit /b 1
    )
)

echo ✅ 编译完成！

echo.
echo 🔗 链接程序...
if exist "src\custom_features.c" (
    set "OBJ_FILES=build\main.o build\custom_features.o"
) else (
    set "OBJ_FILES=build\main.o"
)

if exist "linker_script.ld" (
    "%GCC_PATH%\arm-none-eabi-gcc.exe" ^
        -mcpu=cortex-m3 ^
        -mthumb ^
        -Wl,--gc-sections ^
        -T linker_script.ld ^
        %OBJ_FILES% ^
        -o build\robot_dog_firmware.elf
) else (
    echo ⚠️  未找到链接脚本，生成简单的可执行文件...
    "%GCC_PATH%\arm-none-eabi-gcc.exe" ^
        -mcpu=cortex-m3 ^
        -mthumb ^
        %OBJ_FILES% ^
        -o build\robot_dog_firmware.elf
)

if %ERRORLEVEL% neq 0 (
    echo ❌ 链接失败！
    pause
    exit /b 1
)

echo ✅ 链接完成！

echo.
echo 📦 生成固件文件...
"%GCC_PATH%\arm-none-eabi-objcopy.exe" -O ihex build\robot_dog_firmware.elf build\robot_dog_firmware.hex
if %ERRORLEVEL% neq 0 (
    echo ❌ 生成HEX文件失败！
    pause
    exit /b 1
)

echo ✅ 固件文件生成完成: build\robot_dog_firmware.hex

echo.
echo 📡 准备烧录程序...
echo 正在查找COM端口...
for /f "tokens=1,2 delims==" %%i in ('wmic path win32_pnpentity where "Name like '%%CH340%%'" get Name /format:list ^| findstr "="') do (
    for /f "tokens=2 delims=()" %%k in ("%%j") do (
        set "COM_PORT=%%k"
        echo ✅ 找到COM端口: %%k
    )
)

if not defined COM_PORT (
    echo ❌ 未找到COM端口！请检查设备连接
    pause
    exit /b 1
)

echo.
echo 🚀 开始烧录...
echo 提示：如果烧录失败，请按住机器人小狗的复位按钮，然后重新运行此脚本

REM 尝试使用stm32flash（如果可用）
where stm32flash >nul 2>&1
if %ERRORLEVEL% equ 0 (
    echo 使用 stm32flash 烧录...
    stm32flash -w build\robot_dog_firmware.hex -v -g 0x08000000 %COM_PORT%
) else (
    echo stm32flash 未找到，请使用 STM32CubeProgrammer 手动烧录
    echo 文件位置: %WORKSPACE%build\robot_dog_firmware.hex
    echo COM端口: %COM_PORT%
    echo.
    echo 或者安装 stm32flash：
    echo 下载地址: https://sourceforge.net/projects/stm32flash/
    pause
)

echo.
echo ========================================
echo ✅ 构建流程完成！
echo ========================================
echo.
echo 📁 输出文件:
echo    - ELF: build\robot_dog_firmware.elf
echo    - HEX: build\robot_dog_firmware.hex
echo 📱 COM端口: %COM_PORT%
echo.
echo 💡 提示：按 Ctrl+Shift+B 可在VSCode中快速运行此构建
echo.
pause
