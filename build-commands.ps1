# VS Code Tasks 替代脚本
# 由于 GitHub Issue #253265 兼容性问题，改用直接 PowerShell 命令

# ================================
# 🚀 快速开始：简化版构建
# ================================
function Start-SimpleBuild {
    Write-Host '🚀 开始简化版构建...' -ForegroundColor Green
    $workspaceFolder = 'd:\repositories\robot_dog\my_robot_dog_dev'
    Set-Location $workspaceFolder
    & "$workspaceFolder\build_simple.bat"
}

# ================================
# 🔧 完整版构建
# ================================
function Start-FullBuild {
    Write-Host '🔧 开始完整版构建...' -ForegroundColor Green
    $workspaceFolder = 'd:\repositories\robot_dog\my_robot_dog_dev'
    Set-Location $workspaceFolder
    & "$workspaceFolder\quick_stm32_build.bat"
}

# ================================
# 🌟 高级功能构建
# ================================
function Start-AdvancedBuild {
    Write-Host '🌟 开始高级功能构建...' -ForegroundColor Green
    $workspaceFolder = 'd:\repositories\robot_dog\my_robot_dog_dev'
    Set-Location $workspaceFolder
    & "$workspaceFolder\build_advanced.bat"
}

# ================================
# 🔧 安装ARM GCC编译器
# ================================
function Install-ArmGcc {
    Write-Host '🔧 打开 ARM GCC 下载页面...' -ForegroundColor Green
    Start-Process 'https://developer.arm.com/downloads/-/arm-gnu-toolchain-downloads'
}

# ================================
# 🔨 仅编译
# ================================
function Start-CompileOnly {
    Write-Host '🔨 开始仅编译...' -ForegroundColor Green
    $workspaceFolder = 'd:\repositories\robot_dog\my_robot_dog_dev'
    Set-Location $workspaceFolder
    make -f Makefile.test clean all
}

# ================================
# 📱 仅烧录
# ================================
function Start-FlashOnly {
    Write-Host '📱 开始仅烧录...' -ForegroundColor Green
    $workspaceFolder = 'd:\repositories\robot_dog\my_robot_dog_dev'
    Set-Location $workspaceFolder
    make -f Makefile.test flash
}

# ================================
# 使用说明
# ================================
function Show-BuildHelp {
    Write-Host @'
VS Code Tasks 替代命令 (GitHub Issue #253265 解决方案)
======================================================

可用命令:
  Start-SimpleBuild    - 🚀 快速开始：简化版构建
  Start-FullBuild      - 🔧 完整版构建
  Start-AdvancedBuild  - 🌟 高级功能构建
  Install-ArmGcc       - 🔧 安装ARM GCC编译器
  Start-CompileOnly    - 🔨 仅编译
  Start-FlashOnly      - 📱 仅烧录
  Show-BuildHelp       - 显示此帮助信息

使用方法:
  1. 在 PowerShell 中运行: . .\build-commands.ps1
  2. 然后直接调用函数，例如: Start-SimpleBuild

注意: 由于 VS Code Tasks 兼容性问题，建议使用这些直接命令。
'@ -ForegroundColor Yellow
}

# 显示帮助信息
Show-BuildHelp
