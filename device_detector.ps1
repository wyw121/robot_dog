# 设备检测程序 - PowerShell版本
# 直接用PowerShell实现设备检测功能

function Show-Title {
    Clear-Host
    Write-Host '========================================' -ForegroundColor Cyan
    Write-Host '           机器狗设备检测器' -ForegroundColor Cyan
    Write-Host '           (PowerShell版本)' -ForegroundColor Cyan
    Write-Host '========================================' -ForegroundColor Cyan
    Write-Host '使用说明：' -ForegroundColor Yellow
    Write-Host '1. 先运行一次脚本，记录当前设备列表' -ForegroundColor White
    Write-Host '2. 插入您的机器狗设备' -ForegroundColor White
    Write-Host '3. 再次运行脚本，对比新增的设备' -ForegroundColor White
    Write-Host '4. 新增的设备就是您的机器狗!' -ForegroundColor White
    Write-Host '========================================' -ForegroundColor Cyan
    Write-Host ''
}

function Get-SerialPorts {
    Write-Host '当前检测到的串口设备：' -ForegroundColor Green
    Write-Host '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━' -ForegroundColor White

    $portCount = 0

    try {
        # 方法1: 使用WMI查询串口设备
        $ports = Get-WmiObject -Class Win32_SerialPort | Where-Object { $_.Name -ne $null }

        foreach ($port in $ports) {
            $portCount++
            Write-Host "📱 设备 $portCount`: " -ForegroundColor Blue -NoNewline
            Write-Host "$($port.DeviceID)" -ForegroundColor White -NoNewline
            Write-Host ' -> ' -ForegroundColor Cyan -NoNewline
            Write-Host "$($port.Name)" -ForegroundColor Green

            # 设备类型识别
            $name = $port.Name.ToLower()
            if ($name -match 'usb') {
                Write-Host '   💡 这是一个USB串口设备' -ForegroundColor Yellow
            }
            if ($name -match 'ch340|ch341') {
                Write-Host '   💡 检测到CH340/CH341芯片 (常用于Arduino兼容设备)' -ForegroundColor Yellow
            }
            if ($name -match 'ftdi') {
                Write-Host '   💡 检测到FTDI芯片 (高质量USB转串口)' -ForegroundColor Yellow
            }
            if ($name -match 'cp210') {
                Write-Host '   💡 检测到CP210x芯片 (Silicon Labs USB转串口)' -ForegroundColor Yellow
            }
            Write-Host ''
        }

        # 方法2: 检查.NET Framework的串口
        if ($portCount -eq 0) {
            Write-Host '尝试使用.NET方法检测...' -ForegroundColor Yellow
            [System.IO.Ports.SerialPort]::getportnames() | ForEach-Object {
                $portCount++
                Write-Host "📱 设备 $portCount`: " -ForegroundColor Blue -NoNewline
                Write-Host "$_" -ForegroundColor Green

                # 尝试测试端口可用性
                try {
                    $testPort = New-Object System.IO.Ports.SerialPort $_
                    $testPort.Open()
                    $testPort.Close()
                    Write-Host '   ✅ 端口可以正常访问' -ForegroundColor Green
                } catch {
                    Write-Host '   ❌ 端口无法访问 (可能被占用)' -ForegroundColor Red
                }
                Write-Host ''
            }
        }

    } catch {
        Write-Host "❌ 检测串口时出现错误: $($_.Exception.Message)" -ForegroundColor Red
    }

    Write-Host '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━' -ForegroundColor White

    if ($portCount -eq 0) {
        Write-Host '❌ 未检测到任何串口设备' -ForegroundColor Red
        Write-Host '💡 请检查：' -ForegroundColor Yellow
        Write-Host '   - 设备是否正确连接到电脑' -ForegroundColor White
        Write-Host '   - 设备驱动程序是否已安装' -ForegroundColor White
        Write-Host '   - USB线缆是否正常工作' -ForegroundColor White
    } else {
        Write-Host "✅ 总共检测到 $portCount 个串口设备" -ForegroundColor Green
    }

    return $portCount
}

function Test-PortAccess {
    param($PortName)

    try {
        $port = New-Object System.IO.Ports.SerialPort $PortName
        $port.Open()
        $port.Close()
        Write-Host "✅ $PortName 可以正常访问" -ForegroundColor Green
        return $true
    } catch {
        Write-Host "❌ $PortName 无法访问: $($_.Exception.Message)" -ForegroundColor Red
        return $false
    }
}

function Show-Menu {
    Write-Host ''
    Write-Host '选择操作：' -ForegroundColor Cyan
    Write-Host '1. ' -ForegroundColor White -NoNewline
    Write-Host '🔍 重新扫描设备' -ForegroundColor Green
    Write-Host '2. ' -ForegroundColor White -NoNewline
    Write-Host '📋 测试特定COM口访问' -ForegroundColor Yellow
    Write-Host '3. ' -ForegroundColor White -NoNewline
    Write-Host '📖 查看详细说明' -ForegroundColor Blue
    Write-Host '4. ' -ForegroundColor White -NoNewline
    Write-Host '❌ 退出程序' -ForegroundColor Red
    Write-Host ''
    $choice = Read-Host '请输入选项 (1-4)'
    return $choice
}

function Show-Instructions {
    Clear-Host
    Write-Host '========================================' -ForegroundColor Cyan
    Write-Host '           详细使用说明' -ForegroundColor Cyan
    Write-Host '========================================' -ForegroundColor Cyan
    Write-Host ''
    Write-Host '🎯 目标：找到您的机器狗设备名称' -ForegroundColor Yellow
    Write-Host ''
    Write-Host '📝 操作步骤：' -ForegroundColor Green
    Write-Host '1️⃣  首先拔掉机器狗设备' -ForegroundColor White
    Write-Host '2️⃣  运行此脚本，记录当前的设备列表' -ForegroundColor White
    Write-Host '3️⃣  插入机器狗设备并等待系统识别' -ForegroundColor White
    Write-Host '4️⃣  再次扫描设备，新出现的就是您的机器狗' -ForegroundColor White
    Write-Host ''
    Write-Host '🔍 设备识别提示：' -ForegroundColor Blue
    Write-Host '• 机器狗通常显示为 COM1, COM3, COM4 等' -ForegroundColor White
    Write-Host '• 设备名可能包含 USB, CH340, FTDI 等关键词' -ForegroundColor White
    Write-Host '• 如果有多个设备，可以逐个测试' -ForegroundColor White
    Write-Host ''
    Write-Host '⚠️  注意事项：' -ForegroundColor Magenta
    Write-Host '• 确保机器狗设备已正确安装驱动' -ForegroundColor White
    Write-Host '• 如果设备无法访问，可能被其他程序占用' -ForegroundColor White
    Write-Host '• 某些设备可能需要特定的波特率设置' -ForegroundColor White
    Write-Host ''
    Read-Host '按任意键返回主菜单'
}

# 主程序循环
do {
    Show-Title
    $portCount = Get-SerialPorts
    $choice = Show-Menu

    switch ($choice) {
        '1' {
            Write-Host '🔄 正在重新扫描设备...' -ForegroundColor Green
            Start-Sleep -Seconds 1
        }
        '2' {
            $portName = Read-Host '请输入要测试的COM口名称 (例如: COM3)'
            if ($portName) {
                Test-PortAccess $portName
                Read-Host '按任意键继续'
            }
        }
        '3' {
            Show-Instructions
        }
        '4' {
            Write-Host '👋 感谢使用机器狗设备检测器！' -ForegroundColor Green
            exit
        }
        default {
            Write-Host '❌ 无效选项，请重新选择' -ForegroundColor Red
            Start-Sleep -Seconds 1
        }
    }
} while ($true)
