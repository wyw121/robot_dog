/**
 * @file custom_features.c
 * @brief 自定义功能演示 - 在VSCode中开发新功能
 * @description 这个文件展示了如何在VSCode中为机器狗添加新功能
 */

#include "stm32f10x.h"
#include "custom_features.h"

// 简单延时函数声明
void delay_ms(uint32_t ms);

/**
 * @brief 新功能：LED呼吸灯效果
 * @description 让机器狗的LED灯呈现呼吸效果
 */
void Custom_BreathingLight(void)
{
    static uint16_t brightness = 0;
    static int8_t direction = 1;

    // 呼吸灯效果算法
    brightness += direction * 5;

    if (brightness >= 255)
    {
        brightness = 255;
        direction = -1;
    }
    else if (brightness <= 0)
    {
        brightness = 0;
        direction = 1;
    }

    // 这里可以添加PWM控制LED亮度的代码
    // PWM_SetDutyCycle(LED_CHANNEL, brightness);

    Delay_ms(20);
}

/**
 * @brief 新功能：心跳显示
 * @description 在OLED上显示心跳图案
 */
void Custom_HeartBeat(void)
{
    // 心跳图案数据 (简化版)
    const char *heart_frames[] = {
        "  ♥♥   ♥♥  ",
        " ♥♥♥♥ ♥♥♥♥ ",
        "♥♥♥♥♥♥♥♥♥♥♥",
        " ♥♥♥♥♥♥♥♥♥ ",
        "  ♥♥♥♥♥♥♥  ",
        "   ♥♥♥♥♥   ",
        "    ♥♥♥    ",
        "     ♥     "};

    for (int i = 0; i < 8; i++)
    {
        OLED_Clear();
        OLED_ShowString(16, 16, (char *)heart_frames[i], 16);
        OLED_ShowString(32, 32, "I LOVE YOU", 12);
        OLED_Refresh_Gram();
        Delay_ms(200);
    }
}

/**
 * @brief 新功能：彩虹舞蹈
 * @description 机器狗执行彩虹主题的舞蹈动作
 */
void Custom_RainbowDance(void)
{
    // 彩虹舞蹈序列
    for (int cycle = 0; cycle < 3; cycle++)
    {
        // 第一段：波浪运动
        for (int wave = 0; wave < 5; wave++)
        {
            // 身体左右摆动
            PetAction_BodyTilt(45, 500); // 向左倾斜
            Delay_ms(300);
            PetAction_BodyTilt(-45, 500); // 向右倾斜
            Delay_ms(300);
        }

        // 第二段：旋转动作
        for (int spin = 0; spin < 2; spin++)
        {
            PetAction_TurnLeft(360, 1000); // 左转一圈
            Delay_ms(500);
        }

        // 第三段：跳跃动作
        for (int jump = 0; jump < 3; jump++)
        {
            PetAction_Jump(200, 400); // 跳跃
            Delay_ms(600);
        }
    }
}

/**
 * @brief 新功能：智能巡逻
 * @description 带有避障的智能巡逻功能
 */
void Custom_SmartPatrol(void)
{
    static uint8_t patrol_state = 0;
    static uint32_t last_action_time = 0;
    uint32_t current_time = GetTick();

    // 每2秒执行一次巡逻动作
    if (current_time - last_action_time > 2000)
    {
        switch (patrol_state)
        {
        case 0:
            // 前进
            PetAction_WalkForward(500, 800);
            OLED_Clear();
            OLED_ShowString(32, 16, "Patrol", 16);
            OLED_ShowString(24, 32, "Forward", 12);
            OLED_Refresh_Gram();
            break;

        case 1:
            // 检查左侧
            PetAction_TurnLeft(45, 500);
            OLED_Clear();
            OLED_ShowString(32, 16, "Check", 16);
            OLED_ShowString(36, 32, "Left", 12);
            OLED_Refresh_Gram();
            break;

        case 2:
            // 回到中间
            PetAction_TurnRight(45, 500);
            break;

        case 3:
            // 检查右侧
            PetAction_TurnRight(45, 500);
            OLED_Clear();
            OLED_ShowString(32, 16, "Check", 16);
            OLED_ShowString(32, 32, "Right", 12);
            OLED_Refresh_Gram();
            break;

        case 4:
            // 回到中间，继续前进
            PetAction_TurnLeft(45, 500);
            break;
        }

        patrol_state = (patrol_state + 1) % 5;
        last_action_time = current_time;
    }
}

/**
 * @brief 新功能：音乐节拍舞蹈
 * @description 跟随音乐节拍的舞蹈动作
 */
void Custom_MusicDance(uint8_t beat_pattern)
{
    switch (beat_pattern)
    {
    case 1: // 强拍
        PetAction_Jump(150, 300);
        Custom_BreathingLight();
        break;

    case 2: // 弱拍
        PetAction_BodyTilt(30, 200);
        break;

    case 3: // 休止
        PetAction_Sit(500);
        break;

    default:
        PetAction_Stand(300);
        break;
    }
}

/**
 * @brief 新功能：情感表达系统
 * @description 根据不同情绪显示对应的表情和动作
 */
void Custom_EmotionExpression(uint8_t emotion)
{
    switch (emotion)
    {
    case 0: // 开心
        OLED_Clear();
        OLED_ShowString(40, 16, "^_^", 16);
        OLED_ShowString(28, 32, "Happy!", 12);
        OLED_Refresh_Gram();

        // 摇尾巴动作
        for (int i = 0; i < 5; i++)
        {
            PetAction_WagTail(45, 200);
            Delay_ms(100);
        }
        break;

    case 1: // 伤心
        OLED_Clear();
        OLED_ShowString(40, 16, "T_T", 16);
        OLED_ShowString(32, 32, "Sad..", 12);
        OLED_Refresh_Gram();

        // 低头动作
        PetAction_LowerHead(30, 1000);
        break;

    case 2: // 愤怒
        OLED_Clear();
        OLED_ShowString(40, 16, ">_<", 16);
        OLED_ShowString(28, 32, "Angry!", 12);
        OLED_Refresh_Gram();

        // 抖动动作
        for (int i = 0; i < 10; i++)
        {
            PetAction_Shake(100);
            Delay_ms(50);
        }
        break;

    case 3: // 困倦
        OLED_Clear();
        OLED_ShowString(40, 16, "-_-", 16);
        OLED_ShowString(24, 32, "Sleepy..", 12);
        OLED_Refresh_Gram();

        // 趴下休息
        PetAction_LieDown(2000);
        break;
    }
}

/**
 * @brief 新功能演示主函数
 * @description 演示如何在主程序中调用自定义功能
 */
void Custom_FeatureDemo(void)
{
    static uint8_t demo_step = 0;
    static uint32_t last_demo_time = 0;
    uint32_t current_time = GetTick();

    // 每5秒切换一个演示功能
    if (current_time - last_demo_time > 5000)
    {
        switch (demo_step)
        {
        case 0:
            Custom_HeartBeat();
            break;

        case 1:
            Custom_RainbowDance();
            break;

        case 2:
            Custom_EmotionExpression(0); // 开心表情
            break;

        case 3:
            Custom_SmartPatrol();
            break;

        case 4:
            Custom_MusicDance(1); // 强拍舞蹈
            break;
        }

        demo_step = (demo_step + 1) % 5;
        last_demo_time = current_time;
    }

    // 持续的呼吸灯效果
    Custom_BreathingLight();
}
