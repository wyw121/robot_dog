/**
 * @file main_simple_advanced.c
 * @brief 简化版高级功能 - 基于成功的LED测试程序
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
 * @brief 硬件初始化 - 仅配置PC13 LED
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
 * @brief 简单延时函数 - 与成功的LED测试相同
 */
void delay_ms(uint32_t ms)
{
    volatile uint32_t i, j;
    for (i = 0; i < ms; i++)
    {
        for (j = 0; j < 1000; j++)
        { // 使用与LED测试相同的1000
            __asm("nop");
        }
    }
}

/**
 * @brief LED开启
 */
void led_on(void)
{
    GPIOC_BRR = (1 << 13); // PC13拉低，LED点亮
}

/**
 * @brief LED关闭
 */
void led_off(void)
{
    GPIOC_BSRR = (1 << 13); // PC13拉高，LED关闭
}

/**
 * @brief 模式指示器 - 通过LED闪烁次数表示模式
 */
void mode_indicator(uint8_t mode)
{
    for (int i = 0; i < mode; i++)
    {
        led_on();
        delay_ms(200);
        led_off();
        delay_ms(200);
    }
    delay_ms(800); // 模式指示后的间隔
}

/**
 * @brief 功能1: 快速闪烁 (彩虹呼吸灯模拟)
 */
void rainbow_breathing_demo(void)
{
    // 快速闪烁模拟彩虹变化
    for (int cycle = 0; cycle < 10; cycle++)
    {
        for (int i = 0; i < 5; i++)
        {
            led_on();
            delay_ms(50 + i * 20); // 渐变延时
            led_off();
            delay_ms(50 + i * 20);
        }
        for (int i = 4; i >= 0; i--)
        {
            led_on();
            delay_ms(50 + i * 20); // 渐变延时
            led_off();
            delay_ms(50 + i * 20);
        }
    }
}

/**
 * @brief 功能2: 心情表达 (不同节奏闪烁)
 */
void emotion_display_demo(void)
{
    // 开心模式：快速三连闪
    for (int i = 0; i < 3; i++)
    {
        for (int j = 0; j < 3; j++)
        {
            led_on();
            delay_ms(100);
            led_off();
            delay_ms(100);
        }
        delay_ms(500);
    }

    // 平静模式：慢呼吸
    for (int i = 0; i < 3; i++)
    {
        led_on();
        delay_ms(800);
        led_off();
        delay_ms(800);
    }
}

/**
 * @brief 功能3: 节拍模式
 */
void beat_mode_demo(void)
{
    // 模拟音乐节拍
    for (int i = 0; i < 8; i++)
    {
        led_on();
        delay_ms(150);
        led_off();
        delay_ms(150);
        led_on();
        delay_ms(150);
        led_off();
        delay_ms(450); // 长间隔
    }
}

/**
 * @brief 功能4: 步态模拟
 */
void gait_simulation_demo(void)
{
    // 模拟四足步态：1-2-1-2节奏
    for (int step = 0; step < 6; step++)
    {
        // 左前+右后
        led_on();
        delay_ms(300);
        led_off();
        delay_ms(200);

        // 右前+左后
        led_on();
        delay_ms(300);
        led_off();
        delay_ms(200);
    }
}

/**
 * @brief 功能5: 全功能演示
 */
void demo_all_features(void)
{
    // 启动序列
    for (int i = 0; i < 5; i++)
    {
        led_on();
        delay_ms(100);
        led_off();
        delay_ms(100);
    }
    delay_ms(500);

    // 快速展示所有模式的片段
    // 彩虹片段
    for (int i = 0; i < 3; i++)
    {
        led_on();
        delay_ms(100);
        led_off();
        delay_ms(150);
    }

    delay_ms(300);

    // 心情片段
    led_on();
    delay_ms(500);
    led_off();
    delay_ms(300);

    // 节拍片段
    for (int i = 0; i < 4; i++)
    {
        led_on();
        delay_ms(120);
        led_off();
        delay_ms(120);
    }
}

/**
 * @brief 主函数
 */
int main(void)
{
    // 硬件初始化
    hardware_init();

    // 启动指示：长闪3次
    for (int i = 0; i < 3; i++)
    {
        led_on();
        delay_ms(500);
        led_off();
        delay_ms(500);
    }

    delay_ms(1000); // 启动后等待

    uint8_t current_mode = 1;

    // 主循环 - 循环演示不同功能
    while (1)
    {
        // 显示当前模式编号
        mode_indicator(current_mode);

        switch (current_mode)
        {
        case 1:
            // 模式1: 彩虹呼吸灯模拟
            rainbow_breathing_demo();
            break;

        case 2:
            // 模式2: 心情表达
            emotion_display_demo();
            break;

        case 3:
            // 模式3: 节拍模式
            beat_mode_demo();
            break;

        case 4:
            // 模式4: 步态模拟
            gait_simulation_demo();
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

            // 完成一轮演示后：快速5次闪烁表示重新开始
            for (int i = 0; i < 5; i++)
            {
                led_on();
                delay_ms(150);
                led_off();
                delay_ms(150);
            }
            delay_ms(2000); // 长间歇
        }
        else
        {
            delay_ms(1000); // 短间歇
        }
    }

    return 0;
}
