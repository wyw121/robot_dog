@echo off
chcp 65001 > nul
echo.
echo 🔍 检查COM端口状态...
echo ================================
echo.

wmic path Win32_SerialPort get DeviceID,Name /format:table 2>nul | findstr /v /c:"No Instance"

if %errorlevel% neq 0 (
    echo ❌ 当前没有检测到COM端口
    echo.
    echo 💡 这意味着驱动还没有正确安装
    echo 请按照以下步骤手动安装：
    echo.
    echo 1. 打开设备管理器 (Win + X, 选择设备管理器)
    echo 2. 找到"未知USB设备"
    echo 3. 右键 → 更新驱动程序
    echo 4. 选择手动安装
    echo 5. 选择"端口(COM和LPT)"
    echo 6. 选择"Microsoft Corporation" - "USB Serial Device"
) else (
    echo ✅ 检测到COM端口设备！
    echo 🎉 驱动安装成功！
)

echo.
pause
