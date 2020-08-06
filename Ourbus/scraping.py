from selenium import webdriver
from selenium.webdriver.chrome.options import Options

options = Options()
options.headless = True

# path to chrome driver executable, works for linux64, for other OS download executable file form
# https://sites.google.com/a/chromium.org/chromedriver/downloads
exec_path = './chromedriver'

#simulating chrome browser within 
driver = webdriver.Chrome(options=options, executable_path=exec_path)
driver.get("https://www.ourbus.com/booknow?origin=New%20York,%20NY&destination=Ithaca,%20NY&departure_date=07/24/2020&adult=1")

#click departure date table
driver.find_element_by_id('longdatepickerDepart').click()
#create a list of elements containing price for various data
elements_list = driver.find_elements_by_css_selector('td.day')

#select today day element and extract date and price
today = driver.find_element_by_css_selector('td.today.day').text.split()
date_today = int(today[0])
price_today = today[1]

price_list = []

# extracting prices for various dates from elements_list
for i in elements_list:
    day = i.text.split()
    if day == []:
        continue
    date = int(day[0])
    if date >= date_today:
        price_list.append((date, day[1]))

    if date == 10:
        break
print(price_list)
driver.quit()