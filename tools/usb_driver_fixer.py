#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
机器狗设备驱动自动安装工具
专门解决USB设备识别问题
"""

import os
import sys
import subprocess
import winreg
import ctypes
from pathlib import Path

def is_admin():
    """检查是否具有管理员权限"""
    try:
        return ctypes.windll.shell32.IsUserAnAdmin()
    except:
        return False

def run_as_admin():
    """以管理员权限重新运行"""
    if not is_admin():
        print("🔑 需要管理员权限来安装驱动程序...")
        print("🔄 正在请求管理员权限...")

        # 以管理员权限重新运行当前脚本
        ctypes.windll.shell32.ShellExecuteW(
            None, "runas", sys.executable, " ".join(sys.argv), None, 1
        )
        return False
    return True

def download_drivers():
    """下载必要的驱动程序"""
    print("📥 准备下载驱动程序...")

    drivers = {
        "CH340": "http://www.wch.cn/downloads/file/5.html",
        "FTDI": "https://ftdichip.com/drivers/vcp-drivers/",
        "CP210x": "https://www.silabs.com/developers/usb-to-uart-bridge-vcp-drivers"
    }

    print("🔗 推荐的驱动下载链接：")
    for name, url in drivers.items():
        print(f"  📦 {name}: {url}")

    print("\n💡 请手动下载并安装以下驱动程序：")
    print("1. CH340/CH341 (最常用)")
    print("2. FTDI VCP (虚拟COM端口)")
    print("3. CP210x Universal")

def force_driver_install():
    """强制安装通用驱动"""
    print("🔧 尝试强制安装通用USB转串口驱动...")

    commands = [
        # 尝试安装内置的USB转串口驱动
        'pnputil /add-driver "C:\\Windows\\INF\\usbser.inf" /install',

        # 尝试扫描硬件变化
        'pnputil /scan-devices',

        # 重新枚举USB设备
        'devcon rescan'
    ]

    for cmd in commands:
        try:
            print(f"📋 执行: {cmd}")
            result = subprocess.run(cmd, shell=True, capture_output=True, text=True)
            if result.returncode == 0:
                print(f"✅ 成功")
            else:
                print(f"⚠️ 警告: {result.stderr}")
        except Exception as e:
            print(f"❌ 失败: {e}")

def manual_driver_assignment():
    """手动驱动分配指南"""
    print("🛠️ 手动驱动分配步骤：")
    print("=" * 50)

    print("1️⃣ 打开设备管理器：")
    print("   - 按 Win + X")
    print("   - 选择 '设备管理器'")

    print("\n2️⃣ 找到问题设备：")
    print("   - 查找 '未知 USB 设备' 或带感叹号的设备")
    print("   - 设备ID应该是: USB\\VID_0000&PID_0002")

    print("\n3️⃣ 手动安装驱动：")
    print("   - 右键点击问题设备")
    print("   - 选择 '更新驱动程序'")
    print("   - 选择 '浏览我的计算机以查找驱动程序'")
    print("   - 选择 '让我从计算机上的可用驱动程序列表中选取'")

    print("\n4️⃣ 选择驱动类型：")
    print("   - 选择 '端口(COM和LPT)'")
    print("   - 或选择 '通用串行总线控制器'")
    print("   - 厂商选择: Microsoft 或 (Standard system devices)")
    print("   - 型号选择: USB Serial Device 或 USB Composite Device")

    print("\n5️⃣ 强制安装：")
    print("   - 如果出现警告，选择 '是'")
    print("   - 等待安装完成")
    print("   - 检查设备是否出现COM端口")

def check_device_status():
    """检查设备当前状态"""
    print("🔍 检查设备状态...")

    try:
        # 使用PowerShell检查USB设备
        cmd = '''
        Get-WmiObject Win32_PnPEntity | Where-Object {
            $_.DeviceID -like "*USB*" -and
            ($_.Status -ne "OK" -or $_.Name -like "*Unknown*" -or $_.DeviceID -like "*VID_0000*")
        } | Select-Object Name, DeviceID, Status | Format-Table -AutoSize
        '''

        result = subprocess.run(
            ["powershell", "-Command", cmd],
            capture_output=True, text=True, encoding='utf-8'
        )

        if result.stdout:
            print("📋 发现的问题设备：")
            print(result.stdout)
            return True
        else:
            print("✅ 未发现问题设备")
            return False

    except Exception as e:
        print(f"❌ 检查失败: {e}")
        return False

def fix_usb_device():
    """修复USB设备识别问题"""
    print("🎯 机器狗USB设备修复工具")
    print("=" * 50)

    # 检查管理员权限
    if not run_as_admin():
        return

    print("✅ 管理员权限确认")

    # 检查设备状态
    has_problem = check_device_status()

    if not has_problem:
        print("🎉 没有发现问题设备，可能已经修复!")
        return

    print("\n🔧 开始修复流程...")

    # 方法1: 强制驱动安装
    print("\n📋 方法1: 自动驱动安装")
    force_driver_install()

    # 重新检查
    print("\n🔍 重新检查设备状态...")
    has_problem = check_device_status()

    if not has_problem:
        print("🎉 设备修复成功!")
        return

    # 方法2: 手动指导
    print("\n📋 方法2: 手动驱动安装")
    manual_driver_assignment()

    # 方法3: 驱动下载
    print("\n📋 方法3: 下载专用驱动")
    download_drivers()

    print("\n🎯 修复建议总结:")
    print("1. 优先尝试手动分配'USB Serial Device'驱动")
    print("2. 如果失败，下载CH340驱动程序")
    print("3. 联系厂商获取专用驱动程序")
    print("4. 考虑使用其他连接方式")

def main():
    """主函数"""
    try:
        fix_usb_device()
    except KeyboardInterrupt:
        print("\n\n👋 用户取消操作")
    except Exception as e:
        print(f"\n❌ 程序错误: {e}")
    finally:
        input("\n按Enter键退出...")

if __name__ == "__main__":
    main()
