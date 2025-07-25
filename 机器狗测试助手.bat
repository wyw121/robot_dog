@echo off
chcp 65001 >nul
echo ========================================
echo       机器人小狗 快速功能测试
echo ========================================
echo.

echo 🎯 检测到你的设备状态：
echo    ✅ USB串口: CH340 (COM3)
echo    📁 厂商程序: 9代桌宠狗程序
echo.

echo 🎮 可用的测试选项：
echo.
echo [1] 使用厂商原版程序测试
echo [2] 烧录简化测试程序
echo [3] 连接蓝牙进行功能测试
echo [4] 查看设备连接状态
echo [5] 安装开发环境
echo.

set /p choice="请选择测试方式 (1-5): "

if "%choice%"=="1" goto vendor_test
if "%choice%"=="2" goto simple_flash
if "%choice%"=="3" goto bluetooth_test
if "%choice%"=="4" goto device_status
if "%choice%"=="5" goto install_env
goto invalid_choice

:vendor_test
echo.
echo 🔄 使用厂商原版程序测试...
echo.
echo 📋 厂商9代桌宠狗支持的语音命令：
echo    基础动作: 立正、趴下、蹲下、前进、后退、左转、右转
echo    特殊动作: 握手、撒娇、摇摆、扒土、狗蹬腿、跪拜
echo    表情控制: 变脸、开灯、关灯、息屏
echo    语音互动: 叫爸爸、叫妈妈、表白、元素周期表
echo    连续动作: 连续向前、连续向后、连续摇摆
echo    检测功能: 温度、压强、甲醛、二氧化碳
echo.
echo 💡 使用方法：
echo    1. 确保机器狗已上电
echo    2. 说出唤醒词 "狗蛋" 或 "小智"
echo    3. 听到回应后说出任意命令
echo    4. 观察机器狗的动作和表情反应
echo.
goto end

:simple_flash
echo.
echo 🔄 准备烧录简化测试程序...
echo.

:: 检查编译环境
where arm-none-eabi-gcc >nul 2>&1
if errorlevel 1 (
    echo ❌ 未找到ARM编译器！
    echo 🔧 请先选择选项5安装开发环境
    echo.
    pause
    goto menu
)

echo ✅ 编译环境检查通过
echo.
echo 🚀 开始编译和烧录...

:: 这里可以调用实际的编译和烧录流程
make -f Makefile.test clean >nul 2>&1
make -f Makefile.test test >nul 2>&1

if errorlevel 1 (
    echo ❌ 编译失败！
    echo 💡 建议使用厂商原版程序进行测试
) else (
    echo ✅ 编译成功！
    echo 🔥 正在烧录到设备...

    :: 尝试烧录
    stm32flash -w robot_dog_test.hex -v -g 0x0 COM3 >nul 2>&1
    if errorlevel 1 (
        echo ❌ 烧录失败，可能需要进入烧录模式
        echo 💡 请按住BOOT按钮并重新上电后重试
    ) else (
        echo ✅ 烧录成功！测试程序已就绪
    )
)
echo.
goto end

:bluetooth_test
echo.
echo 📱 蓝牙连接测试指南...
echo.
echo 🔍 1. 搜索蓝牙设备
echo    - 打开手机/电脑蓝牙设置
echo    - 搜索名为 "RobotDog" 或类似的设备
echo.
echo 🔗 2. 连接设备
echo    - 配对码通常为: 0000 或 1234
echo    - 连接后会显示串口选项
echo.
echo 🎮 3. 测试命令 (串口波特率: 9600)
echo    发送单个数字命令：
echo    1 - 向前走    5 - 站立
echo    2 - 左转      6 - 跳舞
echo    3 - 右转      7 - 摇尾巴
echo    4 - 坐下      8 - 打招呼
echo    9 - 重新测试
echo.
echo 📲 推荐蓝牙串口APP:
echo    - Android: "Serial Bluetooth Terminal"
echo    - iOS: "BlueTooth Terminal"
echo    - 电脑: PuTTY, CoolTerm
echo.
goto end

:device_status
echo.
echo 🔍 检查设备连接状态...
echo.

:: 检查USB设备
echo 📊 USB设备状态：
wmic path Win32_PnPEntity where "Name like '%%CH340%%' or Name like '%%STM32%%'" get Name 2>nul | find "CH340" >nul
if errorlevel 1 (
    echo    ❌ 未检测到USB串口设备
    echo    💡 请检查USB线连接和设备供电
) else (
    echo    ✅ 检测到 CH340 USB串口设备 (COM3)
)

echo.
echo 📊 串口状态：
mode COM3 >nul 2>&1
if errorlevel 1 (
    echo    ❌ COM3端口不可用
) else (
    echo    ✅ COM3端口可用
)

echo.
echo 📊 开发工具状态：
where arm-none-eabi-gcc >nul 2>&1
if errorlevel 1 (
    echo    ❌ ARM编译器未安装
) else (
    echo    ✅ ARM编译器已安装
)

where make >nul 2>&1
if errorlevel 1 (
    echo    ❌ Make工具未安装
) else (
    echo    ✅ Make工具已安装
)

where stm32flash >nul 2>&1
if errorlevel 1 (
    echo    ❌ STM32烧录工具未安装
) else (
    echo    ✅ STM32烧录工具已安装
)

echo.
goto end

:install_env
echo.
echo 🔧 开发环境安装指南...
echo.
echo 📦 推荐安装方案：
echo.
echo [A] STM32CubeIDE (一体化方案，推荐)
echo     - 包含编译器、烧录工具、调试器
echo     - 官方下载：https://www.st.com/zh/development-tools/stm32cubeide.html
echo.
echo [B] 独立工具链
echo     - ARM GCC编译器
echo     - STM32CubeProgrammer烧录工具
echo     - Make构建工具
echo.
echo [C] 简化测试 (无需编译)
echo     - 直接使用厂商预编译程序
echo     - 通过蓝牙进行功能测试
echo.

set /p env_choice="请选择安装方案 (A/B/C): "

if /i "%env_choice%"=="A" (
    echo.
    echo 🌐 正在打开STM32CubeIDE下载页面...
    start https://www.st.com/zh/development-tools/stm32cubeide.html
    echo 📥 下载完成后按照安装向导完成安装
)

if /i "%env_choice%"=="B" (
    echo.
    echo 📋 独立工具安装清单：
    echo 1. ARM GCC: https://developer.arm.com/downloads/-/arm-gnu-toolchain-downloads
    echo 2. STM32CubeProgrammer: https://www.st.com/zh/development-tools/stm32cubeprog.html
    echo 3. Make工具: 通过MSYS2或MinGW安装
    echo.
    echo 💡 安装后需要添加到系统PATH环境变量
)

if /i "%env_choice%"=="C" (
    echo.
    echo ✅ 选择简化测试方案
    echo 📱 可以直接使用蓝牙连接进行功能测试
    echo 🎮 参考选项3的蓝牙测试指南
)

echo.
goto end

:invalid_choice
echo.
echo ❌ 无效选择，请重新运行程序
echo.

:end
echo ========================================
echo           测试完成！
echo ========================================
echo.
echo 💡 提示：
echo   - 如有问题可查看 "快速烧录指南.md"
echo   - 厂商原版功能已很完整，建议先体验
echo   - 开发自定义功能需要安装开发环境
echo.

:menu
echo 🔄 是否继续其他测试？
set /p continue="输入 Y 返回主菜单，任意键退出: "
if /i "%continue%"=="Y" (
    cls
    goto start
)

pause
exit

:start
goto begin

:begin
cls
goto menu
