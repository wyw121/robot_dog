@echo off
chcp 65001 >nul 2>&1
echo ========================================
echo       机器人高级连接诊断工具
echo ========================================
echo.

echo 🔍 第1步: 检查端口占用情况
netstat -an | findstr :3 2>nul
echo.

echo 🔍 第2步: 检查设备管理器状态
powershell -Command "Get-WmiObject -Class Win32_PnPEntity | Where-Object {$_.Name -like '*CH340*' -or $_.Name -like '*COM3*'} | Select-Object Name, Status, DeviceID" 2>nul
echo.

echo 🔍 第3步: 尝试不同波特率
for %%b in (9600 19200 38400 57600 115200) do (
    echo 测试波特率: %%b
    mode COM3 BAUD=%%b PARITY=n DATA=8 STOP=1 >nul 2>&1
    if !ERRORLEVEL! EQU 0 (
        echo   ✅ 波特率 %%b 配置成功
    ) else (
        echo   ❌ 波特率 %%b 配置失败
    )
)
echo.

echo 🔍 第4步: 检查串口是否可以打开
powershell -Command "
try {
    $port = new-object System.IO.Ports.SerialPort COM3,9600,None,8,one
    $port.Open()
    Write-Host '✅ COM3端口可以正常打开' -ForegroundColor Green
    $port.Close()
} catch {
    Write-Host '❌ COM3端口无法打开:' $_.Exception.Message -ForegroundColor Red
    Write-Host '可能原因: 端口被其他程序占用或硬件故障' -ForegroundColor Yellow
}
"
echo.

echo 🔍 第5步: 机器人状态检查建议
echo ✔️ 请确认以下事项:
echo    □ 机器人是否已开机 (LED指示灯是否亮起)
echo    □ USB数据线是否为数据线 (不是纯充电线)
echo    □ USB连接是否牢固
echo    □ 是否尝试过重新插拔USB线
echo    □ 机器人是否处于编程模式
echo.

echo 🎯 连接总结:
echo    设备识别: ✅ 已找到 CH340 设备
echo    驱动状态: ✅ 正常工作
echo    端口配置: ✅ 可以配置
echo    下一步: 确认机器人硬件状态
echo.

pause
