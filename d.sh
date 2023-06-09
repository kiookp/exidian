#!/bin/bash

# 显示菜单
display_menu() {
  echo "1. 启动容器并在后台执行 app.py 脚本"
  echo "2. 重启容器"
  echo "3. 停止容器"
  echo "4. 查看容器运行状态"
  echo "5. 退出"
}

# 启动容器并在后台执行 app.py 脚本
start_container_and_run_script() {
  docker run -d -v /root/exidian:/data ipd805/kkedu:v1.0 bash -c "cd /data && python3 app.py &> log.txt"
  echo "容器已启动并在后台执行 /data/app.py 脚本。"
}

# 重启容器
restart_container() {
  container_id=$(docker ps -q -l)
  docker restart "$container_id"
  echo "容器已重启。"
}

# 停止容器
stop_container() {
  container_id=$(docker ps -q -l)
  docker stop "$container_id"
  echo "容器已停止。"
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
    2) restart_container ;;
    3) stop_container ;;
    4) view_container_status ;;
    5) exit ;;
    *) echo "无效的选项，请重试。" ;;
  esac
done
