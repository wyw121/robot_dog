/**
 * @file bluetooth.h
 * @brief 蓝牙通信模块头文件
 */

#ifndef __BLUETOOTH_H
#define __BLUETOOTH_H

#include "stm32f10x.h"

// 蓝牙命令定义
#define BT_CMD_FORWARD 'W'
#define BT_CMD_BACKWARD 'S'
#define BT_CMD_LEFT 'A'
#define BT_CMD_RIGHT 'D'
#define BT_CMD_SIT 'Q'
#define BT_CMD_STAND 'E'
#define BT_CMD_DANCE 'Z'
#define BT_CMD_GREET 'X'
#define BT_CMD_SLEEP 'C'
#define BT_CMD_STOP ' '

// 蓝牙状态
typedef enum
{
    BT_STATE_DISCONNECTED = 0,
    BT_STATE_CONNECTING,
    BT_STATE_CONNECTED
} BluetoothState_t;

// 接收缓冲区大小
#define BT_RX_BUFFER_SIZE 64

// 函数声明
void BlueTooth_Init(void);
void BlueTooth_Process(void);
void BlueTooth_SendString(char *str);
void BlueTooth_SendData(uint8_t *data, uint16_t len);
BluetoothState_t BlueTooth_GetState(void);
uint8_t BlueTooth_Available(void);
uint8_t BlueTooth_Read(void);
void BlueTooth_Flush(void);

// 命令处理
void BlueTooth_ProcessCommand(uint8_t cmd);
void BlueTooth_SendStatus(void);
void BlueTooth_SendBatteryLevel(void);

#endif /* __BLUETOOTH_H */
