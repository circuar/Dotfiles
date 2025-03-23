#!/usr/bin/env bash

get_cpu_usage() {
    local pid=$1
    # 读取 CPU 占用率，避免多次执行 ps
    ps -p "$pid" -o %cpu= | awk '{print int($1)}'
}

get_window_info() {
    # 获取当前活动窗口的 PID
    local pid
    pid=$(hyprctl activewindow -j | jq '.pid')

    # 获取进程总数
    local process_count
    process_count=$(ps -e --no-headers | wc -l)

    # 如果 PID 不存在，返回空数据
    if [[ -z "$pid" || "$pid" -eq "null" ]]; then
        echo "{ \"class\": \"unknown\", \"text\": \" 0%  -   $process_count\" }"
        return
    fi

    # 获取 CPU 使用率
    local cpu_usage
    cpu_usage=$(get_cpu_usage "$pid")

    # 分类 CPU 占用率
    local usage_class
    if (( cpu_usage < 10 )); then
        usage_class="low"
    elif (( cpu_usage < 50 )); then
        usage_class="mid"
    else
        usage_class="high"
    fi



    # 输出 JSON 格式
    echo "{ \"class\": \"$usage_class\", \"text\": \" ${cpu_usage}%  -   $process_count\" }"
}

get_window_info
