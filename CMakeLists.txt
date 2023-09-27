cmake_minimum_required(VERSION 3.5)

project(HELLO C ASM)


# 启用命令输出，Vim/NeoVim 安装 LSP 时， LSP 可以正常工作:w
set(CMAKE_EXPORT_COMPILE_COMMANDS TRUE)

# 源文件
file(GLOB_RECURSE C_SOURCES
    Libraries/CMSIS/CM3/DeviceSupport/ST/STM32F10x/*.c
    Libraries/CMSIS/CM3/CoreSupport/*.c
    User/*.c
    Libraries/STM32F10x_StdPeriph_Driver/src/*.c
    EVAL/*.c
    System/*.c
)


# 汇编源文件
file(GLOB ASM_SOURCES
    Libraries/CMSIS/CM3/DeviceSupport/ST/STM32F10x/startup/gcc_ride7/startup_stm32f10x_md.s
)



# 添加头文件目录
include_directories(
    Libraries/CMSIS/CM3/DeviceSupport/ST/STM32F10x
    User
    Libraries/CMSIS/CM3/CoreSupport
    Libraries/STM32F10x_StdPeriph_Driver/inc
    EVAL
    System
)



add_executable(${PROJECT_NAME})


target_link_directories(
  ${PROJECT_NAME} PRIVATE
)


target_compile_definitions(
  ${PROJECT_NAME} PRIVATE
  STM32F10X_MD
  USE_STDPERIPH_DRIVER

  )

target_compile_options(
  ${PROJECT_NAME} PRIVATE
  "$<$<CONFIG:Debug>:-Og>"
  "$<$<CONFIG:Debug>:-g2>"
  "$<$<NOT:$<CONFIG:Debug>>:-Os>"
  "$<$<NOT:$<CONFIG:Debug>>:-g0>"
  -mcpu=cortex-m3
  )

target_link_options(
  ${PROJECT_NAME} PRIVATE
  -mcpu=cortex-m3
  -T
  ${PROJECT_SOURCE_DIR}/Libraries/LinkScript/stm32f103c8t6.ld
  )
target_sources(
  ${PROJECT_NAME} PRIVATE
  ${C_SOURCES}
  ${ASM_SOURCES}
)


add_custom_command(
  TARGET ${PROJECT_NAME} POST_BUILD
  COMMAND ${CMAKE_SIZE} $<TARGET_FILE:${PROJECT_NAME}>
)


add_custom_command(
  TARGET ${PROJECT_NAME} POST_BUILD
    COMMAND ${CMAKE_OBJCOPY} -O ihex
    $<TARGET_FILE:${PROJECT_NAME}> ${PROJECT_NAME}.hex
)

add_custom_command(
  TARGET ${PROJECT_NAME} POST_BUILD
    COMMAND ${CMAKE_OBJCOPY} -O binary
    $<TARGET_FILE:${PROJECT_NAME}> ${PROJECT_NAME}.bin
)

