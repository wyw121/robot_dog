/**
 * @file custom_features.h
 * @brief 自定义功能头文件
 */

#ifndef CUSTOM_FEATURES_H
#define CUSTOM_FEATURES_H

#include "stm32f10x.h"

// 自定义功能函数声明
void Custom_BreathingLight(void);
void Custom_HeartBeat(void);
void Custom_RainbowDance(void);
void Custom_SmartPatrol(void);
void Custom_MusicDance(uint8_t beat_pattern);
void Custom_EmotionExpression(uint8_t emotion);
void Custom_FeatureDemo(void);

// 情感类型定义
#define EMOTION_HAPPY 0
#define EMOTION_SAD 1
#define EMOTION_ANGRY 2
#define EMOTION_SLEEPY 3

// 音乐节拍类型
#define BEAT_STRONG 1
#define BEAT_WEAK 2
#define BEAT_REST 3

#endif // CUSTOM_FEATURES_H
