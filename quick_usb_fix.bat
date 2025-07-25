@echo off
setlocal enabledelayedexpansion
chcp 65001 > nul

REM 检查管理员权限
net session >nul 2>&1
if %errorLevel% == 0 (
    echo ✅ 管理员权限确认
) else (
    echo 🔑 需要管理员权限来修复驱动问题
    echo 🔄 正在请求管理员权限...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

cls
echo.
echo =============================================
echo        🔧 机器狗USB驱动快速修复工具
echo =============================================
echo.
echo 📋 检测到的问题：
echo    设备ID: USB\VID_0000^&PID_0002
echo    状态: 未知USB设备（设备描述符请求失败）
echo    原因: 缺少合适的驱动程序
echo.

:main_menu
echo 🛠️ 可用的修复方案：
echo.
echo 1. 🚀 快速修复（推荐）- 自动安装通用驱动
echo 2. 🔧 手动修复 - 打开设备管理器手动安装
echo 3. 📥 下载专用驱动 - 获取CH340等驱动下载链接
echo 4. 🎯 设备激活指南 - 尝试激活编程模式 ^(新增^)
echo 5. 🔍 验证修复结果 - 检查设备是否正常识别
echo 6. ❌ 退出
echo.
set /p choice="请选择修复方案 (1-6): "

if "%choice%"=="1" goto quick_fix
if "%choice%"=="2" goto manual_fix
if "%choice%"=="3" goto download_drivers
if "%choice%"=="4" goto device_activation
if "%choice%"=="5" goto verify_fix
if "%choice%"=="6" goto exit
echo ❌ 无效选择，请重试
goto main_menu

:quick_fix
echo.
echo 🚀 正在执行快速修复...
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo.

echo 📋 步骤1: 安装通用USB串口驱动
pnputil /add-driver "%SystemRoot%\INF\usbser.inf" /install
if %errorlevel% equ 0 (
    echo ✅ 通用驱动安装成功
) else (
    echo ⚠️ 通用驱动安装可能失败，继续尝试其他方法
)

echo.
echo 📋 步骤2: 重新扫描硬件设备
pnputil /scan-devices
echo ✅ 硬件扫描完成

echo.
echo 📋 步骤3: 尝试强制设备重新枚举
powershell -Command "Get-PnpDevice | Where-Object {$_.InstanceId -like '*VID_0000*'} | Enable-PnpDevice -Confirm:$false"
echo ✅ 设备重新枚举完成

echo.
echo 📋 步骤4: 检查修复结果
timeout /t 3 /nobreak > nul
goto verify_fix

:manual_fix
echo.
echo 🔧 手动修复指南
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo.
echo 📋 即将打开设备管理器，请按照以下步骤操作：
echo.
echo 1️⃣ 在设备管理器中找到"未知USB设备"
echo    （通常在"其他设备"分类下，带黄色感叹号）
echo.
echo 2️⃣ 右键点击该设备，选择"更新驱动程序"
echo.
echo 3️⃣ 选择"浏览我的计算机以查找驱动程序"
echo.
echo 4️⃣ 选择"让我从计算机上的可用驱动程序列表中选取"
echo.
echo 5️⃣ 选择设备类型：
echo    - 首选：端口(COM和LPT)
echo    - 备选：通用串行总线控制器
echo.
echo 6️⃣ 选择厂商和型号（尝试以下选项）：
echo    选项1: (推荐)
echo      厂商: (标准端口类型)
echo      型号: 通信端口
echo.
echo    选项2: 如果选项1不可用：
echo      厂商: Microsoft
echo      型号: USB串行设备 或 Usbser
echo.
echo    选项3: 如果都不可用：
echo      厂商: (标准系统设备)
echo      型号: USB复合设备
echo.
echo 7️⃣ 点击"下一步"，如果出现警告选择"是"
echo.
echo 8️⃣ 等待安装完成，设备应该会变成COM端口
echo.
pause
echo 🔧 正在打开设备管理器...
start devmgmt.msc
echo.
echo 💡 完成手动安装后，请选择选项4验证修复结果
pause
goto main_menu

:download_drivers
echo.
echo 📥 驱动程序下载指南
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo.
echo 🔗 推荐下载以下驱动程序（按优先级排序）：
echo.
echo 1️⃣ CH340/CH341 驱动（最常用）
echo    官方下载: http://www.wch.cn/downloads/CH341SER_EXE.html
echo    备用链接: 搜索"CH340 driver windows"
echo.
echo 2️⃣ FTDI VCP 驱动
echo    官方下载: https://ftdichip.com/drivers/vcp-drivers/
echo.
echo 3️⃣ CP210x 驱动
echo    官方下载: https://www.silabs.com/developers/usb-to-uart-bridge-vcp-drivers
echo.
echo 📋 安装步骤：
echo    1. 下载对应的驱动程序
echo    2. 断开设备连接
echo    3. 运行驱动安装程序
echo    4. 重新连接设备
echo    5. 验证设备是否被识别
echo.
echo 💡 建议优先尝试CH340驱动，成功率最高！
echo.
pause
goto main_menu

:device_activation
echo.
echo 🎯 设备激活指南
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo.
echo 💡 您的设备ID USB\VID_0000^&PID_0002 表明这可能不是标准的
echo    USB转串口设备，很可能需要特殊的激活步骤进入编程模式！
echo.
echo 🔍 请在您的机器狗设备上查找以下按钮：
echo    - RESET 按钮 ^(通常很小，可能需要牙签按压^)
echo    - BOOT 按钮
echo    - MODE 按钮
echo    - 任何小的凹陷按钮
echo.
echo 📋 激活方法1: RESET按钮激活 ^(成功率最高^)
echo    1️⃣ 断开USB连接
echo    2️⃣ 按住设备上的RESET按钮
echo    3️⃣ 保持按住的同时连接USB线
echo    4️⃣ 等待3-5秒后释放按钮
echo    5️⃣ 观察Windows是否弹出"发现新硬件"提示
echo.
echo 📋 激活方法2: 双击激活
echo    1️⃣ 保持USB连接
echo    2️⃣ 快速双击RESET按钮 ^(1秒内点击两次^)
echo    3️⃣ 观察设备指示灯是否变化
echo.
echo 📋 激活方法3: 电源序列
echo    1️⃣ 断开USB连接
echo    2️⃣ 关闭设备电源 ^(如果有电源开关^)
echo    3️⃣ 等待5秒
echo    4️⃣ 重新开机
echo    5️⃣ 立即连接USB
echo.
echo ⚠️  重要提示：
echo    - 每次尝试后运行选项5验证结果
echo    - 观察设备上的LED指示灯变化
echo    - 有些设备需要特定的按钮组合 ^(查看说明书^)
echo    - 如果有多个按钮，尝试不同的组合
echo.
echo 💡 激活成功的标志：
echo    ✅ Windows弹出"正在安装设备驱动程序"
echo    ✅ 设备管理器中出现新的COM端口
echo    ✅ 设备指示灯状态发生变化
echo.
pause
goto main_menu

:verify_fix
echo.
echo 🔍 验证修复结果
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo.

echo 📋 正在检查串口设备...
set /a com_count=0
for /f "tokens=1,2 delims=," %%a in ('wmic path Win32_SerialPort get DeviceID^,Name /format:csv 2^>nul ^| findstr /v "Node"') do (
    if not "%%b"=="" (
        set /a com_count+=1
        echo ✅ 发现串口设备 !com_count!: %%b ^(%%a^)
    )
)

echo.
echo 📋 正在检查USB设备状态...
powershell -Command "Get-WmiObject Win32_PnPEntity | Where-Object {$_.DeviceID -like '*VID_0000*'} | Select-Object Name, Status | Format-Table -AutoSize"

if !com_count! gtr 0 (
    echo.
    echo 🎉 修复成功！
    echo ✅ 检测到 !com_count! 个串口设备
    echo 💡 您现在可以使用检测到的COM端口与机器狗通信
    echo.
    echo 📋 下一步建议：
    echo    1. 记录COM端口号（如COM3）
    echo    2. 使用串口调试工具测试通信
    echo    3. 开始编程开发
) else (
    echo.
    echo ❌ 修复可能未完全成功
    echo 💡 建议：
    echo    1. 尝试重新连接设备
    echo    2. 下载并安装CH340驱动
    echo    3. 联系厂商获取专用驱动
    echo    4. 考虑使用其他连接方式
)

echo.
pause
goto main_menu

:exit
echo.
echo 👋 退出修复工具
echo.
echo 📋 修复总结：
echo    - 如果看到COM端口，说明修复成功
echo    - 如果仍有问题，建议下载CH340驱动
echo    - 也可以联系厂商获取官方驱动程序
echo.
echo 💡 成功修复后，您可以：
echo    - 使用标准串口工具与设备通信
echo    - 开发自定义程序控制机器狗
echo    - 不再需要厂商的专用软件和下载器
echo.
pause
exit /b 0
