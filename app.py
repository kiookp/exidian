import time
import os
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.common.by import By
from selenium.webdriver.chrome.options import Options
import telebot
import undetected_chromedriver as uc
import configparser

config = configparser.ConfigParser()
config.read('config.ini')

telegram_bot_token = config['Credentials']['telegram_bot_token']
telegram_chat_id = config['Credentials']['telegram_chat_id']
website = config['Credentials']['website']
username = config['Credentials']['username']
password = config['Credentials']['password']

def send_telegram_message(bot, chat_id, message):
    try:
        bot.send_message(chat_id, message)
        print(f"消息已发送 ")
    except Exception as e:
        print(f"无法发送消息：{e}")

chrome_options = Options()
chrome_options.add_argument("--headless")
driver = uc.Chrome(options=chrome_options)
driver.get("https://" + website + "/")
print("成功打开网站")

wait = WebDriverWait(driver, 10)
uid_input = wait.until(EC.visibility_of_element_located((By.NAME, "uid")))

uid_input.clear()
uid_input.send_keys(username)

print("成功输入账号")

password_input = wait.until(EC.visibility_of_element_located((By.ID, "fakePassword")))

password_input.send_keys(password)
print("成功输入密码")

wait = WebDriverWait(driver, 20)
login_button = wait.until(
    EC.visibility_of_element_located((By.XPATH, "/html/body/div[3]/div[4]/div[3]/div[3]/div[1]/form/div[3]/button")))

login_button.click()

# 检查是否存在账号或密码错误的提示元素
error_label_locator = (By.XPATH, "//*[@id='warnOrErrDiv']/label")
success_element_locator = (By.XPATH, "/html/body/section/article")


time.sleep(3)
try:
    # 等待登录成功的元素出现
    wait.until(EC.visibility_of_element_located(success_element_locator))
    print("登录成功！")
    bot = telebot.TeleBot(telegram_bot_token)
    send_telegram_message(bot, telegram_chat_id, f"账号 {username}：登录成功！")

    cookies = driver.get_cookies()

    coremail_sid = None
    coremail = None

    for cookie in cookies:
        if cookie['name'] == 'Coremail.sid':
            coremail_sid = cookie['value']
        elif cookie['name'] == 'Coremail':
            coremail = cookie['value']

    print("Coremail.sid:", coremail_sid)
    print("Coremail:", coremail)
    print("uid:", username)
    print("开始保活...")
    send_telegram_message(bot, telegram_chat_id, "开始保活...")

    message = f"Coremail.sid: {coremail_sid}\nCoremail: {coremail}"
    send_telegram_message(bot, telegram_chat_id, message)

    while True:
        try:
            wait.until(EC.visibility_of_element_located((By.CSS_SELECTOR, "#mltree_2_span"))).click()
            time.sleep(60)

            wait.until(EC.visibility_of_element_located((By.CSS_SELECTOR, "#mltree_3_span"))).click()
            time.sleep(60)

            wait.until(EC.visibility_of_element_located((By.CSS_SELECTOR, "#mltree_4_span")))
            driver.refresh()
            time.sleep(10)

        except Exception as e:
            print("出现异常：", str(e))
            print("正在刷新页面...")
            driver.refresh()

except:
    # 如果存在账号或密码错误的提示元素，则表示登录失败
    if driver.find_elements(*error_label_locator):
        print("账号或密码错误，登录失败！")
        bot = telebot.TeleBot(telegram_bot_token)
        send_telegram_message(bot, telegram_chat_id, "账号或密码错误，登录失败！")
    else:
        print("登录失败！")
        bot = telebot.TeleBot(telegram_bot_token)
        send_telegram_message(bot, telegram_chat_id, "登录失败！")

driver.quit()
