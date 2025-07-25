/**
 * @file delay.h
 * @brief 延时函数头文件
 * @version 1.0
 * @date 2025-07-25
 */

#ifndef DELAY_H
#define DELAY_H

#include "stm32f10x.h"

/* 系统时钟频率 */
#define SYSTEM_CLOCK_FREQ   72000000UL  // 72MHz

/* 函数声明 */
void delay_init(void);
void delay_ms(uint32_t ms);
void delay_us(uint32_t us);
void delay_s(uint32_t s);

#endif /* DELAY_H */
