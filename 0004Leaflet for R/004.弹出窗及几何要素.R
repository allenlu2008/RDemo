library(leaflet)

## 弹出窗示例
tiananm <- paste("<p>","天安门，坐落在中华人民共和国首都北京市的中心、
                 故宫的南端，与天安门广场以及人民英雄纪念碑、毛主席纪念堂、
                 人民大会堂、中国国家博物馆隔长安街相望，占地面积4800平方米，
                 以杰出的建筑艺术和特殊的政治地位为世人所瞩目。","</p>",
                 "<a href='http://www.tiananmen.org.cn/index.htm'>点击查看更多</a>",
                 "<p><img src='http://img.blog.csdn.net/20161016004301807' width='50%'></p>",
                 "<p><img src='http://img.blog.csdn.net/20161016005048911' width='50%'></p>"
)
leaflet()%>%addTiles()%>%addMarkers(lng=116.391, lat=39.906, popup=tiananm)

bj3H <- read.csv("D:\\workspace\\DevWork\\example\\GitRDemo\\RDemo\\0004Leaflet for R\\data\\bj3H.csv")

pop <- paste("名称：",bj3H$mc,"<br/>",
             "等级：",bj3H$dj,"<br/>",
             "分类：",bj3H$fl,"<br/>",
             "科室数目：",bj3H$fl,"<br/>",
             "地址：",bj3H$dizhi1,"<br/>",
             "简介：",bj3H$jj,"<br/>",
             "标记<img src='",bj3H$hb,"' width='100%'/><br/>"
)
leaflet(bj3H)%>%addTiles()%>%addMarkers(popup=pop)

library(rgdal)
path <- "D:\\workspace\\DevWork\\example\\GitRDemo\\RDemo\\0004Leaflet for R\\data\\"


## 绘制超级马里奥
ma <- readShapePoly(paste(path,"Mario\\ma.shp",sep =""))
pal <- colorFactor(c("#DB231F", "#91462E","#0F0217","#F6C597","#5454D7"), domain = c("A", "B","C","D","E"))
leaflet(ma) %>% addTiles() %>%
  addPolygons(color = ~pal(Co),stroke = FALSE,fillOpacity = 0.9)

## 绘制北京的高速和主干道
bmr <- readShapeLines(paste(path,"bjline\\bjMainRoad.shp",sep =""))
pal <- colorFactor(c("green", "red"), domain = c("0x01", "0x02"))
leaflet(bmr) %>% addTiles() %>%
  addPolylines(color=~pal(bmr$MP_TYPE))


## 绘制矩形
leaflet() %>%addTiles() %>%
  addRectangles(
    lng1=116.1, lat1=39.7,
    lng2=116.63, lat2=40.1,
    weight = 3,color = "red",fillColor = "transparent",
    opacity = 1,popup="这里是北京"
  )



