library("RSelenium")
library("XML")
#library(devtools) 
#install_github(repo = "crubba/Rwebdriver", username = "crubba") 
library("Rwebdriver")
library("seleniumPipes")
library('rvest')

# 連接 Selenium 伺服器，選用 chrome 瀏覽器
remDr <- remoteDriver(
  remoteServerAddr = "localhost",
  port = 4444,
  browserName = "chrome")
remDr$open()

# 瀏覽 雄獅 首頁
remDr$navigate("https://travel.liontravel.com/detail?NormGroupID=ec15d8d2-c016-4fce-a98c-b63c4ecb408d&GroupID=21TN222SKU-T")
#https://travel.liontravel.com/search?DepartureID=&ArriveID=-51-9,&GoDateStart=2020-12-28&GoDateEnd=2021-01-27&Days=&IsEnsureGroup=false&IsSold=true&TravelType=1&GroupID=&Keywords=

#擷取旅遊主題
con.elem.list <- remDr$findElements(using = 'css selector', value = "div.content h1")
t <-  unlist(lapply(con.elem.list, function(e) { e$getElementText() }))

#擷取價格
pri.elem.list <- remDr$findElements(using = "css selector", value = "div.num span")
p <- unlist(lapply(pri.elem.list, function(e) { e$getElementText() }))

#整合主題與價格
x <- data.frame('主題' = t, '價格' = p)
x


remDr$navigate("https://travel.liontravel.com/search?DepartureID=&ArriveID=-51-9,&GoDateStart=2021-02-04&GoDateEnd=2021-03-06&Days=&IsEnsureGroup=false&IsSold=true&TravelType=1&GroupID=&Keywords=")
# https://travel.liontravel.com/detail?NormGroupID=ec15d8d2-c016-4fce-a98c-b63c4ecb408d&GroupID=21TN222SKU-T
#找出所有連結(單頁)
web.elem.list <- remDr$findElements(using = 'css selector', value = "div.rli_price a")
url <- unlist(lapply(web.elem.list, function(e) { e$getElementAttribute("href") }))

