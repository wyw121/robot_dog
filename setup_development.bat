@echo off
chcp 65001 >nul
echo ================================
echo   STM32 开发环境快速设置
echo ================================
echo.

echo 🎯 方案1: 安装完整的STM32CubeIDE（推荐）
echo    - 包含ARM GCC编译器
echo    - 包含STM32CubeProgrammer
echo    - 一站式解决方案
echo.
echo 📥 下载地址: https://www.st.com/en/development-tools/stm32cubeide.html
echo.

echo 🎯 方案2: 仅安装ARM GCC工具链
echo    - 轻量级选择
echo    - 需要单独安装烧录工具
echo.
echo 📥 下载地址: https://developer.arm.com/downloads/-/arm-gnu-toolchain-downloads
echo    选择: arm-gnu-toolchain-13.2.rel1-mingw-w64-i686-arm-none-eabi.exe
echo.

echo 🎯 方案3: 使用包管理器安装（需要先安装chocolatey）
echo    choco install gcc-arm-embedded
echo.

echo ================================
echo 🚀 推荐安装步骤:
echo ================================
echo 1. 下载STM32CubeIDE
echo 2. 安装时选择默认路径
echo 3. 安装完成后重启VSCode
echo 4. 在VSCode中按 Ctrl+Shift+B 测试编译
echo.

echo 💡 正在为您打开STM32CubeIDE下载页面...
timeout /t 3 /nobreak >nul
start https://www.st.com/en/development-tools/stm32cubeide.html

echo.
echo 📋 安装完成后，请运行以下命令验证:
echo    arm-none-eabi-gcc --version
echo.

pause
