/**
 * @file main_advanced.c
 * @brief 机器人小狗高级演示程序 - 集成多种功能
 * @author GitHub Copilot
 * @date 2025-07-25
 */

#include <stdint.h>

// 基本寄存器定义
#define PERIPH_BASE 0x40000000UL
#define APB2PERIPH_BASE (PERIPH_BASE + 0x00010000UL)
#define AHBPERIPH_BASE (PERIPH_BASE + 0x00020000UL)

#define GPIOA_BASE (APB2PERIPH_BASE + 0x00000800UL)
#define GPIOB_BASE (APB2PERIPH_BASE + 0x00000C00UL)
#define GPIOC_BASE (APB2PERIPH_BASE + 0x00001000UL)
#define RCC_BASE (AHBPERIPH_BASE + 0x00009000UL)

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

#define GPIOA ((GPIO_TypeDef *)GPIOA_BASE)
#define GPIOB ((GPIO_TypeDef *)GPIOB_BASE)
#define GPIOC ((GPIO_TypeDef *)GPIOC_BASE)
#define RCC ((RCC_TypeDef *)RCC_BASE)

#define RCC_APB2ENR_IOPAEN (1UL << 2)
#define RCC_APB2ENR_IOPBEN (1UL << 3)
#define RCC_APB2ENR_IOPCEN (1UL << 4)

// 外部功能函数声明
void demo_all_features(void);
void robot_rainbow_breathing(void);
void robot_emotion_display(void);
void robot_beat_mode(void);
void robot_gait_simulation(void);

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
    // 使能所有GPIO时钟
    RCC->APB2ENR |= RCC_APB2ENR_IOPAEN | RCC_APB2ENR_IOPBEN | RCC_APB2ENR_IOPCEN;

    // 配置PC13为推挽输出（板载LED）
    GPIOC->CRH &= ~(0xF << 20);
    GPIOC->CRH |= (0x1 << 20);

    // 配置PA0-PA3为推挽输出（舵机/LED控制）
    GPIOA->CRL &= ~(0xFFFF);
    GPIOA->CRL |= 0x1111;

    // 配置PB0-PB1为推挽输出（扩展LED）
    GPIOB->CRL &= ~(0xFF);
    GPIOB->CRL |= 0x11;
}

/**
 * @brief 启动动画
 */
void startup_animation(void)
{
    // 流水灯效果
    uint32_t pins[] = {
        (1 << 13), // PC13
        (1 << 0),  // PA0
        (1 << 1),  // PA1
        (1 << 2),  // PA2
        (1 << 3)   // PA3
    };

    GPIO_TypeDef *ports[] = {
        GPIOC, GPIOA, GPIOA, GPIOA, GPIOA};

    // 正向流水
    for (int round = 0; round < 3; round++)
    {
        for (int i = 0; i < 5; i++)
        {
            ports[i]->BRR = pins[i];
            delay_ms(150);
            ports[i]->BSRR = pins[i];
        }
    }

    // 反向流水
    for (int round = 0; round < 2; round++)
    {
        for (int i = 4; i >= 0; i--)
        {
            ports[i]->BRR = pins[i];
            delay_ms(150);
            ports[i]->BSRR = pins[i];
        }
    }

    // 全部同时闪烁3次
    for (int i = 0; i < 3; i++)
    {
        for (int j = 0; j < 5; j++)
        {
            ports[j]->BRR = pins[j];
        }
        delay_ms(300);
        for (int j = 0; j < 5; j++)
        {
            ports[j]->BSRR = pins[j];
        }
        delay_ms(300);
    }
}

/**
 * @brief 模式选择指示
 */
void mode_indicator(uint8_t mode)
{
    // 通过LED闪烁次数指示当前模式
    for (int i = 0; i < mode; i++)
    {
        GPIOC->BRR = (1 << 13);
        delay_ms(200);
        GPIOC->BSRR = (1 << 13);
        delay_ms(200);
    }
    delay_ms(1000);
}

/**
 * @brief 主函数
 */
int main(void)
{
    // 系统初始化
    system_init();

    // 启动动画
    startup_animation();
    delay_ms(2000);

    uint8_t current_mode = 1;

    // 主循环 - 循环演示不同功能
    while (1)
    {
        // 显示当前模式
        mode_indicator(current_mode);

        switch (current_mode)
        {
        case 1:
            // 模式1: 彩虹呼吸灯
            robot_rainbow_breathing();
            break;

        case 2:
            // 模式2: 心情表达
            robot_emotion_display();
            break;

        case 3:
            // 模式3: 节拍模式
            robot_beat_mode();
            break;

        case 4:
            // 模式4: 步态模拟
            robot_gait_simulation();
            break;

        case 5:
            // 模式5: 全功能演示
            demo_all_features();
            break;

        default:
            current_mode = 0;
            break;
        }

        // 切换到下一个模式
        current_mode++;
        if (current_mode > 5)
        {
            current_mode = 1;

            // 完成一轮演示后的间歇动画
            for (int i = 0; i < 5; i++)
            {
                GPIOC->BRR = (1 << 13);
                GPIOA->BRR = (1 << 0) | (1 << 1) | (1 << 2) | (1 << 3);
                delay_ms(100);
                GPIOC->BSRR = (1 << 13);
                GPIOA->BSRR = (1 << 0) | (1 << 1) | (1 << 2) | (1 << 3);
                delay_ms(100);
            }
            delay_ms(3000); // 长间歇
        }
        else
        {
            delay_ms(1500); // 短间歇
        }
    }

    return 0;
}
