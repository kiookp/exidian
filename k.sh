#!/bin/bash --posix

# 定义一些颜色和格式化选项
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color
BOLD=$(tput bold)
NORMAL=$(tput sgr0)

# 检查必要的命令是否存在
REQUIRED_CMDS=("wget" "apt-get" "pip")

# 检查必要的命令是否存在
REQUIRED_CMDS=("wget" "pip")

for cmd in "${REQUIRED_CMDS[@]}"; do
    if ! command -v $cmd &> /dev/null; then
        echo -e "${RED}错误：$cmd 命令不存在。请安装它后再运行这个脚本。${NC}"
        exit 1
    fi
done

# 检查系统类型
detect_system() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        SYSTEM=$ID
    elif type lsb_release >/dev/null 2>&1; then
        SYSTEM=$(lsb_release -si)
    else
        echo -e "${RED}错误：无法检测到系统类型。请手动安装依赖并运行脚本。${NC}"
        exit 1
    fi
}

# 安装环境 - CentOS
install_environment_centos() {
    echo -e "${YELLOW}${BOLD}安装环境 - CentOS${NORMAL}${NC}"
    yum -y update
    yum install -y google-chrome-stable
    yum install -y unzip screen

    # 下载 Chromedriver
    CHROME_VERSION=$(google-chrome-stable --version | awk '{print $3}' | awk -F. '{print $1}')
    CHROMEDRIVER_VERSION=$(curl -sS chromedriver.storage.googleapis.com/LATEST_RELEASE_$CHROME_VERSION)
    wget -O /tmp/chromedriver.zip http://chromedriver.storage.googleapis.com/$CHROMEDRIVER_VERSION/chromedriver_linux64.zip
    unzip /tmp/chromedriver.zip chromedriver -d /usr/local/bin/

    echo -e "${GREEN}环境安装完成。${NC}\n"
}

# 安装环境 - Debian/Ubuntu
install_environment_debian() {
    echo -e "${YELLOW}${BOLD}安装环境 - Debian/Ubuntu${NORMAL}${NC}"
    apt-get -y update
    apt-get install -y google-chrome-stable
    apt-get install -yqq unzip screen

    # 下载 Chromedriver
    CHROME_VERSION=$(google-chrome-stable --version | awk '{print $3}' | awk -F. '{print $1}')
    CHROMEDRIVER_VERSION=$(curl -sS chromedriver.storage.googleapis.com/LATEST_RELEASE_$CHROME_VERSION)
    wget -O /tmp/chromedriver.zip http://chromedriver.storage.googleapis.com/$CHROMEDRIVER_VERSION/chromedriver_linux64.zip
    unzip /tmp/chromedriver.zip chromedriver -d /usr/local/bin/

    echo -e "${GREEN}环境安装完成。${NC}\n"
}

# 安装环境
install_environment() {
    detect_system

    case $SYSTEM in
        "centos")
            install_environment_centos;;
        "debian" | "ubuntu")
            install_environment_debian;;
        *)
            echo -e "${RED}错误：不支持的系统类型。请手动安装依赖并运行脚本。${NC}"
            exit 1;;
    esac
}



# 配置账号信息
configure_account() {
    echo -e "${YELLOW}${BOLD}配置账号信息${NORMAL}${NC}"
    read -p "请输入 Telegram Bot Token: " telegram_bot_token
    read -p "请输入 Telegram Chat ID: " telegram_chat_id
    read -p "请输入网站(带https://): " website
    read -p "请输入用户名: " username
    read -sp "请输入密码: " password
    echo

    # 将配置写入文件
    echo -e "[Credentials]\ntelegram_bot_token = $telegram_bot_token\ntelegram_chat_id = $telegram_chat_id\nwebsite = $website\nusername = $username\npassword = $password" > config.ini

    echo -e "${GREEN}账号配置完成。${NC}\n"
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

# 结束程序
stop_program() {
    echo -e "${YELLOW}${BOLD}结束程序${NORMAL}${NC}"
    # 结束 screen 会话（如果存在）
    screen -S exidian -X quit

    echo -e "${GREEN}程序已结束。${NC}\n"
}


# 菜单
while true; do
    echo -e "${YELLOW}${BOLD}菜单：${NORMAL}${NC}"
    echo -e "1. ${CYAN}安装环境${NC}"
    echo -e "2. ${CYAN}配置账号信息${NC}"
    echo -e "3. ${CYAN}运行程序${NC}"
    echo -e "4. ${CYAN}结束程序${NC}"
    echo -e "5. ${CYAN}退出${NC}"

    read -p "请输入您的选择（1-5）: " choice
    echo

    case $choice in
        1) install_environment;;
        2) configure_account;;
        3) run_program;;
        4) stop_program;;
        5) echo -e "${GREEN}退出。${NC}"; exit 0;;
        *) echo -e "${RED}无效的选择。${NC}";;
    esac
done
