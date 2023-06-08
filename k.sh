#!/bin/bash

# 配置账号信息
configure_account() {
    read -p "请输入 Telegram Bot Token: " telegram_bot_token
    read -p "请输入 Telegram Chat ID: " telegram_chat_id
    read -p "请输入网站: " website
    read -p "请输入用户名: " username
    read -p "请输入密码: " password

    # 将配置写入文件
    echo -e "[Credentials]\ntelegram_bot_token = $telegram_bot_token\ntelegram_chat_id = $telegram_chat_id\nwebsite = $website\nusername = $username\npassword = $password" > config.ini

    echo "账号配置完成。"
    echo
}

# 安装环境
install_environment() {
    wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
    echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list
    apt-get -y update
    apt-get install -y google-chrome-stable
    apt-get install -yqq unzip screen
    wget -O /tmp/chromedriver.zip http://chromedriver.storage.googleapis.com/$(curl -sS chromedriver.storage.googleapis.com/LATEST_RELEASE)/chromedriver_linux64.zip
    unzip /tmp/chromedriver.zip chromedriver -d /usr/local/bin/
    pip install --upgrade pip
    pip install selenium
    pip install undetected-chromedriver
    pip install pyTelegramBotAPI

    echo "环境安装完成。"
    echo
}

# 运行程序
run_program() {
    # 下载 git 仓库
    git clone https://github.com/kiookp/exidian.git
    cd exidian

    # 创建新的 screen 窗口并运行程序
    screen -dmS exidian python3 app.py

    echo "程序已启动。您可以查看 screen 会话以查看日志。"
    echo
}

# 菜单
echo "菜单："
echo "1. 配置账号信息"
echo "2. 安装环境"
echo "3. 运行程序"

read -p "请输入您的选择（1-3）: " choice
echo

case $choice in
    1) configure_account;;
    2) install_environment;;
    3) run_program;;
    *) echo "无效的选择。退出。";;
esac
