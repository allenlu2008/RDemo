library(leaflet)

## 随机添加20个标记点
df = data.frame(
  latitude = runif(20,min=0,max=70),
  longitude = runif(20,min=0,max=160)
)
df%>%leaflet()%>%addTiles()%>% addMarkers()

## 添加北京三级及三级甲等医院位置信息
bj3H <- read.csv("D:\\workspace\\DevWork\\example\\GitRDemo\\RDemo\\0004Leaflet for R\\data\\bj3H.csv")
leaflet(bj3H)%>%addTiles()%>% addMarkers(popup=~mc)


## 自定义位置和显示字段
dh <- data.frame(x=bj3H$Longitude,y=bj3H$Latitude,mc=bj3H$mc)
leaflet(dh)%>%
  addTiles()%>%
  setView(116.4,39.9,zoom=10)%>%addMarkers(~x,~y,popup=~mc)


## 自定义图标（需要打开浏览器查看，RStudio某些版本的Viewer窗口看不见图标）
redIcon <- makeIcon(
  iconUrl = "http://img.blog.csdn.net/20161015170050664",
  iconWidth = 38, iconHeight = 38,
  iconAnchorX = 19, iconAnchorY = 19
)
leaflet(dh)%>%addTiles()%>%
  addMarkers(~x,~y,popup=~mc,icon = redIcon)

## 加载不同的自定义图标
redIcon1 <- makeIcon(
  iconUrl = "http://img.blog.csdn.net/20161015170050664",
  iconWidth = 38, iconHeight = 38,
  iconAnchorX = 19, iconAnchorY = 19
)

redIcon2 <- makeIcon(
  iconUrl = "http://img.blog.csdn.net/20161015173507516",
  iconWidth = 38, iconHeight = 38,
  iconAnchorX = 19, iconAnchorY = 19
)
leaflet()%>%addTiles()%>%
  addMarkers(data=bj3H[bj3H$dj=="三级",],popup=~mc,icon = redIcon1)%>%
  addMarkers(data=bj3H[bj3H$dj=="三级甲等",],popup=~mc,icon = redIcon2)

## 用ifelse语法加载不同的自定义图标
leafIcons <- icons(
  iconUrl = ifelse(bj3H$dj=="三级",
                   "http://img.blog.csdn.net/20161015170050664",
                   "http://img.blog.csdn.net/20161015173507516"
  ),
  iconWidth = 38, iconHeight = 38,
  iconAnchorX = 19, iconAnchorY = 19
  
)
leaflet(bj3H)%>%addProviderTiles("CartoDB.Positron")%>%
  addMarkers(popup=~mc,icon = leafIcons)


## 多种图标
yyIcons <- iconList(
  中国医科院所属医院 = makeIcon("http://img.blog.csdn.net/20161015181859390", iconWidth =32, iconHeight = 32),
  北京区县属医院 = makeIcon("http://img.blog.csdn.net/20161015182217958", iconWidth =32, iconHeight = 32),
  北京市卫生局直属医院= makeIcon("http://img.blog.csdn.net/20161015181915828",iconWidth =32, iconHeight = 32),
  北京中医药大学= makeIcon("http://img.blog.csdn.net/20161015181934175",iconWidth =32, iconHeight = 32),
  卫生部直属医院= makeIcon("http://img.blog.csdn.net/20161015181950879",iconWidth =32, iconHeight = 32),
  中国中医科学院= makeIcon("http://img.blog.csdn.net/20161015182031737",iconWidth =32, iconHeight = 32),
  驻京武警医院= makeIcon("http://img.blog.csdn.net/20161015182043285",iconWidth =32, iconHeight = 32),
  驻京部队医院= makeIcon("http://img.blog.csdn.net/20161015182054598",iconWidth =32, iconHeight = 32),
  部属厂矿高校医院= makeIcon("http://img.blog.csdn.net/20161015182109473",iconWidth =32, iconHeight = 32),
  北京大学附属医院= makeIcon("http://img.blog.csdn.net/20161015182132521",iconWidth =32, iconHeight = 32)
)

leaflet(bj3H) %>%addTiles() %>%
  addMarkers(icon = ~yyIcons[fl],popup=~fl)

## 随比例尺聚合显示
leaflet(bj3H) %>%addProviderTiles("CartoDB.Positron") %>%
  addMarkers(clusterOptions = markerClusterOptions(),icon = ~yyIcons[fl],popup=~fl)

## 绘制圆形
leaflet(bj3H) %>%addProviderTiles("CartoDB.Positron")%>%addCircles()

## 散点专题图
leaflet(bj3H) %>%addProviderTiles("CartoDB.Positron")%>%addCircles(color="red",weight=bj3H$ks/2)

## 镶边的圆形
leaflet(bj3H) %>%addProviderTiles("CartoDB.Positron")%>%addCircleMarkers()

leaflet(bj3H) %>%addProviderTiles("CartoDB.Positron")%>%addCircleMarkers(color="red",weight=bj3H$ks/2)

## 分类绘制圆圈
leaflet()%>%addTiles()%>%addProviderTiles("CartoDB.Positron")%>%
  addCircles(data=bj3H[bj3H$dj=="三级",],popup=~mc,color="green")%>%
  addCircles(data=bj3H[bj3H$dj=="三级甲等",],popup=~mc,color="red")

## 分类绘制镶边圆圈
leaflet()%>%addTiles()%>%addProviderTiles("CartoDB.Positron")%>%
  addCircleMarkers(data=bj3H[bj3H$dj=="三级",],popup=~mc,color="green")%>%
  addCircleMarkers(data=bj3H[bj3H$dj=="三级甲等",],popup=~mc,color="red")

## 预设分类绘制
pal <- colorFactor(c("green", "red"), domain = c("三级", "三级甲等"))
leaflet(bj3H) %>% addProviderTiles("CartoDB.Positron") %>%
  addCircleMarkers(color = ~pal(dj),stroke = FALSE,fillOpacity = 0.7)


## 颜色分类专题图
cPal <- colorNumeric(palette = c("blue","yellow","red"),domain = bj3H$cws)
leaflet(bj3H) %>% addProviderTiles("CartoDB.Positron") %>%
  addCircleMarkers(fillColor = ~cPal(bj3H$cws),
                   stroke = FALSE,fillOpacity = 0.8,popup=~as.character(cws))%>%
  addLegend("bottomright", pal = cPal, 
            values = ~cws,title = "床位数",
            labFormat = labelFormat(suffix = "张"),opacity = 1)