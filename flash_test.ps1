# STM32 机器人小狗 快速烧录脚本
param(
    [Parameter(Position = 0)]
    [string]$Mode = 'auto',

    [Parameter()]
    [string]$Port = 'COM3',

    [Parameter()]
    [string]$HexFile = 'robot_dog_test.hex'
)

$ErrorActionPreference = 'Stop'

function Write-StatusMessage {
    param($Message, $Type = 'Info')
    $timestamp = Get-Date -Format 'HH:mm:ss'
    switch ($Type) {
        'Success' { Write-Host "[$timestamp] ✅ $Message" -ForegroundColor Green }
        'Error' { Write-Host "[$timestamp] ❌ $Message" -ForegroundColor Red }
        'Warning' { Write-Host "[$timestamp] ⚠️ $Message" -ForegroundColor Yellow }
        'Info' { Write-Host "[$timestamp] ℹ️ $Message" -ForegroundColor Cyan }
        default { Write-Host "[$timestamp] $Message" }
    }
}

function Test-DeviceConnection {
    Write-StatusMessage '检查设备连接状态...' 'Info'

    try {
        $devices = Get-WmiObject -Class Win32_PnPEntity | Where-Object {
            $_.Name -like '*CH340*' -or $_.Name -like '*STM32*' -or $_.Name -like '*USB*Serial*'
        }

        if ($devices) {
            foreach ($device in $devices) {
                Write-StatusMessage "发现设备: $($device.Name)" 'Success'
            }
            return $true
        } else {
            Write-StatusMessage '未检测到STM32设备' 'Error'
            return $false
        }
    } catch {
        Write-StatusMessage "检查设备时出错: $($_.Exception.Message)" 'Error'
        return $false
    }
}

function Test-CompilerTools {
    Write-StatusMessage '检查编译工具...' 'Info'

    $tools = @('arm-none-eabi-gcc', 'make')
    $allFound = $true

    foreach ($tool in $tools) {
        try {
            $null = Get-Command $tool -ErrorAction Stop
            Write-StatusMessage "$tool - 已安装" 'Success'
        } catch {
            Write-StatusMessage "$tool - 未找到" 'Error'
            $allFound = $false
        }
    }

    return $allFound
}

function Test-FlashTools {
    Write-StatusMessage '检查烧录工具...' 'Info'

    $flashTools = @('STM32_Programmer_CLI.exe', 'stm32flash')
    $foundTool = $null

    foreach ($tool in $flashTools) {
        try {
            $null = Get-Command $tool -ErrorAction Stop
            Write-StatusMessage "$tool - 已安装" 'Success'
            $foundTool = $tool
            break
        } catch {
            Write-StatusMessage "$tool - 未找到" 'Warning'
        }
    }

    if (-not $foundTool) {
        Write-StatusMessage '未找到任何烧录工具' 'Error'
        Write-StatusMessage '建议安装 STM32CubeProgrammer' 'Info'
        return $false
    }

    return $foundTool
}

function Build-TestProgram {
    Write-StatusMessage '编译测试程序...' 'Info'

    try {
        # 清理之前的编译文件
        if (Test-Path 'Makefile.test') {
            & make -f Makefile.test clean 2>&1 | Out-Null
        }

        # 编译测试程序
        $result = & make -f Makefile.test test 2>&1

        if ($LASTEXITCODE -eq 0) {
            Write-StatusMessage '测试程序编译成功' 'Success'
            return $true
        } else {
            Write-StatusMessage '编译失败' 'Error'
            Write-Host $result
            return $false
        }
    } catch {
        Write-StatusMessage "编译过程出错: $($_.Exception.Message)" 'Error'
        return $false
    }
}

function Flash-Program {
    param($FlashTool, $HexFile, $Port)

    Write-StatusMessage "开始烧录程序到 $Port..." 'Info'

    if (-not (Test-Path $HexFile)) {
        Write-StatusMessage "HEX文件不存在: $HexFile" 'Error'
        return $false
    }

    try {
        switch -Wildcard ($FlashTool) {
            '*STM32_Programmer_CLI*' {
                $result = & $FlashTool -c port=$Port br=115200 -w $HexFile -v -rst 2>&1
            }
            '*stm32flash*' {
                $result = & $FlashTool -w $HexFile -v -g 0x0 $Port 2>&1
            }
            default {
                Write-StatusMessage "不支持的烧录工具: $FlashTool" 'Error'
                return $false
            }
        }

        if ($LASTEXITCODE -eq 0) {
            Write-StatusMessage '程序烧录成功!' 'Success'
            return $true
        } else {
            Write-StatusMessage '烧录失败' 'Error'
            Write-Host $result
            return $false
        }
    } catch {
        Write-StatusMessage "烧录过程出错: $($_.Exception.Message)" 'Error'
        return $false
    }
}

function Show-TestInstructions {
    Write-Host ''
    Write-Host '========================================'
    Write-Host '        🎉 烧录完成！' -ForegroundColor Green
    Write-Host '========================================'
    Write-Host ''
    Write-Host '📋 测试程序功能:' -ForegroundColor Cyan
    Write-Host '   📺 OLED显示测试'
    Write-Host '   🤖 舵机动作测试'
    Write-Host '   📡 蓝牙通信测试'
    Write-Host '   🎮 交互控制测试'
    Write-Host ''
    Write-Host '🎮 蓝牙控制命令:' -ForegroundColor Cyan
    Write-Host '   1 - 向前走    4 - 坐下'
    Write-Host '   2 - 左转      5 - 站立'
    Write-Host '   3 - 右转      6 - 跳舞'
    Write-Host '   9 - 重新测试'
    Write-Host ''
    Write-Host '📱 蓝牙连接设置:' -ForegroundColor Cyan
    Write-Host '   • 波特率: 9600'
    Write-Host '   • 数据位: 8，停止位: 1'
    Write-Host '   • 使用串口工具连接蓝牙进行测试'
    Write-Host ''
}

# 主程序逻辑
Write-Host '========================================'
Write-Host '    STM32 机器人小狗 烧录脚本' -ForegroundColor Yellow
Write-Host '========================================'
Write-Host ''

switch ($Mode.ToLower()) {
    'check' {
        Write-StatusMessage '执行环境检查...' 'Info'
        $deviceOK = Test-DeviceConnection
        $compilerOK = Test-CompilerTools
        $flashToolOK = Test-FlashTools

        if ($deviceOK -and $compilerOK -and $flashToolOK) {
            Write-StatusMessage '环境检查通过，可以开始烧录!' 'Success'
        } else {
            Write-StatusMessage '环境检查失败，请安装缺失的工具' 'Error'
        }
    }

    'auto' {
        Write-StatusMessage '自动模式：检查环境...' 'Info'

        if (-not (Test-DeviceConnection)) {
            Write-StatusMessage '设备连接检查失败，退出' 'Error'
            exit 1
        }

        if (-not (Test-CompilerTools)) {
            Write-StatusMessage '编译工具检查失败，退出' 'Error'
            exit 1
        }

        $flashTool = Test-FlashTools
        if (-not $flashTool) {
            Write-StatusMessage '烧录工具检查失败，退出' 'Error'
            exit 1
        }

        Write-StatusMessage '开始编译和烧录...' 'Info'

        if (-not (Build-TestProgram)) {
            Write-StatusMessage '编译失败，退出' 'Error'
            exit 1
        }

        if (Flash-Program -FlashTool $flashTool -HexFile $HexFile -Port $Port) {
            Show-TestInstructions
        } else {
            Write-StatusMessage '烧录失败' 'Error'
            exit 1
        }
    }

    'manual' {
        Write-StatusMessage '手动模式：请自行选择操作' 'Info'
        Write-Host '1. 检查环境'
        Write-Host '2. 编译程序'
        Write-Host '3. 烧录程序'
        Write-Host '4. 完整流程'
        $choice = Read-Host '请选择操作 (1-4)'

        switch ($choice) {
            '1' {
                Test-DeviceConnection
                Test-CompilerTools
                Test-FlashTools
            }
            '2' { Build-TestProgram }
            '3' {
                $flashTool = Test-FlashTools
                if ($flashTool) {
                    Flash-Program -FlashTool $flashTool -HexFile $HexFile -Port $Port
                }
            }
            '4' {
                & $MyInvocation.MyCommand.Path -Mode auto
            }
            default { Write-StatusMessage '无效选择' 'Error' }
        }
    }

    default {
        Write-StatusMessage "未知模式: $Mode" 'Error'
        Write-Host '使用方法:'
        Write-Host '  .\flash_test.ps1              # 自动模式'
        Write-Host '  .\flash_test.ps1 -Mode check  # 检查环境'
        Write-Host '  .\flash_test.ps1 -Mode manual # 手动模式'
    }
}
