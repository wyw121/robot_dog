@echo off
setlocal enabledelayedexpansion
chcp 65001 > nul

:main
cls
echo.
echo ========================================
echo           机器狗设备检测器
echo ========================================
echo 使用说明：
echo 1. 先运行一次程序，记录当前设备列表
echo 2. 插入您的机器狗设备
echo 3. 再次运行程序，对比新增的设备
echo 4. 新增的设备就是您的机器狗!
echo ========================================
echo.

echo 当前检测到的串口设备：
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo.

REM 使用wmic命令查询串口设备
set /a count=0
for /f "tokens=1,2 delims=," %%a in ('wmic path Win32_SerialPort get DeviceID^,Name /format:csv ^| findstr /v "Node"') do (
    if not "%%b"=="" (
        set /a count+=1
        echo 📱 设备 !count!: %%b ^-^> %%a

        REM 简单的设备类型识别
        echo %%a | findstr /i "USB" >nul && echo    💡 这是一个USB串口设备
        echo %%a | findstr /i "CH340\|CH341" >nul && echo    💡 检测到CH340/CH341芯片 ^(常用于Arduino兼容设备^)
        echo %%a | findstr /i "FTDI" >nul && echo    💡 检测到FTDI芯片 ^(高质量USB转串口^)
        echo %%a | findstr /i "CP210" >nul && echo    💡 检测到CP210x芯片 ^(Silicon Labs USB转串口^)
        echo.
    )
)

REM 如果wmic没有找到设备，尝试使用注册表方法
if %count%==0 (
    echo 尝试使用注册表方法检测...
    echo.

    for /f "tokens=1,2*" %%a in ('reg query "HKLM\HARDWARE\DEVICEMAP\SERIALCOMM" 2^>nul') do (
        if not "%%c"=="" (
            set /a count+=1
            echo 📱 设备 !count!: %%a ^-^> %%c
            echo    💡 检测到串口设备
            echo.
        )
    )
)

echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

if %count%==0 (
    echo ❌ 未检测到任何串口设备
    echo.
    echo 💡 请检查：
    echo    - 设备是否正确连接到电脑
    echo    - 设备驱动程序是否已安装
    echo    - USB线缆是否正常工作
) else (
    echo ✅ 总共检测到 %count% 个串口设备
)

echo.
echo 选择操作：
echo 1. 🔍 重新扫描设备
echo 2. 📋 测试特定COM口
echo 3. 📖 查看使用说明
echo 4. ❌ 退出程序
echo.
set /p choice="请输入选项 (1-4): "

if "%choice%"=="1" (
    echo.
    echo 🔄 正在重新扫描设备...
    timeout /t 1 >nul
    goto main
)

if "%choice%"=="2" (
    echo.
    set /p portname="请输入要测试的COM口名称 (例如: COM3): "
    if not "!portname!"=="" (
        echo 测试 !portname! 的连接性...
        REM 尝试使用mode命令测试端口
        mode !portname! baud=9600 parity=n data=8 stop=1 >nul 2>&1
        if !errorlevel! equ 0 (
            echo ✅ !portname! 可以正常访问
        ) else (
            echo ❌ !portname! 无法访问 ^(可能被其他程序占用^)
        )
        echo.
        pause
    )
    goto main
)

if "%choice%"=="3" (
    cls
    echo ========================================
    echo           详细使用说明
    echo ========================================
    echo.
    echo 🎯 目标：找到您的机器狗设备名称
    echo.
    echo 📝 操作步骤：
    echo 1️⃣  首先拔掉机器狗设备
    echo 2️⃣  运行此程序，记录当前的设备列表
    echo 3️⃣  插入机器狗设备并等待系统识别
    echo 4️⃣  再次扫描设备，新出现的就是您的机器狗
    echo.
    echo 🔍 设备识别提示：
    echo • 机器狗通常显示为 COM1, COM3, COM4 等
    echo • 设备名可能包含 USB, CH340, FTDI 等关键词
    echo • 如果有多个设备，可以逐个测试
    echo.
    echo ⚠️  注意事项：
    echo • 确保机器狗设备已正确安装驱动
    echo • 如果设备无法访问，可能被其他程序占用
    echo • 某些设备可能需要特定的波特率设置
    echo.
    pause
    goto main
)

if "%choice%"=="4" (
    echo.
    echo 👋 感谢使用机器狗设备检测器！
    goto end
)

echo ❌ 无效选项，请重新选择
timeout /t 2 >nul
goto main

:end
pause
