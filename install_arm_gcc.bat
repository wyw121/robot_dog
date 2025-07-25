@echo off
chcp 65001 >nul
echo ================================
echo     ARM GCC 自动安装工具
echo ================================
echo.

:: 检查是否以管理员身份运行
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo ⚠️  需要管理员权限安装编译器
    echo 🔄 正在请求管理员权限...
    powershell -Command "Start-Process cmd -ArgumentList '/c cd /d %cd% && %0' -Verb RunAs"
    exit /b
)

echo ✅ 管理员权限已获取
echo.

:: 创建下载目录
if not exist "%TEMP%\arm_gcc" mkdir "%TEMP%\arm_gcc"
cd /d "%TEMP%\arm_gcc"

echo 📁 工作目录: %cd%
echo.

:: 检查是否已安装
where arm-none-eabi-gcc >nul 2>&1
if %errorLevel% equ 0 (
    echo ✅ ARM GCC 已经安装！
    arm-none-eabi-gcc --version
    echo.
    goto :check_complete
)

echo 🔍 检测系统架构...
if "%PROCESSOR_ARCHITECTURE%"=="AMD64" (
    set "ARCH=win32"
    set "DOWNLOAD_URL=https://developer.arm.com/-/media/Files/downloads/gnu/13.2.rel1/binrel/arm-gnu-toolchain-13.2.rel1-mingw-w64-i686-arm-none-eabi.exe"
    set "INSTALLER=arm-gnu-toolchain-13.2.rel1-mingw-w64-i686-arm-none-eabi.exe"
) else (
    set "ARCH=win32"
    set "DOWNLOAD_URL=https://developer.arm.com/-/media/Files/downloads/gnu/13.2.rel1/binrel/arm-gnu-toolchain-13.2.rel1-mingw-w64-i686-arm-none-eabi.exe"
    set "INSTALLER=arm-gnu-toolchain-13.2.rel1-mingw-w64-i686-arm-none-eabi.exe"
)

echo 💻 系统架构: %ARCH%
echo 📥 下载地址: %DOWNLOAD_URL%
echo.

:: 检查是否已下载
if exist "%INSTALLER%" (
    echo ✅ 安装包已存在，跳过下载
) else (
    echo 📥 正在下载 ARM GCC 工具链...
    echo 这可能需要几分钟，请耐心等待...
    powershell -Command "& {[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri '%DOWNLOAD_URL%' -OutFile '%INSTALLER%' -UserAgent 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'}"

    if %errorLevel% neq 0 (
        echo ❌ 下载失败！请检查网络连接
        echo 🌐 手动下载地址: https://developer.arm.com/downloads/-/arm-gnu-toolchain-downloads
        pause
        exit /b 1
    )
    echo ✅ 下载完成！
)

echo.
echo 🚀 正在安装 ARM GCC 工具链...
echo 请在安装向导中：
echo    1. 选择安装路径（建议默认）
echo    2. ✅ 勾选 "Add path to environment variable"
echo    3. 点击 Install
echo.

start /wait "%INSTALLER%"

if %errorLevel% neq 0 (
    echo ❌ 安装失败！
    pause
    exit /b 1
)

echo ✅ 安装完成！
echo.

:check_complete
echo 🔄 刷新环境变量...
:: 刷新环境变量
for /f "tokens=2*" %%i in ('reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v PATH 2^>nul') do set "SYS_PATH=%%j"
for /f "tokens=2*" %%i in ('reg query "HKEY_CURRENT_USER\Environment" /v PATH 2^>nul') do set "USER_PATH=%%j"
set "PATH=%SYS_PATH%;%USER_PATH%"

echo.
echo 🔍 验证安装...
where arm-none-eabi-gcc >nul 2>&1
if %errorLevel% equ 0 (
    echo ✅ ARM GCC 安装成功！
    echo.
    echo 📋 版本信息:
    arm-none-eabi-gcc --version
    echo.
    echo 🎉 现在您可以在VSCode中编译STM32代码了！
    echo 💡 使用方法: 按 Ctrl+Shift+B 选择 "🚀 快速开始：编译并烧录"
) else (
    echo ⚠️  PATH环境变量可能需要重启才能生效
    echo 🔄 请重启VSCode或计算机后重试
)

echo.
echo 🧹 清理临时文件...
cd /d "%~dp0"
if exist "%TEMP%\arm_gcc" rmdir /s /q "%TEMP%\arm_gcc"

echo.
echo ================================
echo      安装完成！
echo ================================
pause
