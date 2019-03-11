library(leaflet)
library(rgdal)

path <- "D:\\workspace\\DevWork\\example\\GitRDemo\\RDemo\\0004Leaflet for R\\data\\"


## 人口数量专题图，黄绿红色带配色
poly <- readShapePoly(paste(path,"china/CNPG_S.shp",sep =""))
pal <- colorNumeric(c("darkgreen", "yellow", "orangered"),poly@data$Pop_2009)
leaflet(poly) %>% addTiles() %>%
  addPolygons(color=~pal(poly@data$Pop_2009),fillOpacity  = 0.8,weight=1)%>%
  addLegend(pal = pal, values = poly@data$Pop_2009,position="bottomright",
            title = "2009年人口数量（万人）")

## 人口数量专题图，绿色带配色
pal <- colorNumeric("Greens",poly@data$Pop_2009)
leaflet(poly) %>% addTiles() %>%
  addPolygons(color=~pal(poly@data$Pop_2009),fillOpacity  = 0.8,weight=1)%>%
  addLegend(pal = pal, values = poly@data$Pop_2009,position="bottomright",
            title = "2009年人口数量（万人）")

## 人口分级专题图，黄绿红色带配色
pal <- colorBin(c("darkgreen", "yellow", "orangered"),poly@data$Pop_2009,10)
leaflet(poly) %>% addTiles() %>%
  addPolygons(color=~pal(poly@data$Pop_2009),fillOpacity  = 0.8,weight=1)%>%
  addLegend(pal = pal, values = poly@data$Pop_2009,position="bottomright",
            title = "2009年人口数量分级")

## 人口分级专题图，绿色带配色
pal <- colorBin("Greens",poly@data$Pop_2009,10)
leaflet(poly) %>% addTiles() %>%
  addPolygons(color=~pal(poly@data$Pop_2009),fillOpacity  = 0.8,weight=1)%>%
  addLegend(pal = pal, values = poly@data$Pop_2009,position="bottomright",
            title = "2009年人口数量分级")


## 图例设置
pal <- colorNumeric("Greens",poly@data$Pop_2009)
leaflet(poly) %>% addTiles() %>%
  addPolygons(color=~pal(poly@data$Pop_2009),fillOpacity  = 0.8,weight=1)%>%
  addLegend(pal = pal, values = poly@data$Pop_2009,
            title = "2009年人口数量（万人）</br>默认，右上角")%>%
  addLegend(pal = pal, values = poly@data$Pop_2009,bins=5,position="bottomleft",
            title = "2009年人口数量（万人）</br>图例分级五级，左下角")%>%
  addLegend(pal = pal, values = poly@data$Pop_2009,position="topleft",
            labFormat = labelFormat(suffix = " 万"),
            title = "2009年人口数量（万人）</br>加单位，左上角")%>%
  addLegend(pal = pal, values = poly@data$Pop_2009,position="bottomright",
            opacity = 1,
            title = "2009年人口数量（万人）</br>色带条不透明，右下角")
