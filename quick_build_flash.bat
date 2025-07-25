@echo off
chcp 65001 >nul
echo ========================================
echo      🚀 VSCode STM32 快速编译烧录
echo ========================================
echo.

echo [1/4] 检查设备连接...
wmic path Win32_PnPEntity where "Name like '%%CH340%%'" get Name 2>nul | find "CH340" >nul
if errorlevel 1 (
    echo ❌ 未检测到CH340设备，请检查USB连接！
    goto :end
) else (
    echo ✅ 检测到CH340设备 (COM3)
)

echo.
echo [2/4] 检查编译环境...
where arm-none-eabi-gcc >nul 2>&1
if errorlevel 1 (
    echo ❌ 未找到ARM GCC编译器！
    echo 💡 请安装ARM GNU Toolchain或STM32CubeIDE
    echo 🌐 下载地址: https://developer.arm.com/downloads/-/arm-gnu-toolchain-downloads
    goto :end
) else (
    echo ✅ ARM GCC 编译器已安装
)

where make >nul 2>&1
if errorlevel 1 (
    echo ❌ 未找到Make工具！
    echo 💡 请安装MSYS2或完整的开发环境
    goto :end
) else (
    echo ✅ Make工具已安装
)

echo.
echo [3/4] 编译测试程序...
make -f Makefile.test clean >nul 2>&1
make -f Makefile.test test

if errorlevel 1 (
    echo ❌ 编译失败！请检查源代码
    goto :end
) else (
    echo ✅ 测试程序编译成功
)

echo.
echo [4/4] 烧录程序...
echo 💡 如果烧录失败，请按住BOOT按钮并重新上电设备

:: 尝试使用STM32CubeProgrammer
where STM32_Programmer_CLI.exe >nul 2>&1
if not errorlevel 1 (
    echo 🔥 使用STM32CubeProgrammer烧录...
    STM32_Programmer_CLI.exe -c port=COM3 br=115200 -w robot_dog_test.hex -v -rst
    if not errorlevel 1 (
        echo ✅ 使用STM32CubeProgrammer烧录成功！
        goto :success
    )
)

:: 尝试使用stm32flash
where stm32flash >nul 2>&1
if not errorlevel 1 (
    echo 🔥 使用stm32flash烧录...
    stm32flash -w robot_dog_test.hex -v -g 0x0 COM3
    if not errorlevel 1 (
        echo ✅ 使用stm32flash烧录成功！
        goto :success
    )
)

echo ❌ 所有烧录方式都失败了！
echo 💡 可能的解决方案：
echo    1. 确保设备已正确连接和上电
echo    2. 按住BOOT按钮并重新上电进入烧录模式
echo    3. 安装STM32CubeProgrammer烧录工具
echo    4. 检查USB驱动是否正确安装
goto :end

:success
echo.
echo ========================================
echo           ✅ 烧录完成！
echo ========================================
echo.
echo 🎮 测试程序功能：
echo    📺 OLED显示测试
echo    🤖 舵机动作测试
echo    📡 蓝牙通信测试
echo    🎮 交互控制测试
echo.
echo 🎯 蓝牙控制命令：
echo    1 - 向前走    5 - 站立
echo    2 - 左转      6 - 跳舞
echo    3 - 右转      7 - 摇尾巴
echo    4 - 坐下      8 - 打招呼
echo    9 - 重新测试
echo.
echo 📱 蓝牙连接设置：
echo    • 设备名称: RobotDog_Test
echo    • 波特率: 9600，数据位: 8，停止位: 1
echo    • 使用串口工具或手机APP连接测试
echo.

:end
echo.
echo 📖 更多信息请查看: VSCode开发指南.md
echo.
pause
