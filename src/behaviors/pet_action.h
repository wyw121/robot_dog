/**
 * @file pet_action.h
 * @brief 宠物行为控制头文件
 */

#ifndef __PET_ACTION_H
#define __PET_ACTION_H

#include "stm32f10x.h"
#include "servo.h"

// 行为类型定义
typedef enum
{
    ACTION_IDLE = 0,      // 待机
    ACTION_WALK_FORWARD,  // 向前走
    ACTION_WALK_BACKWARD, // 向后走
    ACTION_TURN_LEFT,     // 左转
    ACTION_TURN_RIGHT,    // 右转
    ACTION_SIT,           // 坐下
    ACTION_STAND,         // 站立
    ACTION_SHAKE_HEAD,    // 摇头
    ACTION_WAG_TAIL,      // 摆尾
    ACTION_DANCE,         // 跳舞
    ACTION_GREET,         // 打招呼
    ACTION_SLEEP,         // 睡觉
    ACTION_PATROL,        // 巡逻
    ACTION_AVOID_OBSTACLE // 避障
} ActionType_t;

// 行为状态
typedef enum
{
    ACTION_STATE_STOP = 0,
    ACTION_STATE_RUNNING,
    ACTION_STATE_PAUSE,
    ACTION_STATE_COMPLETE
} ActionState_t;

// 动作序列结构体
typedef struct
{
    ServoPosition_t positions[10]; // 最多10个关键帧
    uint8_t frame_count;           // 帧数
    uint8_t loop_count;            // 循环次数 (0=无限循环)
    uint16_t frame_delay;          // 帧间延时
} ActionSequence_t;

// 函数声明
void PetAction_Init(void);
void PetAction_Process(void);
void PetAction_Start(ActionType_t action);
void PetAction_Stop(void);
void PetAction_Pause(void);
void PetAction_Resume(void);
ActionState_t PetAction_GetState(void);
ActionType_t PetAction_GetCurrent(void);

// 预定义动作
void Action_Walk_Forward(void);
void Action_Walk_Backward(void);
void Action_Turn_Left(void);
void Action_Turn_Right(void);
void Action_Sit(void);
void Action_Stand(void);
void Action_Shake_Head(void);
void Action_Wag_Tail(void);
void Action_Dance(void);
void Action_Greet(void);
void Action_Sleep(void);

// 自定义动作
void PetAction_PlaySequence(ActionSequence_t *sequence);
void PetAction_CreateCustomAction(ActionType_t action_id, ActionSequence_t *sequence);

#endif /* __PET_ACTION_H */
