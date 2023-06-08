#!/bin/bash

# 定义一些颜色和格式化选项
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color
BOLD=$(tput bold)
NORMAL=$(tput sgr0)

# 配置账号信息
configure_account() {
    echo -e "${YELLOW}${BOLD}配置账号信息${NORMAL}${NC}"
    read -p "${CYAN}请输入 Telegram Bot Token: ${NC}" telegram_bot_token
    read -p "${CYAN}请输入 Telegram Chat ID: ${NC}" telegram_chat_id
    read -p "${CYAN}请输入网站(带https://): ${NC}" website
    read -p "${CYAN}请输入用户名: ${NC}" username
    read -p "${CYAN}请输入密码: ${NC}" password

    # 将配置写入文件
    echo -e "[Credentials]\ntelegram_bot_token = $telegram_bot_token\ntelegram_chat_id = $telegram_chat_id\nwebsite = $website\nusername = $username\npassword = $password" > config.ini

    echo -e "${GREEN}账号配置完成。${NC}\n"
}

# 安装环境
install_environment() {
    echo -e "${YELLOW}${BOLD}安装环境${NORMAL}${NC}"
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

    echo -e "${GREEN}环境安装完成。${NC}\n"
}

# 运行程序
run_program() {
    echo -e "${YELLOW}${BOLD}运行程序${NORMAL}${NC}"
    # 下载 git 仓库
    git clone https://github.com/kiookp/exidian.git
    cd exidian

    # 创建新的 screen 窗口并运行程序
    screen -dmS exidian python3 app.py

    echo -e "${GREEN}程序已启动。您可以查看 screen 会话以查看日志。${NC}\n"
}

# 菜单
echo -e "${YELLOW}${BOLD}菜单：${NORMAL}${NC}"
echo -e "1. ${CYAN}安装环境${NC}"
echo -e "2. ${CYAN}配置账号信息${NC}"
echo -e "3. ${CYAN}运行程序${NC}"

read -p "${YELLOW}请输入您的选择（1-3）: ${NC}" choice
echo

case $choice in
    1) install_environment;;
(continued)

```bash
    2) configure_account;;
    3) run_program;;
    *) echo -e "${RED}无效的选择。退出。${NC}";;
esac
