/**
 * @file custom_features_simple.c
 * @brief 机器人小狗自定义功能 - 简化版演示
 * @author GitHub Copilot
 * @date 2025-07-25
 */

#include <stdint.h>

// 基本GPIO定义 (复用main_simple.c的定义)
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

// RCC时钟使能位
#define RCC_APB2ENR_IOPAEN (1UL << 2)
#define RCC_APB2ENR_IOPBEN (1UL << 3)
#define RCC_APB2ENR_IOPCEN (1UL << 4)

// 延时函数声明
void delay_ms(uint32_t ms);

/**
 * @brief SystemInit函数 - 启动文件要求的系统初始化
 */
void SystemInit(void)
{
    // 启动文件调用的空系统初始化函数
    // 具体初始化在system_init()中进行
}

/**
 * @brief 初始化扩展GPIO
 */
void features_gpio_init(void)
{
    // 使能GPIOA和GPIOB时钟
    RCC->APB2ENR |= RCC_APB2ENR_IOPAEN | RCC_APB2ENR_IOPBEN;

    // 配置PA0-PA3为推挽输出 (模拟舵机控制引脚)
    GPIOA->CRL &= ~(0xFFFF); // 清除PA0-PA3配置
    GPIOA->CRL |= 0x1111;    // 配置为推挽输出

    // 配置PB0-PB1为推挽输出 (模拟额外LED)
    GPIOB->CRL &= ~(0xFF); // 清除PB0-PB1配置
    GPIOB->CRL |= 0x11;    // 配置为推挽输出
}

/**
 * @brief 🎨 功能1: 彩虹呼吸灯
 * @description 模拟RGB LED的彩虹色变化效果
 */
void robot_rainbow_breathing(void)
{
    features_gpio_init();

    // 彩虹色序列 (用不同引脚组合模拟RGB)
    uint8_t rainbow_patterns[6][3] = {
        {1, 0, 0}, // 红
        {1, 1, 0}, // 黄
        {0, 1, 0}, // 绿
        {0, 1, 1}, // 青
        {0, 0, 1}, // 蓝
        {1, 0, 1}  // 紫
    };

    for (int cycle = 0; cycle < 2; cycle++)
    {
        for (int color = 0; color < 6; color++)
        {
            // 渐亮
            for (int brightness = 0; brightness < 10; brightness++)
            {
                // 设置"RGB"输出
                if (rainbow_patterns[color][0])
                    GPIOA->BRR = (1 << 0); // R
                else
                    GPIOA->BSRR = (1 << 0);

                if (rainbow_patterns[color][1])
                    GPIOA->BRR = (1 << 1); // G
                else
                    GPIOA->BSRR = (1 << 1);

                if (rainbow_patterns[color][2])
                    GPIOA->BRR = (1 << 2); // B
                else
                    GPIOA->BSRR = (1 << 2);

                delay_ms(50);

                // PWM模拟 - 关闭一段时间模拟变暗
                GPIOA->BSRR = (1 << 0) | (1 << 1) | (1 << 2);
                delay_ms(10 - brightness);
            }

            // 渐暗
            for (int brightness = 10; brightness > 0; brightness--)
            {
                if (rainbow_patterns[color][0])
                    GPIOA->BRR = (1 << 0);
                else
                    GPIOA->BSRR = (1 << 0);

                if (rainbow_patterns[color][1])
                    GPIOA->BRR = (1 << 1);
                else
                    GPIOA->BSRR = (1 << 1);

                if (rainbow_patterns[color][2])
                    GPIOA->BRR = (1 << 2);
                else
                    GPIOA->BSRR = (1 << 2);

                delay_ms(50);
                GPIOA->BSRR = (1 << 0) | (1 << 1) | (1 << 2);
                delay_ms(10 - brightness);
            }
        }
    }
}

/**
 * @brief 🐕 功能2: 机器狗心情表达
 * @description 通过LED模式表达不同心情
 */
void robot_emotion_display(void)
{
    features_gpio_init();

    // 开心模式 - 快速闪烁
    for (int i = 0; i < 10; i++)
    {
        GPIOC->BRR = (1 << 13); // 板载LED
        GPIOB->BRR = (1 << 0);  // 扩展LED1
        delay_ms(100);
        GPIOC->BSRR = (1 << 13);
        GPIOB->BSRR = (1 << 0);
        delay_ms(100);
    }

    delay_ms(500);

    // 困倦模式 - 慢速渐变
    for (int cycle = 0; cycle < 3; cycle++)
    {
        // 渐亮
        for (int i = 0; i < 20; i++)
        {
            GPIOC->BRR = (1 << 13);
            delay_ms(i * 10);
            GPIOC->BSRR = (1 << 13);
            delay_ms(200 - i * 10);
        }
        // 渐暗
        for (int i = 20; i > 0; i--)
        {
            GPIOC->BRR = (1 << 13);
            delay_ms(i * 10);
            GPIOC->BSRR = (1 << 13);
            delay_ms(200 - i * 10);
        }
    }

    delay_ms(500);

    // 警觉模式 - 双闪
    for (int i = 0; i < 5; i++)
    {
        GPIOC->BRR = (1 << 13);
        GPIOA->BRR = (1 << 3);
        delay_ms(150);
        GPIOC->BSRR = (1 << 13);
        GPIOA->BSRR = (1 << 3);
        delay_ms(150);
        GPIOC->BRR = (1 << 13);
        GPIOA->BRR = (1 << 3);
        delay_ms(150);
        GPIOC->BSRR = (1 << 13);
        GPIOA->BSRR = (1 << 3);
        delay_ms(400);
    }
}

/**
 * @brief 🎵 功能3: 节拍模式
 * @description 按照音乐节拍闪烁LED
 */
void robot_beat_mode(void)
{
    features_gpio_init();

    // 模拟音乐节拍 4/4拍
    uint16_t beat_pattern[16] = {
        400, 200, 300, 200, // 强 弱 中强 弱
        400, 200, 300, 200, // 强 弱 中强 弱
        400, 100, 100, 200, // 强 弱弱 中强
        300, 300, 200, 200  // 中强 中强 弱 弱
    };

    for (int round = 0; round < 2; round++)
    {
        for (int beat = 0; beat < 16; beat++)
        {
            // 根据节拍强度选择LED组合
            if (beat_pattern[beat] >= 400)
            {
                // 强拍 - 所有LED
                GPIOC->BRR = (1 << 13);
                GPIOA->BRR = (1 << 0) | (1 << 1);
                GPIOB->BRR = (1 << 0);
            }
            else if (beat_pattern[beat] >= 300)
            {
                // 中强拍 - 部分LED
                GPIOC->BRR = (1 << 13);
                GPIOA->BRR = (1 << 0);
            }
            else
            {
                // 弱拍 - 单个LED
                GPIOC->BRR = (1 << 13);
            }

            delay_ms(beat_pattern[beat] / 2);

            // 关闭所有LED
            GPIOC->BSRR = (1 << 13);
            GPIOA->BSRR = (1 << 0) | (1 << 1);
            GPIOB->BSRR = (1 << 0);

            delay_ms(beat_pattern[beat] / 2);
        }
        delay_ms(500); // 间歇
    }
}

/**
 * @brief 🚶 功能4: 步态模拟
 * @description 模拟四足机器人的步态
 */
void robot_gait_simulation(void)
{
    features_gpio_init();

    // 模拟四条腿 (PA0-PA3)
    // 步态序列：三足支撑步态
    uint8_t gait_sequence[8][4] = {
        {1, 1, 1, 0}, // 左后腿抬起
        {1, 1, 0, 0}, // 左后腿落下，右前腿抬起
        {1, 0, 0, 1}, // 右前腿落下，左前腿抬起
        {0, 0, 1, 1}, // 左前腿落下，右后腿抬起
        {0, 1, 1, 1}, // 右后腿落下，左后腿抬起
        {1, 1, 1, 0}, // 继续循环...
        {1, 1, 0, 0},
        {1, 0, 0, 1}};

    // 执行步态演示
    for (int step_cycle = 0; step_cycle < 3; step_cycle++)
    {
        for (int step = 0; step < 8; step++)
        {
            // 设置四条腿的状态 (1=支撑/LED灭, 0=抬起/LED亮)
            for (int leg = 0; leg < 4; leg++)
            {
                if (gait_sequence[step][leg])
                {
                    GPIOA->BSRR = (1 << leg); // 支撑状态 - LED灭
                }
                else
                {
                    GPIOA->BRR = (1 << leg); // 抬起状态 - LED亮
                }
            }

            // 同时控制板载LED表示运动状态
            if (step % 2 == 0)
            {
                GPIOC->BRR = (1 << 13); // 偶数步点亮
            }
            else
            {
                GPIOC->BSRR = (1 << 13); // 奇数步熄灭
            }

            delay_ms(300); // 步态周期
        }
        delay_ms(1000); // 步行间歇
    }

    // 结束时熄灭所有LED
    GPIOA->BSRR = (1 << 0) | (1 << 1) | (1 << 2) | (1 << 3);
    GPIOC->BSRR = (1 << 13);
}

/**
 * @brief 🎮 功能演示入口函数
 * @description 依次演示所有功能
 */
void demo_all_features(void)
{
    // 演示开始提示
    for (int i = 0; i < 3; i++)
    {
        GPIOC->BRR = (1 << 13);
        delay_ms(200);
        GPIOC->BSRR = (1 << 13);
        delay_ms(200);
    }
    delay_ms(1000);

    // 1. 彩虹呼吸灯
    robot_rainbow_breathing();
    delay_ms(1000);

    // 2. 心情表达
    robot_emotion_display();
    delay_ms(1000);

    // 3. 节拍模式
    robot_beat_mode();
    delay_ms(1000);

    // 4. 步态模拟
    robot_gait_simulation();
    delay_ms(2000);
}
