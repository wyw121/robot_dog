# HD文件XML结构分析器
# 用PowerShell分析天问Block的HD文件

param(
    [string]$FilePath = 'd:\repositories\robot_dog\3.桌宠狗代码及指令集（3代~9代的指令集及语音模块代码等）\2.腾哥每代语音模块开源代码\非AI\腾哥9代桌宠狗.hd'
)

Write-Host '🔍 HD文件XML结构分析器' -ForegroundColor Yellow
Write-Host '=' * 50 -ForegroundColor Yellow

if (-not (Test-Path $FilePath)) {
    Write-Host "❌ 文件不存在: $FilePath" -ForegroundColor Red
    exit 1
}

try {
    # 读取XML文件
    Write-Host "📁 正在分析文件: $(Split-Path $FilePath -Leaf)" -ForegroundColor Green
    $xml = [xml](Get-Content $FilePath -Encoding UTF8)

    # 基本信息
    Write-Host "`n📊 基本信息:" -ForegroundColor Cyan
    Write-Host "根元素: $($xml.DocumentElement.LocalName)"
    Write-Host "命名空间: $($xml.DocumentElement.NamespaceURI)"
    Write-Host "总块数: $($xml.xml.block.Count)"

    # 分析块类型
    Write-Host "`n🧩 块类型分析:" -ForegroundColor Cyan
    $blockTypes = @{}
    $xml.xml.block | ForEach-Object {
        $type = $_.type
        if ($blockTypes.ContainsKey($type)) {
            $blockTypes[$type]++
        } else {
            $blockTypes[$type] = 1
        }
    }

    $blockTypes.GetEnumerator() | Sort-Object Value -Descending | ForEach-Object {
        Write-Host "  $($_.Key): $($_.Value) 个"
    }

    # 分析主要功能块
    Write-Host "`n🎯 主要功能块:" -ForegroundColor Cyan
    $xml.xml.block | ForEach-Object {
        $block = $_
        $type = $block.type
        $id = $block.id

        # 查找有名称的块
        if ($block.field -and $block.field.name -eq 'NAME') {
            $name = $block.field.'#text'
            Write-Host "  📦 $type - $name (ID: $id)"
        }

        # 查找注释
        if ($block.comment) {
            $comment = $block.comment.'#text'
            if ($comment -and $comment.Length -gt 0) {
                Write-Host "    💬 注释: $comment"
            }
        }
    }

    # 查找字符串内容
    Write-Host "`n📝 发现的文本内容:" -ForegroundColor Cyan
    $textContents = @()

    function Get-TextContent($node) {
        if ($node.field -and $node.field.input) {
            $textContents += $node.field.input
        }
        if ($node.field -and $node.field.'#text') {
            $textContents += $node.field.'#text'
        }
        if ($node.comment -and $node.comment.'#text') {
            $textContents += $node.comment.'#text'
        }

        # 递归处理子节点
        if ($node.statement) {
            Get-TextContent $node.statement
        }
        if ($node.next) {
            Get-TextContent $node.next
        }
        if ($node.block) {
            if ($node.block.Count) {
                $node.block | ForEach-Object { Get-TextContent $_ }
            } else {
                Get-TextContent $node.block
            }
        }
    }

    $xml.xml.block | ForEach-Object { Get-TextContent $_ }

    $textContents | Where-Object { $_ -and $_.Length -gt 0 } | Select-Object -Unique | ForEach-Object {
        Write-Host "  📄 '$_'"
    }

    # 导出结构化数据
    Write-Host "`n💾 导出分析结果..." -ForegroundColor Cyan
    $analysisResult = @{
        fileName     = Split-Path $FilePath -Leaf
        fileSize     = (Get-Item $FilePath).Length
        totalBlocks  = $xml.xml.block.Count
        blockTypes   = $blockTypes
        textContents = $textContents
        analysisTime = Get-Date
    }

    $outputPath = "../output/hd_analysis_$(Get-Date -Format 'yyyyMMdd_HHmmss').json"
    $analysisResult | ConvertTo-Json -Depth 3 | Out-File $outputPath -Encoding UTF8
    Write-Host "✅ 分析结果已保存到: $outputPath" -ForegroundColor Green

} catch {
    Write-Host "❌ XML解析失败: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host '可能的原因: 文件格式不正确或编码问题' -ForegroundColor Yellow
}

Write-Host "`n🎉 分析完成！" -ForegroundColor Green
Write-Host '💡 发现: HD文件是标准XML格式，可以直接解析和修改！' -ForegroundColor Yellow
