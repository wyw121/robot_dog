/**
 * @file test_led.c
 * @brief 自包含的LED测试程序
 */

// 基本类型定义
typedef unsigned int uint32_t;
typedef unsigned char uint8_t;

// STM32F103C8 寄存器定义
#define RCC_BASE 0x40021000
#define GPIOC_BASE 0x40011000

#define RCC_APB2ENR (*(volatile uint32_t *)(RCC_BASE + 0x18))
#define RCC_APB2ENR_IOPCEN (1 << 4)

#define GPIOC_CRH (*(volatile uint32_t *)(GPIOC_BASE + 0x04))
#define GPIOC_BSRR (*(volatile uint32_t *)(GPIOC_BASE + 0x10))
#define GPIOC_BRR (*(volatile uint32_t *)(GPIOC_BASE + 0x14))

/**
 * @brief 系统初始化（空函数，满足启动文件要求）
 */
void SystemInit(void)
{
    // 空函数
}

/**
 * @brief 空函数，满足启动文件要求
 */
void __libc_init_array(void)
{
    // 空函数
}

/**
 * @brief 硬件初始化
 */
void hardware_init(void)
{
    // 使能GPIOC时钟
    RCC_APB2ENR |= RCC_APB2ENR_IOPCEN;

    // 配置PC13为推挽输出
    GPIOC_CRH &= ~(0xF << 20); // 清除PC13配置
    GPIOC_CRH |= (0x1 << 20);  // PC13配置为推挽输出
}

/**
 * @brief 简单延时函数
 */
void delay_ms(uint32_t ms)
{
    volatile uint32_t i, j;
    for (i = 0; i < ms; i++)
    {
        for (j = 0; j < 1000; j++)
        {
            __asm("nop");
        }
    }
}

/**
 * @brief 主函数
 */
int main(void)
{
    uint8_t led_state = 0;

    // 硬件初始化
    hardware_init();

    // 主循环
    while (1)
    {
        if (led_state == 0)
        {
            GPIOC_BRR = (1 << 13); // LED亮 (PC13置低)
            led_state = 1;
        }
        else
        {
            GPIOC_BSRR = (1 << 13); // LED灭 (PC13置高)
            led_state = 0;
        }

        delay_ms(500); // 延时500ms
    }

    return 0;
}
