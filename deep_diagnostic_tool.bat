@echo off
setlocal enabledelayedexpansion
chcp 65001 > nul

echo ========================================
echo       机器狗设备深度诊断工具
echo ========================================
echo.

echo 🔍 当前检测到的问题设备：
echo   设备ID: USB\VID_0000^&PID_0002
echo   状态: Unknown USB Device (Device Descriptor Request Failed) - Error
echo.

echo 📊 这种错误通常由以下原因引起：
echo   1️⃣ USB线缆只支持充电，不支持数据传输
echo   2️⃣ 设备硬件故障或不兼容
echo   3️⃣ USB端口供电不足
echo   4️⃣ 需要特殊的驱动程序或固件
echo   5️⃣ 设备处于错误的模式（需要特殊操作激活）
echo.

echo 🛠️ 深度故障排除选项：
echo.
echo 1. 🔌 测试不同的USB端口和线缆
echo 2. 🔋 检查设备电源和模式
echo 3. 💾 尝试强制安装特定驱动
echo 4. 🔧 重置USB设备和端口
echo 5. 📱 检测设备是否需要特殊激活
echo 6. 📖 查看详细故障排除指南
echo 7. ❌ 退出
echo.

:menu
set /p choice="请选择诊断选项 (1-7): "

if "%choice%"=="1" goto test_hardware
if "%choice%"=="2" goto check_power
if "%choice%"=="3" goto force_driver
if "%choice%"=="4" goto reset_usb
if "%choice%"=="5" goto check_activation
if "%choice%"=="6" goto detailed_guide
if "%choice%"=="7" goto exit

echo ❌ 无效选项，请重新选择
goto menu

:test_hardware
echo.
echo 🔌 硬件测试指导：
echo.
echo 📋 请按照以下步骤测试：
echo.
echo 1️⃣ **USB线缆测试**
echo    - 断开当前USB线
echo    - 更换一根确认支持数据传输的USB线（不是纯充电线）
echo    - 重新连接设备
echo.
echo 2️⃣ **USB端口测试**
echo    - 尝试电脑后面的USB端口（通常供电更稳定）
echo    - 避免使用USB集线器
echo    - 尝试不同的USB 2.0和USB 3.0端口
echo.
echo 3️⃣ **设备状态测试**
echo    - 确保机器狗设备已开机
echo    - 检查设备上的LED指示灯状态
echo    - 如果有电源开关，确保已打开
echo.
echo 完成硬件测试后，按任意键返回检测...
pause
call .\usb_device_analyzer.bat
goto menu

:check_power
echo.
echo 🔋 设备电源和模式检查：
echo.
echo 📋 请检查以下项目：
echo.
echo 1️⃣ **设备电源状态**
echo    - 机器狗是否已充电或连接电源
echo    - 设备指示灯是否正常亮起
echo    - 是否有电源开关需要打开
echo.
echo 2️⃣ **设备模式检查**
echo    - 某些设备需要进入"编程模式"或"调试模式"
echo    - 查看设备说明书是否有特殊按键组合
echo    - 可能需要按住某个按钮再连接USB
echo.
echo 3️⃣ **常见激活方法**
echo    - 按住设备的复位按钮，然后连接USB
echo    - 同时按住多个按钮再连接USB
echo    - 先连接USB，再按特定按钮组合
echo.
echo 请尝试上述方法后按任意键继续...
pause
goto menu

:force_driver
echo.
echo 💾 强制安装驱动程序：
echo.
echo 🔧 方法1：使用Device Manager强制安装
echo.
echo 1. 打开设备管理器（即将为您打开）
echo 2. 找到"未知USB设备"（黄色感叹号）
echo 3. 右键 → 属性 → 详细信息
echo 4. 属性选择"硬件ID"，复制ID信息
echo 5. 右键 → 更新驱动程序
echo 6. 选择"浏览我的电脑以查找驱动程序"
echo 7. 选择"让我从计算机上的可用驱动程序列表中选取"
echo 8. 点击"从磁盘安装"
echo.
start devmgmt.msc
echo.
echo 🔧 方法2：尝试通用串行驱动
echo.
echo 在驱动列表中尝试：
echo - 通用串行总线控制器 → USB Serial Converter
echo - 端口(COM和LPT) → 通信端口(COM1)
echo - Universal Serial Bus controllers → USB Serial Converter
echo.
pause
goto menu

:reset_usb
echo.
echo 🔧 重置USB设备和端口：
echo.
echo 📋 执行USB重置操作：
echo.
echo 1️⃣ **软件重置**
echo    正在为您执行设备重置...
echo.

REM 禁用并重新启用USB设备
echo    尝试重置USB控制器...
devcon disable "USB\VID_0000&PID_0002*" 2>nul
timeout /t 2 >nul
devcon enable "USB\VID_0000&PID_0002*" 2>nul

echo.
echo 2️⃣ **硬件重置**
echo    - 断开设备USB连接
echo    - 等待10秒
echo    - 关闭设备电源（如果有开关）
echo    - 再等待10秒
echo    - 重新开机设备
echo    - 重新连接USB
echo.
echo 3️⃣ **系统重置**
echo    建议：重启电脑后重新尝试
echo.
echo 请执行硬件重置后按任意键继续...
pause
call .\usb_device_analyzer.bat
goto menu

:check_activation
echo.
echo 📱 检测设备特殊激活需求：
echo.
echo 🔍 某些机器狗设备需要特殊操作才能被识别：
echo.
echo 1️⃣ **常见激活模式**
echo.
echo    • **BootLoader模式**
echo      - 按住复位按钮，连接USB，等待3秒后松开
echo.
echo    • **DFU模式（Device Firmware Update）**
echo      - 按住特定按钮组合，然后连接USB
echo.
echo    • **下载模式**
echo      - 同时按住电源键+某个功能键，再连接USB
echo.
echo 2️⃣ **品牌特定方法**
echo.
echo    • **Arduino类设备**
echo      - 按住板上的复位按钮，连接USB
echo      - 或者连接USB后快速按两次复位按钮
echo.
echo    • **ESP32类设备**
echo      - 按住BOOT按钮，同时按复位按钮
echo      - 松开复位，保持BOOT按住，连接USB
echo.
echo    • **STM32类设备**
echo      - 将BOOT0引脚设置为高电平
echo      - 或按特定的按键组合
echo.
echo 3️⃣ **检查设备标识**
echo    请查看您的机器狗设备：
echo    - 设备背面或底部的型号标识
echo    - 是否有"BOOT"、"RST"、"RESET"等按钮
echo    - 设备说明书中的连接方法
echo.
echo 请根据设备说明尝试激活后按任意键继续...
pause
goto menu

:detailed_guide
echo.
echo 📖 详细故障排除指南：
echo.
echo ========================================
echo           完整诊断步骤
echo ========================================
echo.
echo 🔍 **问题分析**
echo.
echo 您的设备显示为：
echo - VID_0000 ^& PID_0002 （无效的厂商和产品ID）
echo - Device Descriptor Request Failed
echo.
echo 这通常表示：
echo ❌ 设备无法正确响应USB描述符请求
echo ❌ 可能是硬件故障、兼容性问题或需要特殊激活
echo.
echo 🛠️ **系统性解决方案**
echo.
echo **第一阶段：基础检查**
echo 1. 更换USB线缆（确保支持数据传输）
echo 2. 更换USB端口（优先使用主板直连端口）
echo 3. 检查设备电源状态
echo 4. 重启电脑
echo.
echo **第二阶段：驱动尝试**
echo 1. Windows自动驱动
echo 2. CH340/CH341驱动 ✓ (已安装)
echo 3. FTDI驱动
echo 4. CP210x驱动
echo 5. 通用USB转串口驱动
echo.
echo **第三阶段：高级诊断**
echo 1. 设备激活模式（按钮组合）
echo 2. 固件模式切换
echo 3. 专用软件激活
echo.
echo **第四阶段：专业方法**
echo 1. 使用专业USB分析工具
echo 2. 查找设备特定驱动
echo 3. 联系厂商技术支持
echo.
echo ⚠️ **重要提示**
echo.
echo 如果所有方法都无效，可能是：
echo - 设备硬件故障
echo - 设备与您的系统不兼容
echo - 需要特定的开发环境或软件
echo.
echo 建议：查找设备的官方文档或联系购买商家
echo.
pause
goto menu

:exit
echo.
echo 👋 退出深度诊断工具
echo.
echo 📋 **总结**
echo.
echo 您的设备状态：❌ 未能正确识别
echo 已尝试的方法：✓ CH340驱动安装
echo 建议的下一步：
echo.
echo 1️⃣ **硬件检查** - 更换USB线缆和端口
echo 2️⃣ **设备激活** - 尝试特殊按钮组合
echo 3️⃣ **其他驱动** - 尝试FTDI或CP210x驱动
echo 4️⃣ **联系支持** - 咨询设备厂商或销售商
echo.
echo 💡 如果问题解决，请运行 .\usb_device_analyzer.bat 验证
echo.
pause
exit /b 0
