/**
 * @file servo.c
 * @brief 舵机控制驱动实现
 */

#include "servo.h"
#include "pwm.h"
#include "delay.h"

// 当前舵机角度
static uint8_t current_angles[SERVO_COUNT] = {90, 90, 90, 90, 90, 90, 90, 90};

/**
 * @brief 舵机初始化
 */
void Servo_Init(void)
{
    // 初始化PWM
    PWM_Init();

    // 设置所有舵机到中位
    for (int i = 0; i < SERVO_COUNT; i++)
    {
        Servo_SetAngle((ServoID_t)i, 90);
    }

    Delay_ms(1000); // 等待舵机到位
}

/**
 * @brief 设置单个舵机角度
 * @param servo_id 舵机编号
 * @param angle 目标角度 (0-180)
 */
void Servo_SetAngle(ServoID_t servo_id, uint8_t angle)
{
    if (servo_id >= SERVO_COUNT)
        return;

    // 限制角度范围
    if (angle > SERVO_MAX_ANGLE)
        angle = SERVO_MAX_ANGLE;
    if (angle < SERVO_MIN_ANGLE)
        angle = SERVO_MIN_ANGLE;

    // 计算PWM占空比 (0.5ms-2.5ms对应0-180度)
    uint16_t pulse_width = 500 + (angle * 2000) / 180;

    // 设置PWM
    PWM_SetPulseWidth(servo_id, pulse_width);

    // 更新当前角度
    current_angles[servo_id] = angle;
}

/**
 * @brief 设置所有舵机角度
 * @param position 目标位置结构体
 */
void Servo_SetAllAngles(ServoPosition_t *position)
{
    for (int i = 0; i < SERVO_COUNT; i++)
    {
        Servo_SetAngle((ServoID_t)i, position->angle[i]);
    }

    // 等待执行完成
    if (position->speed > 0)
    {
        Delay_ms(position->speed);
    }
}

/**
 * @brief 获取舵机当前角度
 * @param servo_id 舵机编号
 * @return 当前角度
 */
uint8_t Servo_GetAngle(ServoID_t servo_id)
{
    if (servo_id >= SERVO_COUNT)
        return 0;
    return current_angles[servo_id];
}

/**
 * @brief 停止单个舵机
 * @param servo_id 舵机编号
 */
void Servo_Stop(ServoID_t servo_id)
{
    if (servo_id >= SERVO_COUNT)
        return;
    PWM_Stop(servo_id);
}

/**
 * @brief 停止所有舵机
 */
void Servo_StopAll(void)
{
    for (int i = 0; i < SERVO_COUNT; i++)
    {
        PWM_Stop(i);
    }
}
