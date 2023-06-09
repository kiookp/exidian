#!/bin/bash

# 显示菜单
display_menu() {
  echo "1. 启动容器并运行 /data/app.py 脚本"
  echo "2. 进入容器"
  echo "3. 查看容器运行状态"
  echo "4. 退出"
}

# 启动容器并运行 /data/app.py 脚本
start_container_and_run_script() {
  docker run -d -it -v /root/exidian:/data ipd805/kkedu:v1.0 python3 /data/app.py
  echo "容器已启动并运行 /data/app.py 脚本。"
}

# 进入容器
enter_container() {
  container_id=$(docker ps -q -l)
  docker exec -it "$container_id" bash
}

# 查看容器运行状态
view_container_status() {
  docker ps
}

# 主菜单循环
while true; do
  display_menu
  echo "请输入选项："
  read choice

  case $choice in
    1) start_container_and_run_script ;;
    2) enter_container ;;
    3) view_container_status ;;
    4) exit ;;
    *) echo "无效的选项，请重试。" ;;
  esac
done
