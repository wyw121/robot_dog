@echo off
chcp 65001 >nul
echo.
echo ========================================
echo 🔥 STM32机器人小狗专用烧录工具
echo ========================================
echo.

set "COM_PORT=COM3"
set "BAUDRATE=9600"
set "HEX_FILE=build\robot_dog_advanced.hex"

echo 🔍 检查烧录环境...

REM 检查hex文件是否存在
if not exist "%HEX_FILE%" (
    echo ❌ 固件文件不存在: %HEX_FILE%
    echo 请先运行构建脚本生成固件文件
    echo.
    echo 💡 运行以下命令之一:
    echo    .\build_advanced.bat
    echo    .\build_simple.bat
    pause
    exit /b 1
)
echo ✅ 找到固件文件: %HEX_FILE%

REM 检查设备连接
echo.
echo 🔍 检查设备连接...
for /f "tokens=*" %%i in ('powershell -Command "Get-WmiObject -Class Win32_PnPEntity | Where-Object {$_.Name -like '*CH340*'} | Select-Object -ExpandProperty Name"') do (
    echo ✅ 找到设备: %%i
    set "DEVICE_FOUND=1"
)

if not defined DEVICE_FOUND (
    echo ❌ 未找到CH340设备！
    echo.
    echo 🔧 请检查:
    echo    1. USB线是否连接
    echo    2. 机器人小狗是否开机
    echo    3. CH340驱动是否安装
    pause
    exit /b 1
)

echo.
echo 📱 烧录参数:
echo    固件文件: %HEX_FILE%
echo    COM端口: %COM_PORT%
echo    波特率: %BAUDRATE%
echo.

REM 方法1: 尝试使用stm32flash
echo 🚀 尝试使用stm32flash烧录...
where stm32flash >nul 2>&1
if %ERRORLEVEL% equ 0 (
    echo 使用stm32flash工具烧录...
    echo.
    echo ⚠️  请按住机器人小狗的BOOT按钮，然后按任意键继续...
    pause >nul

    stm32flash -w "%HEX_FILE%" -v -g 0x08000000 -b %BAUDRATE% %COM_PORT%

    if %ERRORLEVEL% equ 0 (
        echo.
        echo ✅ 烧录成功！
        echo 🎉 请松开BOOT按钮，机器人小狗将开始运行新程序
        goto :success
    ) else (
        echo.
        echo ❌ stm32flash烧录失败，尝试其他方法...
    )
) else (
    echo stm32flash未找到，跳过此方法
)

echo.
echo 📋 STM32CubeProgrammer手动烧录指南:
echo ========================================
echo.
echo 1️⃣  打开STM32CubeProgrammer
echo    路径: C:\ST\STM32CubeIDE_1.19.0\STM32CubeIDE\stm32cubeide.exe
echo.
echo 2️⃣  配置连接参数:
echo    💡 连接方式: UART
echo    💡 端口: %COM_PORT%
echo    💡 波特率: 9600 (重要！不是115200)
echo    💡 奇偶校验: None (重要！不是Even)
echo    💡 数据位: 8
echo    💡 停止位: 1
echo    💡 流控制: None
echo.
echo 3️⃣  进入下载模式:
echo    💡 按住机器人小狗的BOOT按钮
echo    💡 按一下RESET按钮 (或重新上电)
echo    💡 松开RESET按钮 (保持BOOT按钮按住)
echo.
echo 4️⃣  连接设备:
echo    💡 点击"Connect"按钮
echo    💡 如果连接成功，会显示芯片信息
echo.
echo 5️⃣  烧录固件:
echo    💡 选择文件: %HEX_FILE%
echo    💡 点击"Download"按钮
echo    💡 等待烧录完成
echo.
echo 6️⃣  运行程序:
echo    💡 松开BOOT按钮
echo    💡 按一下RESET按钮 (或重新上电)
echo    💡 观察LED演示效果
echo.

:success
echo ========================================
echo 🎊 烧录流程完成！
echo ========================================
echo.
echo 🎮 程序功能说明:
echo    💡 启动: 流水灯动画
echo    🌈 模式1: 彩虹呼吸灯
echo    😊 模式2: 心情表达
echo    🎵 模式3: 节拍模式
echo    🚶 模式4: 步态模拟
echo    🎪 模式5: 全功能演示
echo.
echo 💡 LED闪烁次数 = 当前功能模式编号
echo ⏱️  每个功能会自动切换到下一个
echo.
pause
