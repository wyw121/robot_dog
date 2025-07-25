/**
 * @file main_simple.c
 * @brief 机器人小狗简化主程序 - VSCode开发版
 * @author GitHub Copilot
 * @date 2025-07-25
 */

#include <stdint.h>

// 基本寄存器定义
#define PERIPH_BASE 0x40000000UL
#define APB2PERIPH_BASE (PERIPH_BASE + 0x00010000UL)
#define AHBPERIPH_BASE (PERIPH_BASE + 0x00020000UL)

#define GPIOC_BASE (APB2PERIPH_BASE + 0x00001000UL)
#define RCC_BASE (AHBPERIPH_BASE + 0x00009000UL)

// GPIO和RCC结构体
typedef struct
{
    volatile uint32_t CRL;
    volatile uint32_t CRH;
    volatile uint32_t IDR;
    volatile uint32_t ODR;
    volatile uint32_t BSRR;
    volatile uint32_t BRR;
    volatile uint32_t LCKR;
} GPIO_TypeDef;

typedef struct
{
    volatile uint32_t CR;
    volatile uint32_t CFGR;
    volatile uint32_t CIR;
    volatile uint32_t APB2RSTR;
    volatile uint32_t APB1RSTR;
    volatile uint32_t AHBENR;
    volatile uint32_t APB2ENR;
    volatile uint32_t APB1ENR;
    volatile uint32_t BDCR;
    volatile uint32_t CSR;
} RCC_TypeDef;

#define GPIOC ((GPIO_TypeDef *)GPIOC_BASE)
#define RCC ((RCC_TypeDef *)RCC_BASE)

// RCC时钟使能位
#define RCC_APB2ENR_IOPCEN (1UL << 4)

/**
 * @brief 延时函数
 */
void delay_ms(uint32_t ms)
{
    volatile uint32_t i, j;
    for (i = 0; i < ms; i++)
    {
        for (j = 0; j < 8000; j++)
            ;
    }
}

/**
 * @brief 系统初始化
 */
void system_init(void)
{
    // 使能GPIOC时钟
    RCC->APB2ENR |= RCC_APB2ENR_IOPCEN;

    // 配置PC13为推挽输出（板载LED）
    GPIOC->CRH &= ~(0xF << 20); // 清除PC13配置位
    GPIOC->CRH |= (0x1 << 20);  // 配置为推挽输出，10MHz
}

/**
 * @brief LED控制
 */
void led_toggle(void)
{
    static uint8_t state = 0;
    if (state)
    {
        GPIOC->BSRR = (1 << 13); // LED熄灭
        state = 0;
    }
    else
    {
        GPIOC->BRR = (1 << 13); // LED点亮
        state = 1;
    }
}

/**
 * @brief 机器狗动作演示
 */
void robot_dog_demo(void)
{
    // 模拟机器狗基本动作
    for (int i = 0; i < 5; i++)
    {
        led_toggle();
        delay_ms(100); // 快闪表示"坐下"
    }
    delay_ms(500);

    for (int i = 0; i < 3; i++)
    {
        led_toggle();
        delay_ms(300); // 慢闪表示"站立"
    }
    delay_ms(500);
}

/**
 * @brief 主函数
 */
int main(void)
{
    // 系统初始化
    system_init();

    // 启动指示 - 快速闪烁3次
    for (int i = 0; i < 6; i++)
    {
        led_toggle();
        delay_ms(200);
    }

    // 主循环
    while (1)
    {
        // 心跳指示
        led_toggle();
        delay_ms(1000);

        // 执行机器狗演示
        robot_dog_demo();

        // 等待下一轮
        delay_ms(2000);
    }

    return 0;
}
