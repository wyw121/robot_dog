/**
 * @file custom_actions.c
 * @brief 自定义动作示例
 * @note 在这个文件中添加您的自定义动作
 */

#include "pet_action.h"
#include "face_config.h"
#include "delay.h"

/**
 * @brief 自定义动作：招手
 */
void Action_Custom_Wave(void)
{
    // 定义招手动作序列
    ServoPosition_t wave_sequence[] = {
        // 帧1：准备姿势
        {{90, 90, 90, 45, 90, 90, 90, 90}, 500},
        // 帧2：抬起前腿
        {{90, 90, 90, 90, 90, 90, 90, 90}, 300},
        // 帧3：挥动
        {{90, 90, 90, 45, 90, 90, 90, 90}, 300},
        // 帧4：再次挥动
        {{90, 90, 90, 90, 90, 90, 90, 90}, 300},
        // 帧5：放下
        {{90, 90, 90, 45, 90, 90, 90, 90}, 500}};

    // 显示开心表情
    Face_Happy();

    // 执行动作序列
    for (int i = 0; i < 5; i++)
    {
        Servo_SetAllAngles(&wave_sequence[i]);
    }

    // 回到待机姿势
    ServoPosition_t idle_position = {{90, 90, 90, 90, 90, 90, 90, 90}, 500};
    Servo_SetAllAngles(&idle_position);
}

/**
 * @brief 自定义动作：表演翻滚
 */
void Action_Custom_Roll(void)
{
    Face_Excited();

    // 翻滚动作序列
    ServoPosition_t roll_sequence[] = {
        // 蹲下准备
        {{90, 90, 45, 45, 135, 135, 90, 90}, 800},
        // 向一侧倾斜
        {{90, 90, 0, 90, 90, 180, 90, 90}, 600},
        // 翻滚
        {{90, 90, 180, 0, 180, 0, 90, 90}, 400},
        // 完成翻滚
        {{90, 90, 90, 90, 90, 90, 90, 90}, 800}};

    for (int i = 0; i < 4; i++)
    {
        Servo_SetAllAngles(&roll_sequence[i]);
    }

    Face_Happy();
}

/**
 * @brief 自定义动作：巡逻模式
 */
void Action_Custom_Patrol(void)
{
    static uint8_t patrol_step = 0;

    switch (patrol_step)
    {
    case 0:
        // 向前走几步
        Action_Walk_Forward();
        patrol_step = 1;
        break;

    case 1:
        // 左转
        Action_Turn_Left();
        patrol_step = 2;
        break;

    case 2:
        // 继续前进
        Action_Walk_Forward();
        patrol_step = 3;
        break;

    case 3:
        // 右转
        Action_Turn_Right();
        patrol_step = 0; // 循环
        break;
    }

    Face_Thinking(); // 显示思考表情
}

/**
 * @brief 自定义动作：互动游戏
 */
void Action_Custom_PlayGame(void)
{
    // 游戏序列：摇头-点头-转圈

    // 摇头
    Face_Wink();
    Action_Shake_Head();
    Delay_ms(500);

    // 点头 (头部上下运动)
    for (int i = 0; i < 3; i++)
    {
        Servo_SetAngle(SERVO_HEAD_PITCH, 60);
        Delay_ms(300);
        Servo_SetAngle(SERVO_HEAD_PITCH, 120);
        Delay_ms(300);
    }
    Servo_SetAngle(SERVO_HEAD_PITCH, 90); // 复位

    // 转圈
    Face_Excited();
    for (int i = 0; i < 2; i++)
    {
        Action_Turn_Left();
        Delay_ms(200);
    }

    Face_Love(); // 结束时显示爱心
}

/**
 * @brief 自定义动作：睡眠模式
 */
void Action_Custom_Sleep(void)
{
    // 渐变到睡眠姿势
    ServoPosition_t sleep_position = {{90, 60, 45, 45, 135, 135, 45, 90}, 2000};
    Servo_SetAllAngles(&sleep_position);

    // 显示睡眠表情
    Face_Sleepy();

    // 模拟呼吸效果 (尾巴轻微摆动)
    for (int i = 0; i < 10; i++)
    {
        Servo_SetAngle(SERVO_TAIL, 80);
        Delay_ms(1000);
        Servo_SetAngle(SERVO_TAIL, 100);
        Delay_ms(1000);
    }
}

/**
 * @brief 自定义表情：心跳效果
 */
void Face_Custom_Heartbeat(void)
{
    for (int i = 0; i < 3; i++)
    {
        Face_Love();
        Delay_ms(200);
        Face_Neutral();
        Delay_ms(200);
    }
}
