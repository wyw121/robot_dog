@echo off
chcp 65001 > nul
echo.
echo ========================================
echo           设备检测程序编译器
echo ========================================
echo.

REM 检查是否有Visual Studio编译器
where cl.exe >nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ 找到Visual Studio编译器
    goto :compile_with_msvc
)

REM 检查是否有MinGW编译器
where gcc.exe >nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ 找到MinGW编译器
    goto :compile_with_gcc
)

REM 都没有找到编译器
echo ❌ 未找到C编译器
echo.
echo 💡 安装建议：
echo    方案1: 安装MinGW-w64
echo           下载地址: https://www.mingw-w64.org/downloads/
echo           或使用: winget install mingw
echo.
echo    方案2: 安装Visual Studio Community
echo           下载地址: https://visualstudio.microsoft.com/
echo.
echo    方案3: 使用在线编译工具或IDE
echo           如: Code::Blocks, Dev-C++等
echo.
pause
goto :end

:compile_with_gcc
echo 🔨 使用GCC编译...
if not exist "build" mkdir "build"
gcc -Wall -Wextra -std=c99 -o build/device_detector.exe src/device_detector.c -ladvapi32
if %errorlevel% equ 0 (
    echo ✅ 编译成功！
    goto :run_program
) else (
    echo ❌ 编译失败
    pause
    goto :end
)

:compile_with_msvc
echo 🔨 使用MSVC编译...
if not exist "build" mkdir "build"
cl /nologo src/device_detector.c /Fe:build/device_detector.exe advapi32.lib
if %errorlevel% equ 0 (
    echo ✅ 编译成功！
    goto :run_program
) else (
    echo ❌ 编译失败
    pause
    goto :end
)

:run_program
echo.
echo 🚀 是否立即运行设备检测程序? (Y/N)
set /p choice="请选择: "
if /i "%choice%"=="Y" (
    echo.
    echo 启动设备检测器...
    build\device_detector.exe
) else (
    echo.
    echo 💡 要手动运行程序，请执行: build\device_detector.exe
)

:end
echo.
pause
