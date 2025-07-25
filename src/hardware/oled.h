/**
 * @file oled.h
 * @brief OLED显示屏控制头文件
 * @version 1.0
 * @date 2025-07-25
 */

#ifndef OLED_H
#define OLED_H

#include "stm32f10x.h"

/* OLED连接引脚定义 */
#define OLED_SDA_PORT   GPIOB
#define OLED_SDA_PIN    GPIO_Pin_9
#define OLED_SCL_PORT   GPIOB
#define OLED_SCL_PIN    GPIO_Pin_8

/* OLED显示参数 */
#define OLED_WIDTH      128
#define OLED_HEIGHT     64

/* 函数声明 */
void OLED_Init(void);
void OLED_Clear(void);
void OLED_ShowString(uint8_t x, uint8_t y, char *str);
void OLED_ShowChar(uint8_t x, uint8_t y, char chr);
void OLED_ShowNum(uint8_t x, uint8_t y, uint32_t num, uint8_t len);
void OLED_DrawBMP(uint8_t x0, uint8_t y0, uint8_t x1, uint8_t y1, const uint8_t bmp[]);

#endif /* OLED_H */
