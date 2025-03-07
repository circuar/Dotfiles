#!/bin/bash

# 获取窗口信息
window_info=$(hyprctl activewindow)

# 判断是否有焦点窗口
if [ -z "$window_info" ]; then
    echo "/"
    exit 0
fi

# 提取相关信息
workspace=$(echo "$window_info" | grep "workspace" | awk -F: '{print $2}' | tr -d ' ')
special_workspace=$(echo "$window_info" | grep "workspace" | awk -F: '{print $3}')
floating=$(echo "$window_info" | grep "floating" | awk -F: '{print $2}' | tr -d ' ')
pinned=$(echo "$window_info" | grep "pinned" | awk -F: '{print $2}' | tr -d ' ')

# 处理 workspace 名称
if [ "$special_workspace" = "magic)" ]; then
    workspace="S"
elif [ -z "$workspace" ]; then
    workspace="N"
else
    workspace=$(echo "$window_info" | grep "workspace" | awk -F: '{print $2}' | awk '{print $1}' | tr -d ' ')
fi

# 初始化状态
status="default"

# 处理 pinned 和 floating 状态


if [ "$floating" = "1" ]; then
    floating="FLOATING  "
    status="floating"
    else
    floating="FLOATING  "
fi



if [ "$pinned" = "1" ]; then
    pinned=" "
    status="pinned"
else
    pinned=" "
fi

# 输出 JSON
echo "{\"class\": \"$status\", \"text\": \"󰻂 $workspace  -  $pinned  -  $floating\"}"