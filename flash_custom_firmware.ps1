# 机器人小狗自定义固件烧录脚本
# 作者: GitHub Copilot
# 日期: 2025年7月26日

Write-Host '========================================' -ForegroundColor Cyan
Write-Host '🤖 机器人小狗自定义固件烧录工具' -ForegroundColor Yellow
Write-Host '========================================' -ForegroundColor Cyan
Write-Host ''

# 检查设备连接
Write-Host '🔍 [1/4] 检查设备连接...' -ForegroundColor Green
$comPorts = Get-WmiObject Win32_SerialPort | Where-Object { $_.Description -like '*CH340*' -or $_.Description -like '*USB*' }
if ($comPorts) {
    foreach ($port in $comPorts) {
        Write-Host "✅ 找到设备: $($port.DeviceID) - $($port.Description)" -ForegroundColor Green
    }
    $comPort = $comPorts[0].DeviceID
} else {
    Write-Host '❌ 未找到串口设备！请检查USB连接' -ForegroundColor Red
    exit 1
}

# 检查固件文件
Write-Host '📁 [2/4] 检查固件文件...' -ForegroundColor Green
$firmwareFiles = @(
    'build\robot_dog_firmware.hex',
    'build\robot_dog_advanced.hex'
)

$availableFiles = @()
foreach ($file in $firmwareFiles) {
    if (Test-Path $file) {
        $availableFiles += $file
        Write-Host "✅ 找到: $file" -ForegroundColor Green
    }
}

if ($availableFiles.Count -eq 0) {
    Write-Host '❌ 未找到可烧录的固件文件！' -ForegroundColor Red
    Write-Host '请先编译程序: .\build_simple.bat' -ForegroundColor Yellow
    exit 1
}

# 选择固件
Write-Host ''
Write-Host '📋 [3/4] 选择要烧录的固件:' -ForegroundColor Green
for ($i = 0; $i -lt $availableFiles.Count; $i++) {
    Write-Host "  $($i + 1). $($availableFiles[$i])" -ForegroundColor Cyan
}
Write-Host ''

do {
    $choice = Read-Host "请选择固件编号 (1-$($availableFiles.Count))"
    $choiceNum = [int]$choice - 1
} while ($choiceNum -lt 0 -or $choiceNum -ge $availableFiles.Count)

$selectedFile = $availableFiles[$choiceNum]
Write-Host "📦 选择的固件: $selectedFile" -ForegroundColor Yellow

# 重要提醒
Write-Host ''
Write-Host '⚠️  重要提醒：烧录前必须进入BOOT模式！' -ForegroundColor Red -BackgroundColor Yellow
Write-Host '   1. 找到PCB上的BOOT0引脚或按钮' -ForegroundColor White
Write-Host '   2. 将BOOT0连接到3.3V (或按住BOOT按钮)' -ForegroundColor White
Write-Host '   3. 重新上电或按复位按钮' -ForegroundColor White
Write-Host '   4. 设备进入烧录模式后按回车继续' -ForegroundColor White
Write-Host ''
Read-Host '确认设备已进入BOOT模式，按回车继续...'

# 尝试多种烧录方式
Write-Host '🔥 [4/4] 开始烧录固件...' -ForegroundColor Green

# 方式1: 尝试使用STM32CubeProgrammer (如果可用)
Write-Host '尝试方式1: STM32CubeProgrammer...' -ForegroundColor Cyan
$cubeProgPath = @(
    'C:\Program Files\STMicroelectronics\STM32Cube\STM32CubeProgrammer\bin\STM32_Programmer_CLI.exe',
    'C:\ST\STM32CubeProgrammer\bin\STM32_Programmer_CLI.exe'
)

$foundCubeProg = $null
foreach ($path in $cubeProgPath) {
    if (Test-Path $path) {
        $foundCubeProg = $path
        break
    }
}

if ($foundCubeProg) {
    Write-Host "✅ 找到STM32CubeProgrammer: $foundCubeProg" -ForegroundColor Green
    try {
        $cmd = "&'$foundCubeProg' -c port=$comPort br=115200 -w '$selectedFile' -v -rst"
        Write-Host "执行命令: $cmd" -ForegroundColor Gray
        Invoke-Expression $cmd
        if ($LASTEXITCODE -eq 0) {
            Write-Host '🎉 烧录成功！' -ForegroundColor Green -BackgroundColor Black
            Write-Host '请断开BOOT0连接并重新上电以运行新固件' -ForegroundColor Yellow
            exit 0
        } else {
            Write-Host '❌ STM32CubeProgrammer烧录失败' -ForegroundColor Red
        }
    } catch {
        Write-Host "❌ STM32CubeProgrammer执行出错: $($_.Exception.Message)" -ForegroundColor Red
    }
} else {
    Write-Host '⚠️  未找到STM32CubeProgrammer' -ForegroundColor Yellow
}

# 方式2: 尝试使用stm32flash
Write-Host ''
Write-Host '尝试方式2: stm32flash...' -ForegroundColor Cyan
$stm32flashPaths = @(
    'stm32flash.exe',
    'tools\stm32flash.exe',
    'C:\tools\stm32flash\stm32flash.exe'
)

$foundStm32flash = $null
foreach ($path in $stm32flashPaths) {
    try {
        $result = Get-Command $path -ErrorAction SilentlyContinue
        if ($result) {
            $foundStm32flash = $result.Source
            break
        }
    } catch {
        # 继续尝试下一个路径
    }
}

if ($foundStm32flash) {
    Write-Host "✅ 找到stm32flash: $foundStm32flash" -ForegroundColor Green
    try {
        $cmd = "&'$foundStm32flash' -w '$selectedFile' -v -g 0x0 $comPort"
        Write-Host "执行命令: $cmd" -ForegroundColor Gray
        Invoke-Expression $cmd
        if ($LASTEXITCODE -eq 0) {
            Write-Host '🎉 烧录成功！' -ForegroundColor Green -BackgroundColor Black
            Write-Host '请断开BOOT0连接并重新上电以运行新固件' -ForegroundColor Yellow
            exit 0
        } else {
            Write-Host '❌ stm32flash烧录失败' -ForegroundColor Red
        }
    } catch {
        Write-Host "❌ stm32flash执行出错: $($_.Exception.Message)" -ForegroundColor Red
    }
} else {
    Write-Host '⚠️  未找到stm32flash工具' -ForegroundColor Yellow
}

# 提供下载建议
Write-Host ''
Write-Host '💡 建议解决方案:' -ForegroundColor Cyan
Write-Host '1. 安装STM32CubeProgrammer:' -ForegroundColor White
Write-Host '   https://www.st.com/zh/development-tools/stm32cubeprog.html' -ForegroundColor Blue
Write-Host ''
Write-Host '2. 或下载stm32flash工具:' -ForegroundColor White
Write-Host '   https://sourceforge.net/projects/stm32flash/' -ForegroundColor Blue
Write-Host ''
Write-Host '3. 安装后重新运行此脚本' -ForegroundColor White

Write-Host ''
Write-Host '📝 手动烧录命令参考:' -ForegroundColor Cyan
Write-Host "STM32CubeProgrammer: STM32_Programmer_CLI -c port=$comPort br=115200 -w '$selectedFile' -v -rst" -ForegroundColor Gray
Write-Host "stm32flash: stm32flash -w '$selectedFile' -v -g 0x0 $comPort" -ForegroundColor Gray

Read-Host '按回车键退出...'
