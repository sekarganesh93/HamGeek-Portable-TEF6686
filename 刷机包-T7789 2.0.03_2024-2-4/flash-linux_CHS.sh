#!/bin/bash

# 显示版本信息和分隔线
echo "-----------------------------"
echo "-  更新工具 ESP32 TEF6686   -"
echo "-        版本 2.0.0         -"
echo "-----------------------------"

# 列出/dev/cu.*设备
devices=(/dev/cu.*)

# 检查是否有可用设备
if [ ${#devices[@]} -eq 0 ]; then
  echo "未找到任何设备。"
  exit 1
fi

echo "请确保您已安装 esptool\n(brew install esptool)\n"
# 显示可用设备列表
echo "请选择一个可用设备或选择退出："
for ((i=0; i<${#devices[@]}; i++)); do
  echo "$i: ${devices[i]}"
done
echo "x: 退出"

# 提示用户选择设备或退出
read -p "请选择一个设备（输入相应的数字或 'x' 退出）: " choice

# 检查用户选择退出
if [ "$choice" == "X" ] || [ "$choice" == "x" ]; then
  echo "退出程序。"
  exit 0
fi

# 检查用户输入是否合法
if ! [[ "$choice" =~ ^[0-9]+$ ]] || [ $choice -ge ${#devices[@]} ]; then
  echo "选择无效。请输一个有效的数字或 'X' 退出。"
  exit 1
fi

# 获取用户选择的设备
selected_device="${devices[choice]}"

while true; do
  # 显示菜单选项
  echo "请选择一个操作："
  echo "1. 清除 ESP32 Flash 存储"
  echo "2. 刷写固件"
  echo "3. 退出"

  # 提示用户选择一个选项
  read -p "输入操作的数字（1、2 或 3）: " choice

  # 检查用户输入是否合法
  if [ "$choice" == "1" ]; then
    # 执行清除 ESP32 Flash 存储的操作
    echo "执行清除 ESP32 Flash 存储的操作"
    # 在这里添加清除存储的命令
    esptool.py --port $selected_device erase_flash

    if [ $? -eq 0 ]; then
      # 操作成功
      echo "清除 ESP32 Flash 存储的操作已完成"
      echo "请再次进入刷机模式\n"
    else
      # 输出包含指定文本，操作失败
      echo "刷写失败，请重试\n"
    fi
    
  elif [ "$choice" == "2" ]; then
    # 执行刷写固件的操作
    echo "执行刷写固件的操作"
    # 在这里添加刷写固件的命令
    esptool.py --chip esp32 --port $selected_device --baud 460800 --before default_reset --after hard_reset write_flash -z \
    --flash_mode dio --flash_freq 80m --flash_size 4MB \
    0x1000 TEF6686_ESP32.ino.bootloader.bin \
    0x8000 TEF6686_ESP32.ino.partitions.bin \
    0x10000 TEF6686_ESP32.ino.bin

    # 如果终端输出包含 "通过 RTS 引脚进行硬重置"，表示刷写成功。
    if [ $? -eq 0 ]; then
      # 操作成功
      echo "刷写固件的操作已完成"
      echo "退出程序"
      break
    else
      # 输出包含指定文本，操作失败
      echo "刷写失败，请重试\n"
    fi

  elif [ "$choice" == "3" ]; then
    # 用户选择退出，退出循环
    echo "退出程序"
    break
  else
    echo "选择无效。请输入 1、2 或 3 来选择一个操作。"
  fi
done