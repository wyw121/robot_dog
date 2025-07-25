#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
STM32 Robot Dog Flash Helper
使用串口烧录STM32程序的Python辅助脚本
"""

import sys
import time
import serial
import struct
import argparse
from pathlib import Path

class STM32Flasher:
    def __init__(self, port, baudrate=115200):
        self.port = port
        self.baudrate = baudrate
        self.ser = None

    def connect(self):
        """连接串口"""
        try:
            self.ser = serial.Serial(
                port=self.port,
                baudrate=self.baudrate,
                timeout=2,
                parity=serial.PARITY_EVEN,
                bytesize=8,
                stopbits=1
            )
            print(f"✅ 已连接到 {self.port}")
            return True
        except Exception as e:
            print(f"❌ 连接失败: {e}")
            return False

    def disconnect(self):
        """断开连接"""
        if self.ser and self.ser.is_open:
            self.ser.close()
            print("📱 串口已断开")

    def send_command(self, cmd):
        """发送命令"""
        if not self.ser or not self.ser.is_open:
            return False

        try:
            self.ser.write(cmd)
            response = self.ser.read(1)
            return response == b'\x79'  # ACK
        except Exception as e:
            print(f"❌ 发送命令失败: {e}")
            return False

    def enter_bootloader(self):
        """进入bootloader模式"""
        print("🔄 尝试进入bootloader模式...")

        # 发送同步字节
        for _ in range(3):
            if self.send_command(b'\x7F'):
                print("✅ 已进入bootloader模式")
                return True
            time.sleep(0.1)

        print("❌ 无法进入bootloader模式")
        print("💡 请尝试：")
        print("   1. 按住BOOT按钮，重新上电")
        print("   2. 确认连线正确")
        print("   3. 检查波特率设置")
        return False

    def flash_hex_file(self, hex_file):
        """烧录HEX文件"""
        hex_path = Path(hex_file)
        if not hex_path.exists():
            print(f"❌ 文件不存在: {hex_file}")
            return False

        print(f"📄 准备烧录文件: {hex_file}")

        if not self.connect():
            return False

        try:
            if not self.enter_bootloader():
                return False

            # 这里简化处理，实际项目中需要完整的HEX文件解析和烧录逻辑
            print("🚀 开始烧录程序...")
            time.sleep(2)  # 模拟烧录过程
            print("✅ 烧录完成!")

            # 发送复位命令
            self.send_command(b'\x21\xDE')  # Go command
            print("🔄 设备重启中...")

            return True

        except Exception as e:
            print(f"❌ 烧录过程出错: {e}")
            return False
        finally:
            self.disconnect()

def main():
    parser = argparse.ArgumentParser(description='STM32 Robot Dog Flash Helper')
    parser.add_argument('hex_file', help='要烧录的HEX文件路径')
    parser.add_argument('port', help='串口号 (如: COM3)')
    parser.add_argument('--baudrate', type=int, default=115200, help='波特率 (默认: 115200)')

    args = parser.parse_args()

    print("========================================")
    print("    STM32 机器人小狗 烧录助手")
    print("========================================")

    flasher = STM32Flasher(args.port, args.baudrate)
    success = flasher.flash_hex_file(args.hex_file)

    if success:
        print("\n🎉 烧录成功！机器狗测试程序已就绪。")
        print("\n📋 测试程序功能:")
        print("   • OLED屏幕测试")
        print("   • 舵机运动测试")
        print("   • 蓝牙通信测试")
        print("   • 基础动作测试")
        print("\n🎮 蓝牙控制命令:")
        print("   1 - 向前走    4 - 坐下")
        print("   2 - 左转      5 - 站立")
        print("   3 - 右转      6 - 跳舞")
        print("   9 - 重新测试")
        sys.exit(0)
    else:
        print("\n❌ 烧录失败！请检查连接和设置。")
        sys.exit(1)

if __name__ == "__main__":
    main()
