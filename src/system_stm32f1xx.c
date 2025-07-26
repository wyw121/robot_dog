/**
 ******************************************************************************
 * @file    system_stm32f1xx.c
 * @author  MCD Application Team
 * @brief   CMSIS Cortex-M3 Device Peripheral Access Layer System Source File.
 ******************************************************************************
 */

#include "stm32f10x.h"

/* Clock variables */
uint32_t SystemCoreClock = 72000000;

/**
 * @brief  Setup the microcontroller system
 *         Initialize the Embedded Flash Interface, the PLL and update the
 *         SystemCoreClock variable.
 * @note   This function should be used only after reset.
 * @param  None
 * @retval None
 */
void SystemInit(void)
{
    /* Reset the RCC clock configuration to the default reset state(for debug purpose) */
    /* Set HSION bit */
    RCC->CR |= (uint32_t)0x00000001;

    /* Reset SW, HPRE, PPRE1, PPRE2, ADCPRE and MCO bits */
    RCC->CFGR &= (uint32_t)0xF8FF0000;

    /* Reset HSEON, CSSON and PLLON bits */
    RCC->CR &= (uint32_t)0xFEF6FFFF;

    /* Reset HSEBYP bit */
    RCC->CR &= (uint32_t)0xFFFBFFFF;

    /* Reset PLLSRC, PLLXTPRE, PLLMUL and USBPRE/OTGFSPRE bits */
    RCC->CFGR &= (uint32_t)0xFF80FFFF;

    /* Disable all interrupts and clear pending bits  */
    RCC->CIR = 0x009F0000;
}

/**
 * @brief  Dummy function for weak symbol
 * @param  None
 * @retval None
 */
void __libc_init_array(void) {}
