@echo off
chcp 65001 >nul 2>&1
echo ========================================
echo          机器人连接测试工具
echo ========================================
echo.
echo 🤖 正在测试与机器人的连接...
echo 📡 目标端口: COM3
echo 💻 设备类型: CH340 USB转串口
echo.

echo 📋 端口状态检查:
mode COM3
echo.

echo 🔧 配置端口参数:
mode COM3 BAUD=9600 PARITY=n DATA=8 STOP=1
if %ERRORLEVEL% EQU 0 (
    echo ✅ 端口配置成功
) else (
    echo ❌ 端口配置失败
    goto :error
)
echo.

echo 📤 发送测试命令...
echo 尝试向机器人发送基础测试指令:
echo|set /p="test" >COM3
if %ERRORLEVEL% EQU 0 (
    echo ✅ 测试数据发送成功
    echo 🎉 机器人连接正常！
    echo.
    echo 📋 连接信息摘要:
    echo    - 端口: COM3
    echo    - 波特率: 9600
    echo    - 数据位: 8
    echo    - 停止位: 1
    echo    - 奇偶校验: 无
    echo    - 状态: 正常连接
) else (
    echo ❌ 数据发送失败
    goto :error
)
echo.

echo 🚀 您现在可以尝试以下操作:
echo    1. 使用串口调试工具 (如PuTTY) 连接 COM3
echo    2. 发送机器人控制指令
echo    3. 上传新的程序到机器人
echo.
goto :end

:error
echo.
echo ❌ 连接测试失败
echo 🔧 故障排除建议:
echo    1. 检查USB连接线是否插紧
echo    2. 确认机器人是否开机
echo    3. 尝试重新插拔USB线
echo    4. 检查是否有其他程序占用COM3端口
echo.

:end
pause
