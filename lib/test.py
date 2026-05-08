from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
import time

driver = webdriver.Chrome()

driver.get("https://google.com")

time.sleep(2)

search = driver.find_element(By.NAME, "q")

search.send_keys("Selenium automation test")
time.sleep(1)

search.send_keys(Keys.RETURN)

time.sleep(5)

driver.quit()``