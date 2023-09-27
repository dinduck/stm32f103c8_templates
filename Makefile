# ------------------------ 配置 ===========================#

# 目标文件
# 将其设置成项目文件 最后生成 ${TARGET}.elf 和 ${TARGET}.bin
TARGET = workspace

# 构建目录
BUILD_DIR = build


# 以 Debug 编译
DEBUG = 1

# 优化等级
# -Og 优化可以产生良好的调试体验， 如果想减小目标体积可选 -Os
# -O2 -O3 具有更高的优化等级，但是不方便调试， 可大幅减小代码体积
OPT = -Og

# C 语言源文件
# 后续的新文件建议手动添加， 虽然可以使用 dir/*.c 匹配 dir 目录下所有源文件

# 外设库源文件
C_SOURCES += \
$(wildcard ./Libraries/CMSIS/CM3/DeviceSupport/ST/STM32F10x/*.c) \
$(wildcard ./Libraries/CMSIS/CM3/CoreSupport/*.c) \
$(wildcard ./User/*.c) \
$(wildcard ./Libraries/STM32F10x_StdPeriph_Driver/src/*.c) \

# Library/misc.c \
# Library/stm32f10x_bkp.c \
# Library/stm32f10x_cec.c \
# Library/stm32f10x_dac.c \
# Library/stm32f10x_dma.c \
# Library/stm32f10x_flash.c \
# Library/stm32f10x_gpio.c \
# Library/stm32f10x_iwdg.c \
# Library/stm32f10x_rcc.c \
# Library/stm32f10x_sdio.c \
# Library/stm32f10x_tim.c \
# Library/stm32f10x_wwdg.c \
# Library/stm32f10x_adc.c \
# Library/stm32f10x_can.c \
# Library/stm32f10x_crc.c \
# Library/stm32f10x_dbgmcu.c \
# Library/stm32f10x_exti.c \
# Library/stm32f10x_fsmc.c \
# Library/stm32f10x_i2c.c \
# Library/stm32f10x_pwr.c \
# Library/stm32f10x_rtc.c \
# Library/stm32f10x_spi.c \
# Library/stm32f10x_usart.c \
# Library/stm32f10x_it.c \

# 汇编源文件
ASM_SOURCES =  \
./Libraries/CMSIS/CM3/DeviceSupport/ST/STM32F10x/startup/gcc_ride7/startup_stm32f10x_md.s \


#-------------------------------------- 二进制 -----------------------------#
# ------------------------------------------------------------------------- #

# 工具链前缀
# 安装 GNU Arm Embedded Toolchain ，保证添加环境变量， 也可以直接 source/bin/arm-none-eabi- 指定对应目录下的工具链
PREFIX = arm-none-eabi-

# 编译器及工具
# 如果定义了 GCC 的路径
# GCC_PATH = ../gcc7/gcc-arm-none-eabi-7-2018-q2-update/bin/
ifdef GCC_PATH
CC = $(GCC_PATH)/$(PREFIX)gcc
AS = $(GCC_PATH)/$(PREFIX)gcc -x assembler-with-cpp
CP = $(GCC_PATH)/$(PREFIX)objcopy
SZ = $(GCC_PATH)/$(PREFIX)size
GDB = $(GCC_PATH)/$(PREFIX)gdb
else
CC = $(PREFIX)gcc
AS = $(PREFIX)gcc -x assembler-with-cpp
CP = $(PREFIX)objcopy
SZ = $(PREFIX)size
GDB = $(PREFIX)gdb
endif
HEX = $(CP) -O ihex
BIN = $(CP) -O binary -S

######################################
# CFLAGS
######################################
# 目标 cpu
CPU = -mcpu=cortex-m3

# fpu
# Cortex-M0/M0+/M3 都没有这玩意
# FPU = 

# float-abi
# FLOAT_ABI

# mcu
# -mthumb 代表 thumb 指令集, 可减小目标文件大小
MCU = $(CPU) -mthumb $(FPU) $(FLOAT_ABI)

# 汇编定义
AS_DEFS = 

# C 语言宏定义
# -D_BLUETOOTH_H__ 表示 #define _BLUETOOTH__ 用于编译时的条件编译
C_DEFS = \
-DSTM32F10X_MD \

# 标准外设接口库
C_DEFS += \
-DUSE_STDPERIPH_DRIVER \

# 外部高速晶振
C_DEFS += \
-DHSE_VALUE=8000000 \

# 汇编头文件
AS_INCLUDES = 

# C 头文件
# -Iinc 指定 inc 是头文件目录， 在寻找头文件就会来 inc 找
C_INCLUDES = \
-I./Libraries/CMSIS/CM3/DeviceSupport/ST/STM32F10x \
-I./User \
-I./Libraries/CMSIS/CM3/CoreSupport \
-I./Libraries/STM32F10x_StdPeriph_Driver/inc \



# gcc 编译的参数
# -Wall 开启全局警告
#  -fdata-sections 用于将静态和全局变量放置单独的 data sec 中
#  --ffunction-sections 将函数符号放置单独的 func sec 中
#  -f 这两都可以减小目标体积
ASFLAGS = $(MCU) $(AS_DEFS) $(AS_INCLUDES) $(OPT) -Wall -fdata-sections -ffunction-sections

CFLAGS += $(MCU) $(C_DEFS) $(C_INCLUDES) $(OPT) -Wall -fdata-sections -ffunction-sections

# 如果编译模式为 DEBUG
# -g 告诉编译器生成调试信息， 方便程序调试
#  -gdwarf-2  指明生成 DWARF 版本 2 的调试信息
ifeq ($(DEBUG), 1)
CFLAGS += -g -gdwarf-2
endif

# 生成依赖信息
# -MMD 用于生成一个 .d 文件， 其中包含源文件的依赖信息
#  -MP 生成伪文件， 表示源文件之间的依赖关系， 与 -MMD 使用可以防止因头文件删除而引起的中断构建
#  -MF 指定生成依赖文件的名称 (@:%.o=%.d) 表示将每个 .o 文件后缀改为 .d
CFLAGS += -MMD -MP -MF"$(@:%.o=%.d)"

##########################
# 库 Lib
##########################
# 可选
# -lc 表示链接 libc 也就是标准库
# -lm 表示链接 libm 也就是数字库
# -lnosys 表示链接 libnosys ， 根据不同系统不一致， 这里可以理解没有 syscall 功能
LIBS = -lc -lm -lnosys 
# 库目录
# -Ldir 指定 表示 在 dir 下寻找相关的库
LIBDIR = 

# 链接脚本
LDSCRIPT = ./Libraries/LinkScript/stm32f103c8t6.ld

# 链接参数

LDFLAGS = $(MCU) -specs=nano.specs -T$(LDSCRIPT) $(LIBDIR) $(LIBS) -Wl,-Map=$(BUILD_DIR)/$(TARGET).map,--cref -Wl,--gc-sections

# 默认构建
all: $(BUILD_DIR)/$(TARGET).elf $(BUILD_DIR)/$(TARGET).hex $(BUILD_DIR)/$(TARGET).bin


####################
# 开始构建
####################
# obj 列表
OBJECTS = $(addprefix $(BUILD_DIR)/, $(notdir $(C_SOURCES:.c=.o)))
vpath %.c $(sort $(dir $(C_SOURCES)))

# 汇编 obj 列表
OBJECTS += $(addprefix $(BUILD_DIR)/,$(notdir $(ASM_SOURCES:.s=.o)))
vpath %.s $(sort $(dir $(ASM_SOURCES)))

$(BUILD_DIR)/%.o: %.c Makefile | $(BUILD_DIR)
	$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/$(notdir $(<:.c=.lst)) $< -o $@

$(BUILD_DIR)/%.o: %.s Makefile | $(BUILD_DIR)
	$(AS) -c $(CFLAGS) $< -o $@

$(BUILD_DIR)/$(TARGET).elf: $(OBJECTS) Makefile
	$(CC) $(OBJECTS) $(LDFLAGS) -o $@
	$(SZ) $@

$(BUILD_DIR)/$(TARGET).hex: $(BUILD_DIR)/$(TARGET).elf | $(BUILD_DIR)
	$(HEX) $< $@

$(BUILD_DIR)/$(TARGET).bin: $(BUILD_DIR)/$(TARGET).elf | $(BUILD_DIR)
	$(BIN) $< $@




$(BUILD_DIR):
	@mkdir $@
# 清理构建
clean:
	-rm -rf $(BUILD_DIR)
	@echo "已清理所有构建"


-include $(wildcard $(BUILD_DIR)/*.d)
# 用于烧录
# 烧写 
# 调试
# 擦写
TYPE_BURN  := openocd_swd_flash
TYPE_DEBUG := openocd_swd_debug
TYPE_ERASE := openocd_swd_erase
TYPE_INIT  := cmake_init
burn: $(TYPE_BURN)
debug: $(TYPE_DEBUG)
erase: $(TYPE_ERASE)



cbuild: $(TYPE_INIT)
	@cmake --build ./build \
		--config Debug \
		--target all --

# ELF 文件存在调试信息，BIN 文件没有
$(TYPE_BURN): $(BUILD_DIR)/$(TARGET).bin
	openocd -f interface/cmsis-dap.cfg -c "transport select swd" -f target/stm32f1x.cfg -c "init" -c "reset halt" -c "sleep 100" -c "wait_halt 2" -c "flash write_image erase $< 0x08000000" -c "sleep 100" -c "verify_image $< 0x08000000" -c "sleep 100" -c "reset run" -c shutdown

$(TYPE_DEBUG): $(BUILD_DIR)/$(TARGET).elf
	@kitty -e openocd -f interface/cmsis-dap.cfg -c "transport select swd" -f target/stm32f1x.cfg -c "init" -c "halt" -c "reset halt" &
	$(GDB) --eval-command="target remote localhost:3333" $<

$(TYPE_ERASE):
	openocd -f interface/cmsis-dap.cfg -c "transport select swd" -f target/stm32f1x.cfg  -c "init" -c "reset halt" -c "sleep 100" -c "stm32f1x mass_erase 0" -c "sleep 100" -c shutdown


$(TYPE_INIT):
	cmake -B build -GNinja -DCMAKE_TOOLCHAIN_FILE:FILEPATH=cmake/toolchain.cmake

