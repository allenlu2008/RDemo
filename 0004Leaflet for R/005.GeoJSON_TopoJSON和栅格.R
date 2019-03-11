library(leaflet)
library(jsonlite)

path <- "D:\\workspace\\DevWork\\example\\GitRDemo\\RDemo\\0004Leaflet for R\\data\\"

## 利用GeoJSON绘制
geoData <- readLines(paste(path,"china.json",sep =""),warn=FALSE) %>% 
  paste(collapse = "\n")%>%fromJSON(simplifyVector = FALSE)
geoData$style = list(
  weight = 1,
  color ="red",
  fillColor="green",
  opacity = 1,
  fill = TRUE,
  fillOpacity = 0.6
)
leaflet() %>% setView(lng = 98.583, lat = 39.833, zoom = 3) %>%
  addProviderTiles("Stamen.Toner")%>%addGeoJSON(geoData)


geoData$style = list(
  weight = 1,
  color ="gray",
  opacity = 1,
  fill = TRUE,
  fillOpacity = 0.6
)

## 唯一值颜色专题图
pal <- substr(rainbow(34),1,7)
i<-0
geoData$features <- lapply(geoData$features, function(feat) {
  i<<-i+1
  feat$properties$style <- list(
    fillColor = pal[i]
  )
  feat
})
leaflet() %>% setView(lng = 98.583, lat = 39.833, zoom = 3) %>%
  addProviderTiles("Stamen.Toner")%>%addGeoJSON(geoData)


## GeoJSON的数据的GDP色彩专题图
geoData2 <- readLines(paste(path,"china_pop_gdp.json",sep =""),warn=FALSE) %>% 
  paste(collapse = "\n")%>%fromJSON(simplifyVector = FALSE)
geoData2$style = list(
  weight = 2,
  color ="gray",
  opacity = 1,
  fill = TRUE,
  fillOpacity = 0.9
)
GDP_2009 <- sapply(geoData2$features, function(feat) {
  feat$properties$GDP_2009
})

pal <- colorNumeric(c("blue", "white", "darkgreen", "yellow", "orangered"), GDP_2009)
geoData2$features <- lapply(geoData2$features, function(feat) {
  feat$properties$style <- list(
    fillColor = pal(feat$properties$GDP_2009)
  )
  feat
})
leaflet() %>% setView(lng = 98.583, lat = 39.833, zoom = 3) %>%
  addProviderTiles("Stamen.Toner")%>%addGeoJSON(geoData2)%>%
  addLegend("bottomright", pal = pal, values = GDP_2009,title = "2009年GDP总量")


## 人均GDP专题图
geoData2 <- readLines(paste(path,"china_pop_gdp.json",sep =""),warn=FALSE) %>% 
  paste(collapse = "\n")%>%fromJSON(simplifyVector = FALSE)
geoData2$style = list(
  weight = 2,
  color ="gray",
  opacity = 1,
  fill = TRUE,
  fillOpacity = 0.9
)
GDP_2009 <- sapply(geoData2$features, function(feat) {
  feat$properties$GDP_2009
})
POP_2009 <- sapply(geoData2$features, function(feat) {
  feat$properties$Pop_2009
})

pal <- colorNumeric("Greens", (GDP_2009*10000)/max(1,POP_2009))
geoData2$features <- lapply(geoData2$features, function(feat) {
  feat$properties$style <- list(
    fillColor = pal((feat$properties$GDP_2009*10000)/max(1,feat$properties$Pop_2009))
  )
  feat
})
leaflet() %>% setView(lng = 98.583, lat = 39.833, zoom = 3) %>%
  addProviderTiles("Stamen.Toner")%>%addGeoJSON(geoData2)%>%
  addLegend("bottomright", pal = pal,value =(GDP_2009*10000)/(max(1,POP_2009)),
            title = "2009年人均GDP（万元）")

## 栅格数据

## netCDF
library(raster)
r <- raster(paste(path,"raster/YSUZ98_KWBN_201312130055-var0-z0-rt0-t0.nc",sep =""))
pal <- colorNumeric(c("transparent",topo.colors(100,alpha = NULL)), values(r),
                    na.color = "transparent")
leaflet() %>% addTiles() %>%
  addRasterImage(r, colors = pal, opacity = 0.8) %>%
  addLegend(pal = pal, values = values(r),
            title = "USA Snow 2013-12-13")

## tif栅格数据

r <- raster(paste(path,"raster/flow.tif",sep =""))
pal <- colorNumeric(c("transparent",topo.colors(20,alpha = NULL)), values(r),
                    na.color = "transparent")
leaflet() %>% addTiles() %>%
  addRasterImage(r, colors = pal, opacity = 0.8) %>%
  addLegend(pal = pal, values = values(r),position="bottomleft",
            title = "北京交通主干道车流密度分析")
