####
# 判定leaflet for R包是否已经安装，如果没有安装，则进行安装
####
if (!requireNamespace("leaflet", quietly = TRUE))
  install.packages("leaflet")

library(leaflet)

###
# 显示北京
# img/1.png
###

m <- leaflet()
at <- addTiles(m)
addMarkers(at,lng=116.391, lat=39.912, popup="这里是北京")

