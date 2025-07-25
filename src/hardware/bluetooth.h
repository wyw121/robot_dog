/**
 * @file bluetooth.h
 * @brief 蓝牙通信头文件
 * @version 1.0
 * @date 2025-07-25
 */

#ifndef BLUETOOTH_H
#define BLUETOOTH_H

#include "stm32f10x.h"

/* 蓝牙连接引脚定义 */
#define BT_USART        USART1
#define BT_TX_PORT      GPIOA
#define BT_TX_PIN       GPIO_Pin_9
#define BT_RX_PORT      GPIOA
#define BT_RX_PIN       GPIO_Pin_10

/* 蓝牙通信参数 */
#define BT_BAUDRATE     9600
#define BT_BUFFER_SIZE  64

/* 蓝牙命令定义 */
#define CMD_FORWARD     'W'
#define CMD_BACKWARD    'S'
#define CMD_LEFT        'A'
#define CMD_RIGHT       'D'
#define CMD_STOP        'X'
#define CMD_SIT         '1'
#define CMD_STAND       '2'
#define CMD_DANCE       '3'

/* 函数声明 */
void Bluetooth_Init(void);
void Bluetooth_SendString(char *str);
void Bluetooth_SendChar(char ch);
char Bluetooth_ReceiveChar(void);
uint8_t Bluetooth_ReceiveString(char *str);
uint8_t Bluetooth_DataAvailable(void);
void Bluetooth_ProcessCommand(char cmd);

#endif /* BLUETOOTH_H */
