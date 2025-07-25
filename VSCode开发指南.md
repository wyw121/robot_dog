# 🚀 VSCode 机器狗开发完全指南

## 🎯 概述

完全可以在VSCode中进行STM32机器狗的开发！无需STM32CubeIDE，VSCode提供了更灵活和强大的开发体验。

## 🛠️ VSCode开发环境配置

### 1. 必需扩展
VSCode会自动提示安装以下扩展：
- **C/C++** - 代码智能提示和调试
- **Cortex-Debug** - ARM Cortex调试支持
- **Makefile Tools** - Makefile项目支持
- **PowerShell** - 脚本支持

### 2. 开发工具链
需要安装以下工具（只需要一次）：
```bash
# ARM GCC编译器
https://developer.arm.com/downloads/-/arm-gnu-toolchain-downloads

# 烧录工具（任选其一）
STM32CubeProgrammer  # 推荐
stm32flash          # 轻量级选择
```

## 🚀 快速开始

### 方法1：使用内置任务（推荐）

1. **打开命令面板**: `Ctrl + Shift + P`
2. **运行任务**: 输入 `Tasks: Run Task`
3. **选择任务**:
   - 🔧 编译测试程序
   - 🔥 烧录测试程序
   - 🔍 检查设备连接
   - 📱 串口监视器

### 方法2：使用快捷键

- **编译**: `Ctrl + Shift + B`
- **烧录**: 运行 "🔥 烧录测试程序" 任务

### 方法3：使用终端

```bash
# 编译
make -f Makefile.test test

# 烧录
.\flash_test.ps1 -Mode auto

# 检查环境
.\flash_test.ps1 -Mode check
```

## 🔧 添加新功能的步骤

### 1. 创建新功能文件

我已经为你创建了示例文件：
- `src/custom_features.c` - 自定义功能实现
- `src/custom_features.h` - 头文件

### 2. 编辑功能代码

在VSCode中打开 `src/custom_features.c`，里面包含了以下示例功能：

```c
// 🌈 呼吸灯效果
Custom_BreathingLight();

// ❤️ 心跳显示
Custom_HeartBeat();

// 🌈 彩虹舞蹈
Custom_RainbowDance();

// 🤖 智能巡逻
Custom_SmartPatrol();

// 🎵 音乐舞蹈
Custom_MusicDance(BEAT_STRONG);

// 😊 情感表达
Custom_EmotionExpression(EMOTION_HAPPY);
```

### 3. 集成到主程序

修改 `src/main.c` 或 `src/test_program.c`：

```c
#include "custom_features.h"

// 在主循环中调用
while(1) {
    Custom_FeatureDemo();  // 演示所有新功能
    Delay_ms(100);
}
```

### 4. 编译和测试

1. 按 `Ctrl + Shift + B` 编译
2. 运行 "🔥 烧录测试程序" 任务
3. 观察机器狗的新功能表现

## 🎮 实时开发工作流

### 开发循环
```mermaid
graph LR
    A[编写代码] --> B[编译]
    B --> C[烧录]
    C --> D[测试]
    D --> E[调试]
    E --> A
```

### VSCode优势
- **实时语法检查** - 边写边检查错误
- **智能代码补全** - 函数名、变量名自动提示
- **一键编译烧录** - 无需切换工具
- **集成调试** - 可以设置断点调试
- **版本控制** - Git集成
- **插件生态** - 丰富的开发插件

## 🔍 调试功能

### 1. 软件调试
使用 `printf` 调试：
```c
#include <stdio.h>

// 通过串口输出调试信息
printf("Debug: 当前状态 = %d\n", status);
```

### 2. 硬件调试（需要ST-Link）
1. 连接ST-Link调试器
2. 按 `F5` 开始调试
3. 设置断点，单步执行

### 3. 串口监视器
- 运行 "📱 串口监视器" 任务
- 实时查看设备输出
- 发送测试命令

## 📁 项目结构说明

```
my_robot_dog_dev/
├── .vscode/              # VSCode配置
│   ├── tasks.json        # 任务配置
│   ├── launch.json       # 调试配置
│   └── settings.json     # 项目设置
├── src/
│   ├── main.c            # 主程序
│   ├── test_program.c    # 测试程序
│   ├── custom_features.c # 你的新功能 ⭐
│   └── hardware/         # 硬件驱动
├── Makefile              # 编译配置
└── flash_test.ps1        # 烧录脚本
```

## 🎯 功能开发示例

### 示例1：添加新的舞蹈动作

```c
void Custom_MyDance(void) {
    // 第1步：前腿抬起
    Servo_SetAngle(SERVO_FRONT_LEFT, 90);
    Servo_SetAngle(SERVO_FRONT_RIGHT, 90);
    Delay_ms(500);

    // 第2步：身体摇摆
    for(int i = 0; i < 5; i++) {
        PetAction_BodyTilt(30, 300);
        PetAction_BodyTilt(-30, 300);
    }

    // 第3步：恢复站立
    PetAction_Stand(500);
}
```

### 示例2：添加传感器读取

```c
void Custom_EnvironmentMonitor(void) {
    float temperature = ReadTemperature();
    float humidity = ReadHumidity();

    // 显示环境信息
    OLED_Clear();
    OLED_ShowString(0, 0, "Environment", 12);
    sprintf(buffer, "Temp: %.1f°C", temperature);
    OLED_ShowString(0, 16, buffer, 12);
    sprintf(buffer, "Humi: %.1f%%", humidity);
    OLED_ShowString(0, 32, buffer, 12);
    OLED_Refresh_Gram();
}
```

### 示例3：添加蓝牙控制命令

```c
void Custom_HandleBluetoothCommand(char command) {
    switch(command) {
        case 'H':  // Heart beat
            Custom_HeartBeat();
            break;
        case 'R':  // Rainbow dance
            Custom_RainbowDance();
            break;
        case 'P':  // Patrol
            Custom_SmartPatrol();
            break;
        default:
            // 原有命令处理
            break;
    }
}
```

## 🔧 常用开发技巧

### 1. 快速编译测试
```bash
# 创建快速测试脚本
echo "make -f Makefile.test test && .\flash_test.ps1" > quick_test.bat
```

### 2. 代码模板
使用VSCode代码片段功能，快速插入常用代码模板。

### 3. 多文件开发
- 将不同功能分别放在不同的 `.c` 文件中
- 使用头文件 `.h` 声明函数接口
- 在 `Makefile` 中添加新的源文件

### 4. 版本控制
```bash
git add .
git commit -m "添加新的彩虹舞蹈功能"
git push
```

## 🚨 故障排除

### 编译错误
- 检查语法错误（VSCode会高亮显示）
- 确认头文件包含路径
- 验证函数声明和定义

### 烧录失败
- 运行 "🔍 检查设备连接" 任务
- 确保设备进入烧录模式（按住BOOT按钮）
- 检查USB连接和驱动

### 程序无响应
- 运行 "📱 串口监视器" 查看输出
- 检查电源和LED指示
- 验证OLED显示

## 🎉 开发建议

1. **从小开始** - 先修改简单功能，逐步增加复杂度
2. **频繁测试** - 每添加一个功能就测试一次
3. **备份代码** - 使用Git保存工作进度
4. **参考示例** - 学习现有的功能实现
5. **社区分享** - 将你的创意功能分享给其他开发者

---

**🎯 总结：VSCode完全可以替代STM32CubeIDE进行机器狗开发，甚至提供更好的开发体验！现在就开始创造你的专属机器狗功能吧！** 🚀🐕
