# 开发指南

## 环境配置

### 必需工具
1. **Keil MDK-ARM** 或 **GCC工具链**
2. **ST-Link调试器**
3. **STM32CubeMX** (可选，用于配置生成)
4. **Serial Monitor** (蓝牙调试)

### VS Code配置
推荐安装以下扩展:
- C/C++ Extension Pack
- Cortex-Debug
- STM32 VS Code Extension
- PlatformIO (可选)

## 快速开始

### 1. 硬件连接
```
STM32F103C8 引脚分配:
PA0-PA7  -> 舵机PWM输出
PB6,PB7  -> I2C (OLED)
PA9,PA10 -> UART (蓝牙)
PC13     -> LED指示灯
```

### 2. 编译项目
```bash
# 使用Makefile
make all

# 或使用Keil
# 打开Project.uvprojx文件
```

### 3. 烧录程序
```bash
# 使用ST-Link
make flash

# 或使用ST-Link Utility
```

### 4. 测试功能
1. 连接蓝牙模块
2. 发送控制命令
3. 观察动作执行
4. 检查OLED显示

## 自定义开发

### 添加新动作
1. 在 `pet_action.h` 中添加动作枚举
2. 在 `pet_action.c` 中实现动作函数
3. 添加到动作处理switch语句

### 添加新表情
1. 在 `face_config.h` 中定义表情类型
2. 创建表情数据数组
3. 实现表情切换函数

### 修改蓝牙命令
1. 在 `bluetooth.h` 中定义命令码
2. 在命令处理函数中添加处理逻辑

## 调试技巧

### 串口调试
```c
// 在代码中添加调试输出
printf("Debug: Servo angle = %d\n", angle);
```

### LED指示
```c
// 使用板载LED显示状态
GPIO_SetBits(GPIOC, GPIO_Pin_13);   // LED亮
GPIO_ResetBits(GPIOC, GPIO_Pin_13); // LED灭
```

### OLED显示调试信息
```c
OLED_ShowString(0, 0, "Debug Mode", 16);
OLED_ShowNum(0, 16, value, 3, 16);
OLED_Refresh_Gram();
```

## 常见问题

### Q: 舵机不动作
A: 检查PWM输出引脚配置和占空比计算

### Q: 蓝牙连接失败
A: 检查波特率设置和UART引脚配置

### Q: OLED显示异常
A: 检查I2C时序和地址设置

### Q: 程序运行异常
A: 检查时钟配置和堆栈大小

## 性能优化

### 内存优化
- 使用const修饰只读数据
- 合理使用局部变量
- 避免频繁的动态内存分配

### 实时性优化
- 使用定时器中断处理周期性任务
- 避免在主循环中使用长延时
- 合理设置任务优先级

### 功耗优化
- 使用低功耗模式
- 关闭不用的外设时钟
- 优化PWM频率
