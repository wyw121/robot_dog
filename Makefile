# Makefile for Robot Dog Project

# 项目名称
PROJECT = robot_dog

# 编译器设置
CC = arm-none-eabi-gcc
OBJCOPY = arm-none-eabi-objcopy
OBJDUMP = arm-none-eabi-objdump
SIZE = arm-none-eabi-size

# MCU设置
MCU = cortex-m3
STARTUP = startup_stm32f103xb.s

# 编译标志
CFLAGS = -mcpu=$(MCU) -mthumb -Wall -O2 -g
CFLAGS += -DSTM32F103xB -DUSE_STDPERIPH_DRIVER
CFLAGS += -I./src
CFLAGS += -I./lib/CMSIS/Include
CFLAGS += -I./lib/CMSIS/Device/ST/STM32F10x/Include
CFLAGS += -I./lib/STM32F10x_StdPeriph_Driver/inc

# 链接标志
LDFLAGS = -mcpu=$(MCU) -mthumb -T./stm32f103c8.ld
LDFLAGS += -Wl,--gc-sections -Wl,-Map=$(PROJECT).map
LDFLAGS += -nostartfiles

# 源文件
SOURCES = src/main.c
SOURCES += src/system_stm32f1xx.c

# 汇编源文件
ASM_SOURCES = $(STARTUP)

# 目标文件
OBJECTS = $(SOURCES:.c=.o) $(ASM_SOURCES:.s=.o)

# 默认目标
all: $(PROJECT).hex $(PROJECT).bin

# 编译规则
%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

# 汇编编译规则
%.o: %.s
	$(CC) $(CFLAGS) -c $< -o $@

# 链接
$(PROJECT).elf: $(OBJECTS)
	$(CC) $(LDFLAGS) $^ -o $@

# 生成hex文件
$(PROJECT).hex: $(PROJECT).elf
	$(OBJCOPY) -O ihex $< $@

# 生成bin文件
$(PROJECT).bin: $(PROJECT).elf
	$(OBJCOPY) -O binary $< $@

# 显示大小信息
size: $(PROJECT).elf
	$(SIZE) $<

# 清理
clean:
	rm -f $(OBJECTS) $(PROJECT).elf $(PROJECT).hex $(PROJECT).bin $(PROJECT).map

# 烧录 (使用ST-Link)
flash: $(PROJECT).hex
	st-flash --format ihex write $<

# 调试
debug: $(PROJECT).elf
	arm-none-eabi-gdb $< -ex "target remote localhost:3333"

.PHONY: all clean size flash debug
