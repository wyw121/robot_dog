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
    GPIOC->CRH &= ~(0xF << 20); // 清除PC13配置
    GPIOC->CRH |= (0x1 << 20);  // PC13配置为推挽输出
}

/**
 * @brief 简单延时函数
 */
void delay_ms(uint32_t ms)
{
    volatile uint32_t i, j;
    for (i = 0; i < ms; i++)
    {
        for (j = 0; j < 8000; j++)
            ; // 大约1ms延时
    }
}

/**
 * @brief LED控制函数
 */
void LED_Toggle(void)
{
    static uint8_t led_state = 0;
    if (led_state)
    {
        GPIOC->BSRR = (1 << 13); // LED熄灭
        led_state = 0;
    }
    else
    {
        GPIOC->BRR = (1 << 13); // LED点亮
        led_state = 1;
    }
}

/**
 * @brief 系统初始化函数
 */
void SystemInit_All(void)
{
    // 系统初始化
    SystemInit_Custom();

    // 初始化延时函数
    delay_ms(10);

    // 显示启动画面（如果有OLED的话）
    // OLED_ShowString(0, 0, "Robot Dog V9", 16);
    // OLED_ShowString(0, 16, "Initializing...", 16);
    // OLED_Refresh_Gram();

    delay_ms(2000);
}

/**
 * @brief 主函数
 */
int main(void)
{
    // 系统初始化
    SystemInit_All();

    // 主循环
    while (1)
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

/**
 * @brief 错误处理函数
 */
void Error_Handler(void)
{
    // 错误指示
    while (1)
    {
        LED_Toggle();
        delay_ms(100);
    }
}
