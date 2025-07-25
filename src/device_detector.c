/**
 * @file device_detector.c
 * @brief 设备检测程序 - 帮助用户识别机器狗设备
 * @description 通过列出串口设备来帮助用户找到正确的机器狗设备名称
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <windows.h>

// 颜色定义用于控制台输出
#define COLOR_RESET "\033[0m"
#define COLOR_RED "\033[31m"
#define COLOR_GREEN "\033[32m"
#define COLOR_YELLOW "\033[33m"
#define COLOR_BLUE "\033[34m"
#define COLOR_MAGENTA "\033[35m"
#define COLOR_CYAN "\033[36m"
#define COLOR_WHITE "\033[37m"

/**
 * @brief 设置控制台为UTF-8编码以支持中文显示
 */
void SetConsoleUTF8(void)
{
    SetConsoleOutputCP(CP_UTF8);
    SetConsoleCP(CP_UTF8);
}

/**
 * @brief 清屏函数
 */
void ClearScreen(void)
{
    system("cls");
}

/**
 * @brief 打印带颜色的标题
 */
void PrintTitle(void)
{
    printf(COLOR_CYAN "========================================\n");
    printf("           机器狗设备检测器\n");
    printf("========================================\n" COLOR_RESET);
    printf(COLOR_YELLOW "使用说明：\n");
    printf("1. 先运行一次程序，记录当前设备列表\n");
    printf("2. 插入您的机器狗设备\n");
    printf("3. 再次运行程序，对比新增的设备\n");
    printf("4. 新增的设备就是您的机器狗!\n" COLOR_RESET);
    printf(COLOR_CYAN "========================================\n" COLOR_RESET);
}

/**
 * @brief 枚举并显示所有串口设备
 */
void EnumerateSerialPorts(void)
{
    HKEY hKey;
    LONG result;
    DWORD index = 0;
    char valueName[256];
    DWORD valueNameSize;
    DWORD valueType;
    char valueData[256];
    DWORD valueDataSize;
    int portCount = 0;

    printf(COLOR_GREEN "\n当前检测到的串口设备：\n" COLOR_RESET);
    printf(COLOR_WHITE "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n" COLOR_RESET);

    // 打开注册表项
    result = RegOpenKeyEx(HKEY_LOCAL_MACHINE,
                          "HARDWARE\\DEVICEMAP\\SERIALCOMM",
                          0,
                          KEY_READ,
                          &hKey);

    if (result != ERROR_SUCCESS)
    {
        printf(COLOR_RED "❌ 错误：无法访问注册表中的串口信息\n" COLOR_RESET);
        printf(COLOR_YELLOW "💡 提示：请确保以管理员权限运行程序\n" COLOR_RESET);
        return;
    }

    // 枚举所有值
    while (1)
    {
        valueNameSize = sizeof(valueName);
        valueDataSize = sizeof(valueData);

        result = RegEnumValue(hKey,
                              index,
                              valueName,
                              &valueNameSize,
                              NULL,
                              &valueType,
                              (LPBYTE)valueData,
                              &valueDataSize);

        if (result == ERROR_NO_MORE_ITEMS)
        {
            break;
        }

        if (result == ERROR_SUCCESS && valueType == REG_SZ)
        {
            portCount++;
            printf(COLOR_BLUE "📱 设备 %d: " COLOR_WHITE "%s" COLOR_CYAN " -> " COLOR_GREEN "%s\n" COLOR_RESET,
                   portCount, valueName, valueData);

            // 尝试识别常见的设备类型
            if (strstr(valueName, "USB") != NULL)
            {
                printf(COLOR_YELLOW "   💡 这是一个USB串口设备\n" COLOR_RESET);
            }
            if (strstr(valueName, "VCP") != NULL)
            {
                printf(COLOR_YELLOW "   💡 这是一个虚拟串口设备 (可能是您的机器狗)\n" COLOR_RESET);
            }
            if (strstr(valueName, "CH340") != NULL || strstr(valueName, "CH341") != NULL)
            {
                printf(COLOR_YELLOW "   💡 检测到CH340/CH341芯片 (常用于Arduino兼容设备)\n" COLOR_RESET);
            }
            if (strstr(valueName, "FTDI") != NULL)
            {
                printf(COLOR_YELLOW "   💡 检测到FTDI芯片 (高质量USB转串口)\n" COLOR_RESET);
            }
            if (strstr(valueName, "CP210") != NULL)
            {
                printf(COLOR_YELLOW "   💡 检测到CP210x芯片 (Silicon Labs USB转串口)\n" COLOR_RESET);
            }

            printf("\n");
        }
        index++;
    }

    RegCloseKey(hKey);

    if (portCount == 0)
    {
        printf(COLOR_RED "❌ 未检测到任何串口设备\n" COLOR_RESET);
        printf(COLOR_YELLOW "💡 请检查：\n");
        printf("   - 设备是否正确连接到电脑\n");
        printf("   - 设备驱动程序是否已安装\n");
        printf("   - USB线缆是否正常工作\n" COLOR_RESET);
    }
    else
    {
        printf(COLOR_WHITE "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n" COLOR_RESET);
        printf(COLOR_GREEN "✅ 总共检测到 %d 个串口设备\n" COLOR_RESET, portCount);
    }
}

/**
 * @brief 检测设备是否可以打开
 */
void TestPortAccess(const char *portName)
{
    HANDLE hSerial;
    char fullPortName[32];

    sprintf(fullPortName, "\\\\.\\%s", portName);

    hSerial = CreateFile(fullPortName,
                         GENERIC_READ | GENERIC_WRITE,
                         0,
                         NULL,
                         OPEN_EXISTING,
                         FILE_ATTRIBUTE_NORMAL,
                         NULL);

    if (hSerial != INVALID_HANDLE_VALUE)
    {
        printf(COLOR_GREEN "✅ %s 可以正常访问\n" COLOR_RESET, portName);
        CloseHandle(hSerial);
    }
    else
    {
        printf(COLOR_RED "❌ %s 无法访问 (可能被其他程序占用)\n" COLOR_RESET, portName);
    }
}

/**
 * @brief 显示操作菜单
 */
void ShowMenu(void)
{
    printf(COLOR_CYAN "\n选择操作：\n" COLOR_RESET);
    printf(COLOR_WHITE "1. " COLOR_GREEN "🔍 重新扫描设备\n" COLOR_RESET);
    printf(COLOR_WHITE "2. " COLOR_YELLOW "📋 测试特定COM口访问\n" COLOR_RESET);
    printf(COLOR_WHITE "3. " COLOR_BLUE "📖 查看使用说明\n" COLOR_RESET);
    printf(COLOR_WHITE "4. " COLOR_RED "❌ 退出程序\n" COLOR_RESET);
    printf(COLOR_CYAN "请输入选项 (1-4): " COLOR_RESET);
}

/**
 * @brief 显示详细使用说明
 */
void ShowInstructions(void)
{
    ClearScreen();
    printf(COLOR_CYAN "========================================\n");
    printf("           详细使用说明\n");
    printf("========================================\n" COLOR_RESET);

    printf(COLOR_YELLOW "\n🎯 目标：找到您的机器狗设备名称\n" COLOR_RESET);

    printf(COLOR_GREEN "\n📝 操作步骤：\n" COLOR_RESET);
    printf("1️⃣  首先拔掉机器狗设备\n");
    printf("2️⃣  运行此程序，记录当前的设备列表\n");
    printf("3️⃣  插入机器狗设备并等待系统识别\n");
    printf("4️⃣  再次扫描设备，新出现的就是您的机器狗\n");

    printf(COLOR_BLUE "\n🔍 设备识别提示：\n" COLOR_RESET);
    printf("• 机器狗通常显示为 COM1, COM3, COM4 等\n");
    printf("• 设备名可能包含 USB, VCP, CH340 等关键词\n");
    printf("• 如果有多个设备，可以逐个测试\n");

    printf(COLOR_MAGENTA "\n⚠️  注意事项：\n" COLOR_RESET);
    printf("• 确保机器狗设备已正确安装驱动\n");
    printf("• 如果设备无法访问，可能被其他程序占用\n");
    printf("• 某些设备可能需要特定的波特率设置\n");

    printf(COLOR_CYAN "\n按任意键返回主菜单..." COLOR_RESET);
    getchar();
    getchar(); // 清除输入缓冲区
}

/**
 * @brief 主函数
 */
int main(void)
{
    int choice;
    char portName[16];

    SetConsoleUTF8();

    while (1)
    {
        ClearScreen();
        PrintTitle();
        EnumerateSerialPorts();
        ShowMenu();

        if (scanf("%d", &choice) != 1)
        {
            printf(COLOR_RED "❌ 无效输入，请输入数字 1-4\n" COLOR_RESET);
            while (getchar() != '\n')
                ; // 清除输入缓冲区
            Sleep(1500);
            continue;
        }

        switch (choice)
        {
        case 1:
            printf(COLOR_GREEN "🔄 正在重新扫描设备...\n" COLOR_RESET);
            Sleep(1000);
            break;

        case 2:
            printf(COLOR_YELLOW "请输入要测试的COM口名称 (例如: COM3): " COLOR_RESET);
            if (scanf("%s", portName) == 1)
            {
                TestPortAccess(portName);
                printf(COLOR_CYAN "按任意键继续..." COLOR_RESET);
                getchar();
                getchar();
            }
            break;

        case 3:
            ShowInstructions();
            break;

        case 4:
            printf(COLOR_GREEN "👋 感谢使用机器狗设备检测器！\n" COLOR_RESET);
            return 0;

        default:
            printf(COLOR_RED "❌ 无效选项，请重新选择\n" COLOR_RESET);
            Sleep(1500);
            break;
        }
    }

    return 0;
}
