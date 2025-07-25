#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
厂商HD文件深度分析工具
用于破解天问Block的文件格式
"""

import os
import sys
import binascii
from pathlib import Path

def analyze_hd_file_basic(file_path):
    """基础分析HD文件"""
    print(f"🔍 分析文件: {Path(file_path).name}")

    if not os.path.exists(file_path):
        print(f"❌ 文件不存在: {file_path}")
        return False

    file_size = os.path.getsize(file_path)
    print(f"📏 文件大小: {file_size} 字节 ({file_size/1024:.2f} KB)")

    try:
        with open(file_path, 'rb') as f:
            # 读取文件内容
            data = f.read()

            # 分析前64字节（文件头）
            header = data[:64]
            print(f"\n📋 文件头分析 (前64字节):")
            print("-" * 40)

            # 十六进制显示
            for i in range(0, min(64, len(header)), 16):
                line = header[i:i+16]
                hex_part = ' '.join(f'{b:02X}' for b in line)
                ascii_part = ''.join(chr(b) if 32 <= b <= 126 else '.' for b in line)
                print(f"{i:04X}: {hex_part:<48} |{ascii_part}|")

            # 查找字符串
            print(f"\n📝 可读字符串:")
            print("-" * 40)
            strings = find_readable_strings(data)
            for string in strings[:10]:  # 显示前10个字符串
                print(f"  '{string}'")

            # 字节统计
            print(f"\n📊 字节分布统计:")
            print("-" * 40)
            byte_counts = [0] * 256
            for byte in data:
                byte_counts[byte] += 1

            # 显示最常见的字节
            sorted_bytes = sorted(enumerate(byte_counts), key=lambda x: x[1], reverse=True)
            for byte_val, count in sorted_bytes[:10]:
                if count > 0:
                    percentage = (count / file_size) * 100
                    print(f"  0x{byte_val:02X}: {count:5d} 次 ({percentage:.1f}%)")

            # 计算熵值（衡量数据的随机性）
            entropy = calculate_entropy(data)
            print(f"\n🎲 文件熵值: {entropy:.3f}")
            if entropy > 7.5:
                print("  ⚠️ 高熵值，可能是加密或压缩数据")
            elif entropy < 5.0:
                print("  ✅ 低熵值，可能是未加密的结构化数据")
            else:
                print("  ℹ️ 中等熵值，需要进一步分析")

            return True

    except Exception as e:
        print(f"❌ 分析失败: {e}")
        return False

def find_readable_strings(data, min_length=4):
    """查找数据中的可读字符串"""
    strings = []
    current_string = ""

    for byte in data:
        if 32 <= byte <= 126:  # 可打印ASCII字符
            current_string += chr(byte)
        else:
            if len(current_string) >= min_length:
                strings.append(current_string)
            current_string = ""

    # 处理最后一个字符串
    if len(current_string) >= min_length:
        strings.append(current_string)

    # 去重并排序
    unique_strings = list(set(strings))
    unique_strings.sort(key=len, reverse=True)

    return unique_strings

def calculate_entropy(data):
    """计算数据的香农熵"""
    if not data:
        return 0

    # 统计每个字节的出现次数
    byte_counts = {}
    for byte in data:
        byte_counts[byte] = byte_counts.get(byte, 0) + 1

    # 计算熵值
    entropy = 0.0
    data_len = len(data)

    for count in byte_counts.values():
        probability = count / data_len
        if probability > 0:
            entropy -= probability * (probability.bit_length() - 1)

    return entropy

def compare_multiple_files():
    """比较多个HD文件"""
    print(f"\n🔄 批量文件比较分析:")
    print("=" * 60)

    # 查找所有HD文件
    base_path = Path(r"d:\repositories\robot_dog\3.桌宠狗代码及指令集（3代~9代的指令集及语音模块代码等）\2.腾哥每代语音模块开源代码")

    hd_files = []
    if base_path.exists():
        # 非AI版本
        non_ai_path = base_path / "非AI"
        if non_ai_path.exists():
            for file in non_ai_path.glob("*.hd"):
                hd_files.append(("非AI", file))

        # AI版本
        ai_path = base_path / "AI"
        if ai_path.exists():
            for file in ai_path.glob("*.hd"):
                hd_files.append(("AI", file))

    if not hd_files:
        print("❌ 未找到HD文件")
        return

    print(f"📁 找到 {len(hd_files)} 个HD文件:")
    file_info = {}

    for category, file_path in hd_files:
        print(f"\n📄 {category} - {file_path.name}")

        try:
            with open(file_path, 'rb') as f:
                data = f.read()
                size = len(data)
                header = data[:32]  # 前32字节作为特征
                entropy = calculate_entropy(data)

                file_info[file_path.name] = {
                    'category': category,
                    'size': size,
                    'header': header,
                    'entropy': entropy
                }

                print(f"  大小: {size:,} 字节")
                print(f"  熵值: {entropy:.3f}")

        except Exception as e:
            print(f"  ❌ 读取失败: {e}")

    # 分析文件间的相似性
    print(f"\n📊 文件相似性分析:")
    print("-" * 40)

    # 按大小分组
    size_groups = {}
    for name, info in file_info.items():
        size = info['size']
        if size not in size_groups:
            size_groups[size] = []
        size_groups[size].append(name)

    print("按大小分组:")
    for size, files in size_groups.items():
        print(f"  {size:,} 字节: {', '.join(files)}")

    # 检查文件头相似性
    print("\n文件头分析:")
    headers = {}
    for name, info in file_info.items():
        header_hex = binascii.hexlify(info['header'][:16]).decode()
        if header_hex not in headers:
            headers[header_hex] = []
        headers[header_hex].append(name)

    for header, files in headers.items():
        print(f"  头部 {header[:24]}...: {', '.join(files)}")

def create_analysis_report():
    """创建分析报告"""
    output_dir = Path("../output")
    output_dir.mkdir(exist_ok=True)

    report_file = output_dir / "hd_analysis_report.md"

    with open(report_file, 'w', encoding='utf-8') as f:
        f.write("# HD文件格式分析报告\n\n")
        f.write("## 分析概述\n\n")
        f.write("本报告分析了厂商定制的.hd文件格式，用于理解天问Block软件的固件格式。\n\n")
        f.write("## 发现\n\n")
        f.write("### 文件格式特征\n")
        f.write("- 文件扩展名: .hd\n")
        f.write("- 用途: 机器人桌宠狗固件\n")
        f.write("- 开发工具: 天问Block图形化编程软件\n\n")
        f.write("### 破解建议\n\n")
        f.write("1. **硬件分析**: 分析专用下载器的电路和通信协议\n")
        f.write("2. **文件格式**: 继续深入分析.hd文件的内部结构\n")
        f.write("3. **协议逆向**: 监听下载过程中的通信数据\n")
        f.write("4. **替代方案**: 开发自己的烧录工具\n\n")
        f.write("### 下一步行动\n\n")
        f.write("- [ ] 购买或借用专用下载器进行硬件分析\n")
        f.write("- [ ] 使用逻辑分析仪监听通信协议\n")
        f.write("- [ ] 开发.hd文件转换工具\n")
        f.write("- [ ] 制作兼容的烧录工具\n")

    print(f"\n📋 分析报告已保存到: {report_file}")

def main():
    """主函数"""
    print("🎯 厂商HD文件深度分析工具")
    print("=" * 60)
    print("目标: 破解天问Block的.hd文件格式")
    print("=" * 60)

    # 分析单个文件
    base_path = Path(r"d:\repositories\robot_dog\3.桌宠狗代码及指令集（3代~9代的指令集及语音模块代码等）\2.腾哥每代语音模块开源代码")

    # 先分析一个具体文件
    target_file = base_path / "非AI" / "腾哥9代桌宠狗.hd"
    if target_file.exists():
        success = analyze_hd_file_basic(str(target_file))
        if success:
            # 比较多个文件
            compare_multiple_files()

            # 创建分析报告
            create_analysis_report()
        else:
            print("❌ 单文件分析失败，跳过后续分析")
    else:
        print(f"❌ 目标文件不存在: {target_file}")
        print("请检查文件路径是否正确")

    print(f"\n🎉 分析完成！")
    print("💡 基于分析结果，推荐的破解步骤:")
    print("   1. 获取专用下载器进行硬件分析")
    print("   2. 使用示波器分析通信信号")
    print("   3. 开发替代的烧录工具")
    print("   4. 实现自定义固件开发环境")

if __name__ == "__main__":
    main()
