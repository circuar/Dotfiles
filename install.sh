#!/bin/bash

PACKAGE_FILE="$(dirname "$0")/packages.txt"

if [[ ! -f "$PACKAGE_FILE" ]]; then
    echo "软件包列表文件 $PACKAGE_FILE 不存在，请创建后重试。"
    exit 1
fi

while IFS= read -r package || [[ -n "$package" ]]; do
    while true; do
        echo "正在安装: $package"
        sudo pacman -S --noconfirm --needed "$package"
        if [[ $? -eq 0 ]]; then
            echo "$package 安装成功。"
            break
        else
            echo "$package 安装失败。"
            read -p "是否重试？(y/n)" choice
            if [[ "$choice" != "y" ]]; then
                echo "跳过 $package。"
                break
            fi
        fi
    done
done < "$PACKAGE_FILE"

echo "安装完成。"