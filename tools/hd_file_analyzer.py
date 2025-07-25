#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
.hd文件格式分析器
用于分析厂商自定义的.hd固件文件格式
"""

import os
import sys
import struct
import binascii
from pathlib import Path

def analyze_hd_file(file_path):
    """分析.hd文件的格式和内容"""
    print(f"🔍 分析文件: {file_path}")

    if not os.path.exists(file_path):
        print(f"❌ 文件不存在: {file_path}")
        return

    file_size = os.path.getsize(file_path)
    print(f"📏 文件大小: {file_size} 字节 ({file_size/1024:.2f} KB)")

    with open(file_path, 'rb') as f:
        # 读取文件头
        header = f.read(64)
        print(f"\n📋 文件头 (前64字节):")
        print(binascii.hexdump(header))

        # 检查是否有可识别的魔数
        magic_signatures = {
            b'STM32': 'STM32固件',
            b'ARM': 'ARM固件',
            b'CORTEX': 'Cortex固件',
            b'HEX': 'Intel HEX格式',
            b'ELF': 'ELF文件',
            b'BIN': '二进制固件',
            b'\x7fELF': 'ELF文件格式',
            b'MZ': 'PE可执行文件',
            b'PK': 'ZIP压缩包',
            b'\x1f\x8b': 'GZIP压缩',
        }

        print(f"\n🔍 魔数检测:")
        found_signature = False
        for signature, description in magic_signatures.items():
            if signature in header:
                print(f"  ✅ 发现 {description} 标识: {signature}")
                found_signature = True

        if not found_signature:
            print("  ❓ 未找到已知的文件格式标识")

        # 检查是否包含可打印字符串
        f.seek(0)
        data = f.read()

        print(f"\n📝 可打印字符串:")
        strings = extract_strings(data)
        if strings:
            for s in strings[:10]:  # 只显示前10个
                print(f"  - {s}")
            if len(strings) > 10:
                print(f"  ... 还有 {len(strings)-10} 个字符串")
        else:
            print("  ❓ 未找到明显的字符串")

        # 检查熵值（判断是否加密/压缩）
        entropy = calculate_entropy(data)
        print(f"\n📊 文件熵值: {entropy:.3f}")
        if entropy > 7.8:
            print("  🔐 高熵值，可能是加密或压缩文件")
        elif entropy > 7.0:
            print("  📦 中等熵值，可能包含压缩数据")
        else:
            print("  📄 低熵值，可能是普通数据文件")

        # 分析固定模式
        print(f"\n🔄 重复模式分析:")
        patterns = find_patterns(data[:1024])  # 分析前1KB
        for pattern, count in patterns:
            if count > 3:
                print(f"  - 模式 {binascii.hexlify(pattern).decode()}: 出现 {count} 次")

def extract_strings(data, min_length=4):
    """提取数据中的可打印字符串"""
    strings = []
    current_string = b""

    for byte in data:
        if 32 <= byte <= 126:  # 可打印ASCII字符
            current_string += bytes([byte])
        else:
            if len(current_string) >= min_length:
                try:
                    strings.append(current_string.decode('ascii'))
                except:
                    pass
            current_string = b""

    # 检查最后的字符串
    if len(current_string) >= min_length:
        try:
            strings.append(current_string.decode('ascii'))
        except:
            pass

    return strings

def calculate_entropy(data):
    """计算数据的熵值"""
    from collections import Counter
    import math

    if len(data) == 0:
        return 0

    # 计算字节频率
    byte_counts = Counter(data)
    data_len = len(data)

    # 计算熵
    entropy = 0
    for count in byte_counts.values():
        probability = count / data_len
        entropy -= probability * math.log2(probability)

    return entropy

def find_patterns(data, pattern_length=4):
    """查找重复的字节模式"""
    from collections import Counter

    patterns = []
    for i in range(len(data) - pattern_length + 1):
        pattern = data[i:i + pattern_length]
        patterns.append(pattern)

    pattern_counts = Counter(patterns)
    return pattern_counts.most_common(10)

def compare_hd_files(dir_path):
    """比较多个.hd文件的异同"""
    hd_files = list(Path(dir_path).rglob("*.hd"))

    if len(hd_files) < 2:
        print("❓ 需要至少2个.hd文件进行比较")
        return

    print(f"🔄 比较 {len(hd_files)} 个.hd文件:")

    file_info = {}
    for hd_file in hd_files[:5]:  # 只分析前5个文件
        print(f"\n📁 {hd_file.name}")
        with open(hd_file, 'rb') as f:
            data = f.read()
            file_info[hd_file.name] = {
                'size': len(data),
                'header': data[:64],
                'entropy': calculate_entropy(data),
                'strings': extract_strings(data)[:5]  # 前5个字符串
            }

    # 比较文件大小
    sizes = [info['size'] for info in file_info.values()]
    print(f"\n📏 文件大小范围: {min(sizes)} - {max(sizes)} 字节")

    # 比较文件头
    headers = [info['header'] for info in file_info.values()]
    if len(set(headers)) == 1:
        print("✅ 所有文件具有相同的文件头")
    else:
        print("❓ 文件头存在差异")

    # 比较熵值
    entropies = [info['entropy'] for info in file_info.values()]
    print(f"📊 熵值范围: {min(entropies):.3f} - {max(entropies):.3f}")

def main():
    """主函数"""
    print("🔧 .hd文件格式分析器")
    print("=" * 50)

    # 分析示例文件
    base_path = Path(r"d:\repositories\robot_dog\3.桌宠狗代码及指令集（3代~9代的指令集及语音模块代码等）\2.腾哥每代语音模块开源代码")

    # 分析非AI版本的第9代
    hd_file = base_path / "非AI" / "腾哥9代桌宠狗.hd"
    if hd_file.exists():
        analyze_hd_file(str(hd_file))

    print("\n" + "=" * 50)

    # 比较多个文件
    compare_hd_files(str(base_path))

    print("\n🎯 分析建议:")
    print("1. 如果发现明显的字符串，可能是未加密的固件")
    print("2. 如果熵值很高，可能需要进一步的解密/解压")
    print("3. 如果有重复模式，可能包含结构化数据")
    print("4. 建议使用二进制编辑器进一步分析")

if __name__ == "__main__":
    main()
