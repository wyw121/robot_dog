/**
 * @file face_config.h
 * @brief 表情配置头文件
 */

#ifndef __FACE_CONFIG_H
#define __FACE_CONFIG_H

#include "stm32f10x.h"

// 表情类型定义
typedef enum
{
    FACE_HAPPY = 0, // 开心
    FACE_SAD,       // 难过
    FACE_ANGRY,     // 生气
    FACE_SURPRISED, // 惊讶
    FACE_SLEEPY,    // 困倦
    FACE_LOVE,      // 爱心
    FACE_THINKING,  // 思考
    FACE_WINK,      // 眨眼
    FACE_NEUTRAL,   // 中性
    FACE_EXCITED,   // 兴奋
    FACE_CONFUSED,  // 困惑
    FACE_SICK,      // 生病
    FACE_COUNT      // 表情总数
} FaceType_t;

// 眼睛状态
typedef enum
{
    EYE_OPEN = 0,
    EYE_CLOSE,
    EYE_HALF_OPEN,
    EYE_WINK_LEFT,
    EYE_WINK_RIGHT
} EyeState_t;

// 嘴巴状态
typedef enum
{
    MOUTH_NEUTRAL = 0,
    MOUTH_SMILE,
    MOUTH_FROWN,
    MOUTH_OPEN,
    MOUTH_SURPRISE
} MouthState_t;

// 表情结构体
typedef struct
{
    EyeState_t left_eye;
    EyeState_t right_eye;
    MouthState_t mouth;
    uint8_t animation_frames; // 动画帧数
    uint16_t frame_delay;     // 帧延时
} FaceExpression_t;

// 函数声明
void Face_Init(void);
void Face_Update(void);
void Face_SetExpression(FaceType_t face_type);
void Face_SetCustomExpression(FaceExpression_t *expression);
void Face_StartAnimation(FaceType_t face_type);
void Face_StopAnimation(void);

// 预定义表情函数
void Face_Happy(void);
void Face_Sad(void);
void Face_Angry(void);
void Face_Surprised(void);
void Face_Sleepy(void);
void Face_Love(void);
void Face_Thinking(void);
void Face_Wink(void);
void Face_Neutral(void);
void Face_Excited(void);
void Face_Confused(void);
void Face_Sick(void);

// 特殊效果
void Face_Blink(void);
void Face_HeartEyes(void);
void Face_ScrollText(char *text);

#endif /* __FACE_CONFIG_H */
