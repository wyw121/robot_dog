/**
 * @file servo.h
 * @brief 舵机控制驱动头文件
 */

#ifndef __SERVO_H
#define __SERVO_H

#include "stm32f10x.h"

// 舵机数量定义
#define SERVO_COUNT 8

// 舵机角度范围
#define SERVO_MIN_ANGLE 0
#define SERVO_MAX_ANGLE 180

// 舵机编号定义
typedef enum
{
    SERVO_HEAD_YAW = 0, // 头部左右
    SERVO_HEAD_PITCH,   // 头部上下
    SERVO_FRONT_LEFT,   // 前左腿
    SERVO_FRONT_RIGHT,  // 前右腿
    SERVO_REAR_LEFT,    // 后左腿
    SERVO_REAR_RIGHT,   // 后右腿
    SERVO_TAIL,         // 尾巴
    SERVO_SPARE         // 备用
} ServoID_t;

// 舵机位置结构体
typedef struct
{
    uint8_t angle[SERVO_COUNT];
    uint16_t speed; // 执行速度 (ms)
} ServoPosition_t;

// 函数声明
void Servo_Init(void);
void Servo_SetAngle(ServoID_t servo_id, uint8_t angle);
void Servo_SetAllAngles(ServoPosition_t *position);
uint8_t Servo_GetAngle(ServoID_t servo_id);
void Servo_Stop(ServoID_t servo_id);
void Servo_StopAll(void);

#endif /* __SERVO_H */
