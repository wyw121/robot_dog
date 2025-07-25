@echo off
chcp 65001 >nul
echo ========================================
echo        STM32 机器人小狗 测试程序烧录
echo ========================================
echo.

:: 检查设备连接
echo [1/4] 检查设备连接状态...
wmic path Win32_PnPEntity where "Name like '%%CH340%%'" get Name 2>nul | find "CH340" >nul
if errorlevel 1 (
    echo ❌ 未检测到CH340设备，请检查USB连接！
    pause
    exit /b 1
) else (
    echo ✅ 检测到CH340设备 (COM3)
)

:: 切换到项目目录
cd /d "%~dp0"

:: 检查编译工具
echo.
echo [2/4] 检查编译环境...
where arm-none-eabi-gcc >nul 2>&1
if errorlevel 1 (
    echo ❌ 未找到ARM GCC编译器！
    echo 请安装 STM32CubeIDE 或 ARM GNU Toolchain
    pause
    exit /b 1
) else (
    echo ✅ ARM GCC 编译器已安装
)

:: 编译测试程序
echo.
echo [3/4] 编译测试程序...
make -f Makefile.test clean
make -f Makefile.test test

if errorlevel 1 (
    echo ❌ 编译失败！请检查源代码
    pause
    exit /b 1
) else (
    echo ✅ 测试程序编译成功
)

:: 烧录程序
echo.
echo [4/4] 烧录测试程序...
echo 请确保机器狗已连接USB并上电...
echo.

:: 尝试不同的烧录方式
echo 正在尝试烧录方式 1: STM32CubeProgrammer...
STM32_Programmer_CLI.exe -c port=COM3 br=115200 -w robot_dog_test.hex -v -rst 2>nul
if not errorlevel 1 (
    echo ✅ 使用STM32CubeProgrammer烧录成功！
    goto :success
)

echo 正在尝试烧录方式 2: stm32flash...
stm32flash -w robot_dog_test.hex -v -g 0x0 COM3 2>nul
if not errorlevel 1 (
    echo ✅ 使用stm32flash烧录成功！
    goto :success
)

echo 正在尝试烧录方式 3: 使用Python脚本...
python tools\flash_helper.py robot_dog_test.hex COM3 2>nul
if not errorlevel 1 (
    echo ✅ 使用Python脚本烧录成功！
    goto :success
)

echo ❌ 所有烧录方式都失败了！
echo 可能的解决方案：
echo 1. 确保设备已正确连接
echo 2. 检查BOOT引脚设置（可能需要按住BOOT按钮）
echo 3. 尝试手动重启设备
echo 4. 安装 STM32CubeProgrammer 或 stm32flash 工具
goto :end

:success
echo.
echo ========================================
echo            ✅ 烧录完成！
echo ========================================
echo.
echo 测试程序功能：
echo 📺 OLED显示测试
echo 🤖 舵机动作测试
echo 📡 蓝牙通信测试
echo 🎮 交互控制测试
echo.
echo 蓝牙连接设置：
echo - 波特率：9600
echo - 数据位：8，停止位：1
echo - 发送命令 '1'-'9' 测试不同功能
echo.
echo 观察机器狗的OLED屏幕显示和动作反应。

:end
echo.
pause
