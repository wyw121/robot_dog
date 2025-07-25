@echo off
setlocal enabledelayedexpansion
chcp 65001 > nul

echo ========================================
echo         USB设备详细检测工具
echo ========================================
echo.

echo 🔍 检测所有USB相关设备（包括无法识别的设备）...
echo.

echo ━━━━━━━ 串口设备 ━━━━━━━
wmic path Win32_SerialPort get DeviceID,Name,Description /format:table 2>nul
echo.

echo ━━━━━━━ USB设备（包括故障设备）━━━━━━━
wmic path Win32_PnPEntity where "DeviceID like '%%USB%%'" get Name,DeviceID,Status /format:table 2>nul
echo.

echo ━━━━━━━ 所有端口设备 ━━━━━━━
wmic path Win32_PnPEntity where "Name like '%%COM%%' or Name like '%%Port%%' or Name like '%%Serial%%'" get Name,DeviceID,Status /format:table 2>nul
echo.

echo ━━━━━━━ 检查注册表中的串口 ━━━━━━━
reg query "HKLM\HARDWARE\DEVICEMAP\SERIALCOMM" 2>nul
if errorlevel 1 (
    echo 注册表中未找到串口设备信息
) else (
    echo 注册表查询完成
)
echo.

echo ━━━━━━━ 设备管理器状态 ━━━━━━━
echo 检查是否有问题设备...
wmic path Win32_PnPEntity where "Status<>'OK'" get Name,DeviceID,Status /format:table 2>nul
echo.

echo ========================================
echo 🔧 故障排除建议：
echo.
echo 如果看到您的设备但状态显示为错误：
echo 1. 右键点击"此电脑" - "管理" - "设备管理器"
echo 2. 查找带黄色感叹号或红叉的设备
echo 3. 右键点击问题设备 - "更新驱动程序"
echo 4. 选择"自动搜索驱动程序"
echo.
echo 如果自动安装失败，可能需要：
echo - 下载CH340/CH341驱动程序
echo - 下载FTDI驱动程序
echo - 下载CP210x驱动程序
echo ========================================
echo.
pause
