/**
 * @file stm32f10x.h
 * @brief STM32F10x系列微控制器头文件 - 机器人小狗专用简化版
 * @version 1.0
 * @date 2025-07-25
 */

#ifndef STM32F10X_H
#define STM32F10X_H

#ifdef __cplusplus
extern "C"
{
#endif

/* 包含标准C库 */
#include <stdint.h>
#include <stdbool.h>

/* STM32F103C8T6 特定定义 */
#define STM32F103xB

    /* 基本数据类型 */
    typedef uint32_t u32;
    typedef uint16_t u16;
    typedef uint8_t u8;

    typedef int32_t s32;
    typedef int16_t s16;
    typedef int8_t s8;

    typedef volatile uint32_t vu32;
    typedef volatile uint16_t vu16;
    typedef volatile uint8_t vu8;

/* 常用宏定义 */
#define SET_BIT(REG, BIT) ((REG) |= (BIT))
#define CLEAR_BIT(REG, BIT) ((REG) &= ~(BIT))
#define READ_BIT(REG, BIT) ((REG) & (BIT))
#define CLEAR_REG(REG) ((REG) = (0x0))
#define WRITE_REG(REG, VAL) ((REG) = (VAL))
#define READ_REG(REG) ((REG))
#define MODIFY_REG(REG, CLEARMASK, SETMASK) WRITE_REG((REG), (((READ_REG(REG)) & (~(CLEARMASK))) | (SETMASK)))

/* 基地址定义 */
#define PERIPH_BASE 0x40000000UL
#define APB1PERIPH_BASE PERIPH_BASE
#define APB2PERIPH_BASE (PERIPH_BASE + 0x00010000UL)
#define AHBPERIPH_BASE (PERIPH_BASE + 0x00020000UL)

/* GPIO基地址 */
#define GPIOA_BASE (APB2PERIPH_BASE + 0x00000800UL)
#define GPIOB_BASE (APB2PERIPH_BASE + 0x00000C00UL)
#define GPIOC_BASE (APB2PERIPH_BASE + 0x00001000UL)

/* TIM基地址 */
#define TIM1_BASE (APB2PERIPH_BASE + 0x00002C00UL)
#define TIM2_BASE (APB1PERIPH_BASE + 0x00000000UL)
#define TIM3_BASE (APB1PERIPH_BASE + 0x00000400UL)
#define TIM4_BASE (APB1PERIPH_BASE + 0x00000800UL)

/* USART基地址 */
#define USART1_BASE (APB2PERIPH_BASE + 0x00003800UL)
#define USART2_BASE (APB1PERIPH_BASE + 0x00004400UL)

/* RCC基地址 */
#define RCC_BASE (AHBPERIPH_BASE + 0x00009000UL)

    /* GPIO结构体定义 */
    typedef struct
    {
        volatile uint32_t CRL;  /*!< GPIO port configuration register low,      Address offset: 0x00 */
        volatile uint32_t CRH;  /*!< GPIO port configuration register high,     Address offset: 0x04 */
        volatile uint32_t IDR;  /*!< GPIO port input data register,             Address offset: 0x08 */
        volatile uint32_t ODR;  /*!< GPIO port output data register,            Address offset: 0x0C */
        volatile uint32_t BSRR; /*!< GPIO port bit set/reset register,          Address offset: 0x10 */
        volatile uint32_t BRR;  /*!< GPIO port bit reset register,              Address offset: 0x14 */
        volatile uint32_t LCKR; /*!< GPIO port configuration lock register,     Address offset: 0x18 */
    } GPIO_TypeDef;

    /* RCC结构体定义 */
    typedef struct
    {
        volatile uint32_t CR;       /*!< RCC clock control register,                                  Address offset: 0x00 */
        volatile uint32_t CFGR;     /*!< RCC clock configuration register,                            Address offset: 0x04 */
        volatile uint32_t CIR;      /*!< RCC clock interrupt register,                                Address offset: 0x08 */
        volatile uint32_t APB2RSTR; /*!< RCC APB2 peripheral reset register,                          Address offset: 0x0C */
        volatile uint32_t APB1RSTR; /*!< RCC APB1 peripheral reset register,                          Address offset: 0x10 */
        volatile uint32_t AHBENR;   /*!< RCC AHB peripheral clock register,                           Address offset: 0x14 */
        volatile uint32_t APB2ENR;  /*!< RCC APB2 peripheral clock enable register,                   Address offset: 0x18 */
        volatile uint32_t APB1ENR;  /*!< RCC APB1 peripheral clock enable register,                   Address offset: 0x1C */
        volatile uint32_t BDCR;     /*!< RCC Backup domain control register,                          Address offset: 0x20 */
        volatile uint32_t CSR;      /*!< RCC clock control & status register,                         Address offset: 0x24 */
    } RCC_TypeDef;

/* 外设指针定义 */
#define GPIOA ((GPIO_TypeDef *)GPIOA_BASE)
#define GPIOB ((GPIO_TypeDef *)GPIOB_BASE)
#define GPIOC ((GPIO_TypeDef *)GPIOC_BASE)
#define RCC ((RCC_TypeDef *)RCC_BASE)

/* RCC时钟使能位定义 */
#define RCC_APB2ENR_IOPAEN (1UL << 2) /*!< I/O port A clock enable */
#define RCC_APB2ENR_IOPBEN (1UL << 3) /*!< I/O port B clock enable */
#define RCC_APB2ENR_IOPCEN (1UL << 4) /*!< I/O port C clock enable */

/* GPIO模式定义 */
#define GPIO_MODE_INPUT 0x00
#define GPIO_MODE_OUTPUT 0x01
#define GPIO_MODE_AF 0x02
#define GPIO_MODE_ANALOG 0x03

    /* 系统函数声明 */
    void SystemInit(void);
    void SystemClock_Config(void);
    void delay_ms(uint32_t ms);
    void delay_us(uint32_t us);

    /* GPIO函数声明 */
    void GPIO_Init(GPIO_TypeDef *GPIOx, uint32_t pin, uint32_t mode);
    void GPIO_SetBits(GPIO_TypeDef *GPIOx, uint16_t GPIO_Pin);
    void GPIO_ResetBits(GPIO_TypeDef *GPIOx, uint16_t GPIO_Pin);
    uint8_t GPIO_ReadInputDataBit(GPIO_TypeDef *GPIOx, uint16_t GPIO_Pin);

#ifdef __cplusplus
}
#endif

#endif /* STM32F10X_H */
