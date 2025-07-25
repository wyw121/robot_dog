@echo off
setlocal enabledelayedexpansion
chcp 65001 > nul

echo ========================================
echo       机器狗驱动自动修复工具
echo ========================================
echo.

echo 🔍 检测到的问题设备：
echo   设备ID: USB\VID_0000^&PID_0002
echo   状态: 未知USB设备（驱动错误）
echo   这很可能就是您的机器狗设备！
echo.

echo 🔧 可用的修复方案：
echo.
echo 1. 📥 尝试自动安装通用USB转串口驱动
echo 2. 🌐 使用Windows Update自动搜索驱动
echo 3. 📋 手动选择驱动程序类型
echo 4. 🔍 重新检测设备状态
echo 5. 📖 查看详细故障排除指南
echo 6. ❌ 退出
echo.

:menu
set /p choice="请选择修复方案 (1-6): "

if "%choice%"=="1" goto auto_install
if "%choice%"=="2" goto windows_update
if "%choice%"=="3" goto manual_driver
if "%choice%"=="4" goto recheck
if "%choice%"=="5" goto troubleshoot
if "%choice%"=="6" goto exit

echo ❌ 无效选项，请重新选择
goto menu

:auto_install
echo.
echo 🔄 正在尝试自动安装USB转串口驱动...
echo.
echo 📝 执行以下步骤：
echo 1. 打开设备管理器
echo 2. 找到"未知USB设备"（带黄色感叹号）
echo 3. 右键 → 更新驱动程序
echo 4. 选择"让我从计算机上的可用驱动程序列表中选取"
echo 5. 选择"端口(COM和LPT)" → 下一步
echo 6. 选择 Microsoft → USB Serial Device
echo.
echo 🚀 正在为您打开设备管理器...
start devmgmt.msc
echo.
echo ✅ 完成手动安装后，选择选项4重新检测设备
pause
goto menu

:windows_update
echo.
echo 🌐 使用Windows Update搜索驱动...
echo.
echo 📝 执行以下步骤：
echo 1. 确保电脑连接到互联网
echo 2. 在设备管理器中找到"未知USB设备"
echo 3. 右键 → 更新驱动程序
echo 4. 选择"自动搜索驱动程序"
echo 5. 等待Windows下载并安装驱动
echo.
start devmgmt.msc
pause
goto menu

:manual_driver
echo.
echo 📋 手动驱动安装指导：
echo.
echo 根据您的机器狗类型，可能需要以下驱动：
echo.
echo 🔹 CH340/CH341 驱动（最常见）:
echo   下载: http://www.wch.cn/downloads/CH341SER_EXE.html
echo.
echo 🔹 FTDI 驱动:
echo   下载: https://ftdichip.com/drivers/vcp-drivers/
echo.
echo 🔹 CP210x 驱动:
echo   下载: https://www.silabs.com/developers/usb-to-uart-bridge-vcp-drivers
echo.
echo 💡 建议：如果不确定芯片类型，先尝试CH340驱动（最常用）
echo.
set /p open_browser="是否打开浏览器下载CH340驱动? (y/n): "
if /i "%open_browser%"=="y" (
    start http://www.wch.cn/downloads/CH341SER_EXE.html
)
pause
goto menu

:recheck
echo.
echo 🔍 重新检测设备状态...
echo.
call .\usb_device_analyzer.bat
echo.
echo 📊 检测完成！
echo.
echo ✅ 如果看到COM端口出现（如COM3），说明驱动安装成功！
echo ❌ 如果仍显示"Error"状态，请尝试其他修复方案
echo.
pause
goto menu

:troubleshoot
echo.
echo 📖 详细故障排除指南：
echo.
echo 🔧 硬件检查：
echo   ✓ 确保USB线支持数据传输（不是纯充电线）
echo   ✓ 尝试电脑后面的USB端口
echo   ✓ 确保机器狗设备已开机
echo.
echo 🔧 软件检查：
echo   ✓ 重启电脑后重新连接设备
echo   ✓ 暂时关闭杀毒软件
echo   ✓ 以管理员权限运行驱动安装程序
echo.
echo 🔧 驱动安装顺序建议：
echo   1️⃣ 先尝试Windows自动驱动
echo   2️⃣ 再尝试CH340驱动（最常见）
echo   3️⃣ 如果不行，尝试FTDI驱动
echo   4️⃣ 最后尝试CP210x驱动
echo.
echo 🔧 验证成功标志：
echo   ✅ 设备管理器中设备状态显示"OK"
echo   ✅ 出现COM端口（如COM3、COM4等）
echo   ✅ 检测工具能识别到串口设备
echo.
pause
goto menu

:exit
echo.
echo 👋 退出驱动修复工具
echo.
echo 💡 温馨提示：
echo   - 驱动安装后记得重新运行设备检测工具
echo   - 成功安装后设备会显示为COM端口
echo   - 有问题可以重新运行此工具
echo.
pause
exit /b 0
