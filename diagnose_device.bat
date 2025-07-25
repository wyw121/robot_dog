@echo off
chcp 65001 >nul
echo.
echo ========================================
echo 🔍 机器人小狗设备状态诊断工具
echo ========================================
echo.

echo 📱 检查COM端口状态...
for /f "tokens=1,2" %%a in ('powershell -Command "Get-WmiObject Win32_SerialPort | Select-Object DeviceID,Description | ForEach-Object { \"$($_.DeviceID) $($_.Description)\" }"') do (
    echo ✅ 发现端口: %%a - %%b
)

echo.
echo 🔍 检查CH340设备详情...
powershell -Command "Get-WmiObject -Class Win32_PnPEntity | Where-Object {$_.Name -like '*CH340*' -or $_.Name -like '*USB*Serial*'} | Select-Object Name,Status,DeviceID | Format-Table -AutoSize"

echo.
echo 📋 STM32F103 BOOT模式说明:
echo ========================================
echo.
echo 🎯 正常运行模式 (当前可能状态):
echo    BOOT0 = 0 (未按住BOOT按钮)
echo    程序从Flash启动
echo    串口波特率: 程序定义 (通常9600或115200)
echo.
echo 🎯 系统启动模式 (烧录需要):
echo    BOOT0 = 1 (按住BOOT按钮)
echo    程序从系统存储器启动
echo    串口波特率: 9600 (固定)
echo    奇偶校验: Even (系统默认)
echo.
echo 💡 这就是您遇到配置问题的原因！
echo.

echo 🔧 解决方案:
echo ========================================
echo.
echo 方案A: 调整STM32CubeProgrammer配置
echo    1. 波特率改为 9600
echo    2. 奇偶校验改为 Even (保持您当前设置)
echo    3. 确保按住BOOT按钮后再连接
echo.
echo 方案B: 使用自动烧录脚本
echo    运行: .\flash_robot_dog_fix.bat
echo.
echo 方案C: 检查BOOT按钮操作
echo    1. 断开USB连接
echo    2. 按住BOOT按钮不放
echo    3. 重新连接USB (保持按住BOOT)
echo    4. 在STM32CubeProgrammer中连接
echo    5. 连接成功后可以松开BOOT按钮
echo.

echo 🎯 推荐操作顺序:
echo ========================================
echo 1. 先按方案A调整配置再试
echo 2. 如果还不行，使用方案C的操作方法
echo 3. 最后可以尝试运行自动脚本
echo.
pause
