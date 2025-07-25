/**
 * @file test_program.c
 * @brief Robot Dog Test Program
 * @description Contains multiple test functions to verify hardware and basic functionality
 */

#include "stm32f10x.h"
#include "hardware/servo.h"
#include "hardware/oled.h"
#include "hardware/bluetooth.h"
#include "hardware/delay.h"
#include "behaviors/pet_action.h"
#include "behaviors/face_config.h"

// Test mode definitions
typedef enum
{
    TEST_MODE_AUTO = 0,   // Auto test mode
    TEST_MODE_SERVO,      // Servo test
    TEST_MODE_OLED,       // Display test
    TEST_MODE_BLUETOOTH,  // Bluetooth test
    TEST_MODE_ACTIONS,    // Action test
    TEST_MODE_INTERACTIVE // Interactive test
} TestMode_t;

static TestMode_t current_mode = TEST_MODE_AUTO;

/**
 * @brief Initialize test system
 */
void Test_SystemInit(void)
{
    // Basic hardware initialization
    Delay_Init();
    OLED_Init();
    Servo_Init();
    BlueTooth_Init();

    // Display test startup screen
    OLED_Clear();
    OLED_ShowString(0, 0, "Robot Dog Test", 16);
    OLED_ShowString(0, 16, "Version: 1.0", 12);
    OLED_ShowString(0, 32, "Starting...", 12);
    OLED_Refresh_Gram();

    Delay_ms(2000);
} /**
   * @brief 舵机功能测试
   */
void Test_ServoFunction(void)
{
    OLED_Clear();
    OLED_ShowString(0, 0, "Servo Test", 16);
    OLED_Refresh_Gram();

    // 测试每个舵机
    for (int servo = 0; servo < 8; servo++)
    {
        OLED_ShowString(0, 16, "Testing Servo:", 12);
        OLED_ShowNum(84, 16, servo + 1, 1, 12);
        OLED_Refresh_Gram();

        // 舵机运动测试：0° -> 90° -> 180° -> 90°
        Servo_SetAngle(servo, 0);
        Delay_ms(500);
        Servo_SetAngle(servo, 90);
        Delay_ms(500);
        Servo_SetAngle(servo, 180);
        Delay_ms(500);
        Servo_SetAngle(servo, 90);
        Delay_ms(500);
    }

    OLED_ShowString(0, 32, "Servo Test OK", 12);
    OLED_Refresh_Gram();
    Delay_ms(2000);
}

/**
 * @brief OLED显示测试
 */
void Test_OLEDDisplay(void)
{
    // 清屏测试
    OLED_Clear();
    OLED_ShowString(0, 0, "OLED Test", 16);
    OLED_Refresh_Gram();
    Delay_ms(1000);

    // 字符显示测试
    OLED_Clear();
    OLED_ShowString(0, 0, "ASCII Test:", 12);
    OLED_ShowString(0, 16, "ABCDEFGHIJKLM", 12);
    OLED_ShowString(0, 32, "0123456789", 12);
    OLED_ShowString(0, 48, "!@#$%^&*()", 12);
    OLED_Refresh_Gram();
    Delay_ms(3000);

    // 数字显示测试
    OLED_Clear();
    OLED_ShowString(0, 0, "Number Test:", 12);
    for (int i = 0; i < 100; i += 10)
    {
        OLED_ShowString(0, 16, "Count: ", 12);
        OLED_ShowNum(42, 16, i, 3, 12);
        OLED_Refresh_Gram();
        Delay_ms(200);
    }

    // 表情测试
    Face_Happy();
    Delay_ms(1000);
    Face_Sad();
    Delay_ms(1000);
    Face_Angry();
    Delay_ms(1000);
    Face_Excited();
    Delay_ms(1000);
}

/**
 * @brief 蓝牙通信测试
 */
void Test_BluetoothComm(void)
{
    OLED_Clear();
    OLED_ShowString(0, 0, "Bluetooth Test", 16);
    OLED_ShowString(0, 16, "Waiting conn...", 12);
    OLED_Refresh_Gram();

    // 发送测试数据
    BlueTooth_SendString("Robot Dog Test Program\n");
    BlueTooth_SendString("Commands:\n");
    BlueTooth_SendString("1 - Walk Forward\n");
    BlueTooth_SendString("2 - Turn Left\n");
    BlueTooth_SendString("3 - Turn Right\n");
    BlueTooth_SendString("4 - Sit\n");
    BlueTooth_SendString("5 - Stand\n");
    BlueTooth_SendString("6 - Dance\n");
    BlueTooth_SendString("9 - Auto Test\n");

    OLED_ShowString(0, 32, "Commands sent", 12);
    OLED_Refresh_Gram();
    Delay_ms(2000);
}

/**
 * @brief 基础动作测试
 */
void Test_BasicActions(void)
{
    OLED_Clear();
    OLED_ShowString(0, 0, "Action Test", 16);
    OLED_Refresh_Gram();

    // 测试基础动作
    struct
    {
        char *name;
        void (*action_func)(void);
    } test_actions[] = {
        {"Greet", Action_Greet},
        {"Walk Forward", Action_WalkForward},
        {"Turn Left", Action_TurnLeft},
        {"Turn Right", Action_TurnRight},
        {"Sit", Action_Sit},
        {"Stand", Action_Stand},
        {"Shake Head", Action_ShakeHead},
        {"Wag Tail", Action_WagTail},
        {"Dance", Action_Dance}};

    int action_count = sizeof(test_actions) / sizeof(test_actions[0]);

    for (int i = 0; i < action_count; i++)
    {
        OLED_ShowString(0, 16, "Testing:", 12);
        OLED_ShowString(0, 32, test_actions[i].name, 12);
        OLED_Refresh_Gram();

        // 执行动作
        test_actions[i].action_func();

        Delay_ms(1000);
    }

    OLED_ShowString(0, 48, "Actions OK", 12);
    OLED_Refresh_Gram();
    Delay_ms(2000);
}

/**
 * @brief 自动测试模式
 */
void Test_AutoMode(void)
{
    OLED_Clear();
    OLED_ShowString(0, 0, "Auto Test Mode", 16);
    OLED_ShowString(0, 16, "Running...", 12);
    OLED_Refresh_Gram();

    // 依次执行各项测试
    Test_OLEDDisplay();
    Test_ServoFunction();
    Test_BluetoothComm();
    Test_BasicActions();

    // 测试完成
    OLED_Clear();
    OLED_ShowString(0, 0, "All Tests", 16);
    OLED_ShowString(0, 16, "Completed!", 16);
    OLED_ShowString(0, 32, "Ready for use", 12);
    OLED_Refresh_Gram();

    Face_Happy();
}

/**
 * @brief 交互测试模式
 */
void Test_InteractiveMode(void)
{
    uint8_t received_data;

    OLED_Clear();
    OLED_ShowString(0, 0, "Interactive", 16);
    OLED_ShowString(0, 16, "Send commands", 12);
    OLED_ShowString(0, 32, "via Bluetooth", 12);
    OLED_Refresh_Gram();

    while (1)
    {
        if (BlueTooth_ReceiveData(&received_data))
        {
            OLED_ShowString(0, 48, "Cmd: ", 12);
            OLED_ShowChar(30, 48, received_data);
            OLED_Refresh_Gram();

            switch (received_data)
            {
            case '1':
                Action_WalkForward();
                BlueTooth_SendString("Walking forward\n");
                break;
            case '2':
                Action_TurnLeft();
                BlueTooth_SendString("Turning left\n");
                break;
            case '3':
                Action_TurnRight();
                BlueTooth_SendString("Turning right\n");
                break;
            case '4':
                Action_Sit();
                BlueTooth_SendString("Sitting\n");
                break;
            case '5':
                Action_Stand();
                BlueTooth_SendString("Standing\n");
                break;
            case '6':
                Action_Dance();
                BlueTooth_SendString("Dancing\n");
                break;
            case '9':
                BlueTooth_SendString("Starting auto test\n");
                Test_AutoMode();
                return;
            default:
                BlueTooth_SendString("Unknown command\n");
                break;
            }
        }
        Delay_ms(100);
    }
}

/**
 * @brief 测试程序主函数
 */
int main(void)
{
    // 初始化测试系统
    Test_SystemInit();

    // 开始自动测试
    Test_AutoMode();

    // 切换到交互模式
    Test_InteractiveMode();

    return 0;
}
