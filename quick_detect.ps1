# 快速串口设备检测器 - 简化版
Write-Host '===========================================' -ForegroundColor Cyan
Write-Host '        机器狗设备快速检测器' -ForegroundColor Cyan
Write-Host '===========================================' -ForegroundColor Cyan
Write-Host ''

Write-Host '🔍 正在检测串口设备...' -ForegroundColor Yellow
Write-Host ''

# 方法1: 使用.NET Framework检测串口
try {
    Add-Type -AssemblyName System.IO.Ports
    $ports = [System.IO.Ports.SerialPort]::GetPortNames()

    if ($ports.Count -gt 0) {
        Write-Host '✅ 检测到以下串口设备:' -ForegroundColor Green
        Write-Host '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━' -ForegroundColor White

        for ($i = 0; $i -lt $ports.Count; $i++) {
            Write-Host "📱 设备 $($i+1): " -ForegroundColor Blue -NoNewline
            Write-Host "$($ports[$i])" -ForegroundColor Green

            # 尝试获取更多信息
            try {
                $port = Get-WmiObject -Class Win32_SerialPort | Where-Object { $_.DeviceID -eq $ports[$i] }
                if ($port) {
                    Write-Host "   名称: $($port.Name)" -ForegroundColor White
                    Write-Host "   描述: $($port.Description)" -ForegroundColor Gray
                }
            } catch {
                Write-Host '   (无法获取详细信息)' -ForegroundColor Gray
            }
            Write-Host ''
        }

        Write-Host '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━' -ForegroundColor White
        Write-Host "✅ 总共找到 $($ports.Count) 个串口设备" -ForegroundColor Green

    } else {
        Write-Host '❌ 未检测到任何串口设备' -ForegroundColor Red
        Write-Host ''
        Write-Host '💡 可能的原因:' -ForegroundColor Yellow
        Write-Host '   - 机器狗设备未连接' -ForegroundColor White
        Write-Host '   - 设备驱动未安装' -ForegroundColor White
        Write-Host '   - USB线缆故障' -ForegroundColor White
        Write-Host '   - 设备未开机或故障' -ForegroundColor White
    }

} catch {
    Write-Host "❌ 检测过程中出现错误: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host ''
Write-Host '📖 使用说明:' -ForegroundColor Cyan
Write-Host '1. 记录当前显示的设备列表' -ForegroundColor White
Write-Host '2. 插入您的机器狗设备' -ForegroundColor White
Write-Host '3. 重新运行此脚本' -ForegroundColor White
Write-Host '4. 新出现的设备就是您的机器狗!' -ForegroundColor White
Write-Host ''

# 询问是否重新检测
$choice = Read-Host '是否重新检测? (y/n)'
if ($choice -eq 'y' -or $choice -eq 'Y') {
    Clear-Host
    & $MyInvocation.MyCommand.Path
}
