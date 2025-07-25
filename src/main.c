/**
 * @file main.c
 * @brief 第九代机器人小狗主程序 - 简化版
 * @author Your Name
 * @date 2025-07-25
 */

#include "stm32f10x.h"
#include "custom_features.h"

/**
 * @brief 系统初始化
 */
void SystemInit_Custom(void)
{
    // 使能GPIOA、GPIOB、GPIOC时钟
    RCC->APB2ENR |= RCC_APB2ENR_IOPAEN | RCC_APB2ENR_IOPBEN | RCC_APB2ENR_IOPCEN;

    // 配置LED指示灯 (PC13)
    GPIOC->CRH &= ~(0xF << 20);  // 清除PC13配置
    GPIOC->CRH |= (0x1 << 20);   // PC13配置为推挽输出
}

/**
 * @brief 简单延时函数
 */
void delay_ms(uint32_t ms)
{
    volatile uint32_t i, j;
    for(i = 0; i < ms; i++)
    {
        for(j = 0; j < 8000; j++);  // 大约1ms延时
    }
}

/**
 * @brief LED控制函数
 */
void LED_Toggle(void)
{
    static uint8_t led_state = 0;
    if(led_state)
    {
        GPIOC->BSRR = (1 << 13);  // LED熄灭
        led_state = 0;
    }
    else
    {
        GPIOC->BRR = (1 << 13);   // LED点亮
        led_state = 1;
    }
}

/**
 * @brief 主函数
 */
int main(void)
{
    // 系统初始化
    SystemInit_Custom();

    // 主循环
    while(1)
    {
        // LED闪烁表示系统运行
        LED_Toggle();
        delay_ms(500);

        // 执行自定义功能
        Custom_BreathingLight();
        delay_ms(1000);

        Custom_HeartBeat();
        delay_ms(1000);

        // 其他功能可以在这里添加
    }

    return 0;
}
{
    // 初始化延时函数
    Delay_Init();

    // 初始化OLED显示
    OLED_Init();

    // 初始化舵机
    Servo_Init();

    // 初始化蓝牙
    BlueTooth_Init();

    // 显示启动画面
    OLED_ShowString(0, 0, "Robot Dog V9", 16);
    OLED_ShowString(0, 16, "Initializing...", 16);
    OLED_Refresh_Gram();

    Delay_ms(2000);
    OLED_Clear();
}

/**
 * @brief 主函数
 */
int main(void)
{
    // 系统初始化
    SystemInit_Custom();

    // 显示就绪状态
    Face_Happy(); // 显示开心表情

    while (1)
    {
        // 处理蓝牙命令
        BlueTooth_Process();

        // 执行行为逻辑
        PetAction_Process();

        // 更新显示
        Face_Update();

        Delay_ms(10); // 主循环延时
    }
}

/**
 * @brief 错误处理函数
 */
void Error_Handler(void)
{
    OLED_Clear();
    OLED_ShowString(0, 0, "ERROR!", 16);
    OLED_Refresh_Gram();

    while (1)
    {
        // 错误指示
        Delay_ms(500);
    }
}
