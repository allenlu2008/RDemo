# Leaflet for R 示例

<font size=4>

## 判定leaflet for R包是否已经安装，如果没有安装，则进行安装
'''
if (!requireNamespace("leaflet", quietly = TRUE))
  install.packages("leaflet")

library(leaflet)
'''

## 显示北京
m <- leaflet()
at <- addTiles(m)
addMarkers(at,lng=116.391, lat=39.912, popup="这里是北京")


## 管道操作符
leaflet()%>%addTiles()%>%addMarkers(lng=116.391, lat=39.912, popup="这里是北京")


## 设定地图中心和初始缩放级别
leaflet()%>%setView(lng=116.38,lat=39.9,zoom=9)%>%addTiles()

## 绘制100个随机点
df = data.frame(Lat = rnorm(100), Lon = rnorm(100))
df %>%leaflet()%>%addCircles()

## 用彩虹色带，在亚洲范围内绘制100个环
df = data.frame(
  lat = runif(100,min=0,max=70),
  lng = runif(100,min=0,max=160),
  size = runif(100, 5, 10),
  co = substr(rainbow(100),1,7)
)
df%>%leaflet()%>%addTiles()%>%
  addCircleMarkers(lng=~lng,lat=~lat,radius = ~size, color = ~co, fill = TRUE)

## 利用maps包里面的数据绘制不同颜色的美国各州地图
if (!requireNamespace("maps", quietly = TRUE))
  install.packages("maps")
library(maps)
mapStates = map("state", fill = TRUE, plot = FALSE)
leaflet(data = mapStates) %>% addTiles() %>%
  addPolygons(fillColor = topo.colors(10, alpha = NULL), stroke = FALSE)

## 绘制Shape file的多边形
library(maptools)
library(rgdal)
path <- "D:\\workspace\\DevWork\\example\\GitRDemo\\RDemo\\0004Leaflet for R\\data\\china\\"
poly <- readShapePoly(paste(path,"CNPG_S.shp",sep =""))

### 转换字符编码
poly$FIRST_NAME = iconv(poly$FIRST_NAME,"UTF8","CP936")

## 绘制全国，并且以省的名字为弹出窗
leaflet(poly)%>%addTiles()%>%addPolygons(popup=~FIRST_NAME,
                                         fillColor = topo.colors(10, alpha = NULL), 
                                         stroke = FALSE)

## 绘制中国以“南”结尾的省
d =poly[substr(poly$FIRST_NAME,2,2)=="南",]
d%>%leaflet()%>%addTiles()%>%addPolygons(popup=~FIRST_NAME
                                         ,fillColor = topo.colors(5, alpha = NULL), 
                                         stroke = FALSE)


</font>