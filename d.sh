#!/bin/bash

# 显示菜单
display_menu() {
  echo "1. 启动容器并在后台进入 /data 目录执行 app.py 脚本"
  echo "2. 进入容器"
  echo "3. 查看容器运行状态"
  echo "4. 退出"
}

# 启动容器并在后台进入 /data 目录执行 app.py 脚本
start_container_and_run_script() {
  container_id=$(docker run -d -it -v /root/exidian:/data ipd805/kkedu:v1.0 bash -c "cd /data && python3 app.py & sleep 5 && cat /data/log.txt && sleep 5")
  echo "容器已启动并在后台执行 /data/app.py 脚本。"

  # 输出容器 ID 方便退出
  echo "容器 ID: $container_id"

  # 等待容器运行
  docker logs -f "$container_id"
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
