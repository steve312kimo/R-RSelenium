install.packages("RSelenium")
library("RSelenium")
library("XML")
library('devtools')
install_github(repo = "crubba/Rwebdriver", username = "crubba")
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
remDr$navigate("https://travel.liontravel.com/search?DepartureID=&ArriveID=-51-9,&GoDateStart=2021-02-04&GoDateEnd=2021-03-06&Days=&IsEnsureGroup=false&IsSold=true&TravelType=1&GroupID=&Keywords=")
Sys.sleep(10)

#找出熱銷
hot.elem.list <- remDr$findElements(using = 'class name', value = "hot_Tag")
hot <- length(hot.elem.list)

#找出有幾筆資料
num.elem <- remDr$findElement(using = "id", value = "pcTotalCount")
num <- num.elem$getElementText()

#找出下一頁按鈕標籤
button <- remDr$findElement(using = 'class name', value = "next")

#製作空清單裝爬取結果
web.elem.list <- list()

repeat
{if (length(web.elem.list) == as.numeric(num[1]) + hot)
  {
  break
}else{
  button$clickElement()#點擊下一頁
  Sys.sleep(8)
  web.elem.list <- remDr$findElements(using = 'css selector', value = "div.rli_price a")
}
}

url <- unlist(lapply(web.elem.list, function(e) { e$getElementAttribute("href") }))

#製作空清單裝爬取結果
content1 <- list()
price1 <- list()

#利用迴圈抓取每一頁的主題與價格
for (i in 1:220){
  remDr$navigate(url[i])
  Sys.sleep(8)
  
  #主題抓取
  con.elem.list <- remDr$findElements(using = 'css selector', value = "div.content h1")
  t <-  lapply(con.elem.list, function(e) { e$getElementText() })
  content1 <- append(content1, t)
  
  #價格抓取
  pri.elem.list <- remDr$findElements(using = "css selector", value = "div.num span")
  p <- lapply(pri.elem.list, function(e) { e$getElementText() })
  price1 <- append(price1, p)
}

con <- unlist(content1)
pri <- unlist(price1)

x <- data.frame('主題' = con, '價格' = pri)
x
