from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.chrome.service import Service
import time

EMAIL    = "usmansardar037@gmail.com"
PASSWORD = "uNimaginable$"
URL      = "https://accounts.google.com/signin/v2/identifier"
DRIVER   = r"C:\Users\Usman\chromedriver147\chromedriver.exe"

CHROME = r"C:\Program Files\Google\Chrome\Application\chrome.exe"

def run():
    opts = Options()
    opts.binary_location = CHROME
    opts.add_argument("--start-maximized")
    opts.add_experimental_option("excludeSwitches", ["enable-automation"])
    opts.add_experimental_option("useAutomationExtension", False)
    opts.add_argument("--disable-blink-features=AutomationControlled")

    service = Service(DRIVER)
    driver  = webdriver.Chrome(service=service, options=opts)
    wait    = WebDriverWait(driver, 15)

    try:
        driver.get(URL)

        # --- Email step ---
        email_field = wait.until(EC.visibility_of_element_located((By.ID, "identifierId")))
        email_field.clear()
        email_field.send_keys(EMAIL)
        driver.find_element(By.ID, "identifierNext").click()

        # --- Password step ---
        pwd_field = wait.until(EC.visibility_of_element_located(
            (By.CSS_SELECTOR, "input[type='password']")
        ))
        pwd_field.send_keys(PASSWORD)
        driver.find_element(By.ID, "passwordNext").click()

        time.sleep(6)

        # --- Validate ---
        current = driver.current_url
        if "myaccount.google.com" in current or "mail.google.com" in current:
            print("\n[PASS] Login successful — redirected to:", current)
        elif "challenge" in current or "signin" in current:
            print("\n[FAIL] Login blocked or failed — URL:", current)
        else:
            print("\n[INFO] Unexpected URL:", current)

    except Exception as e:
        print("\n[ERROR]", e)
    finally:
        time.sleep(3)
        driver.quit()

if __name__ == "__main__":
    run()
