library(ggplot2)
library(maptools)
library(leaflet)
library(car)
sdv <- read.csv("E:/workspace/IDE/Rworkspace/回归残差可视化/shandong_v1.csv")
#加载shp图层
poly <- readShapePoly("E:/workspace/IDE/Rworkspace/回归残差可视化/shp/shandong.shp")

sdv <- data.frame("id"=sdv$id,"市"=sdv$B,"县"=sdv$C,
                 "财政收入" = sdv$F,"工业总产值" = sdv$O,
                 "消费品零售额" = sdv$R,"总出口" = sdv$S,
                 "固定资产投资" = sdv$T)

#一元线性回归
sdlm = lm(sdv$'财政收入' ~ sdv$'工业总产值'+sdv$'消费品零售额'
          +sdv$'总出口'+sdv$'固定资产投资')
#查看统计信息
summary(sdlm)

#方差膨胀因子
vif(sdlm)

#系数柱状图
est <- sdlm$coefficients
estname <- names(est[2:5])
estnum <- unname(est[2:5])
qplot(estname,estnum,fill=estnum)+geom_bar(stat='identity')


#预测值和残差值
sdv$pre <- predict(sdlm)
sdv$res <- residuals(sdlm)
sdv$rsd <-unname(rstandard(sdlm))
View(sdv)

#分县残差柱状图
ggplot(sdv, aes(x = sdv$'县', y = sdv$res, fill = sdv$res),group=factor(1)) + 
  geom_bar(stat = "identity") +theme(axis.text.x  = element_text(angle=90, vjust=0.5))



#join数据
poly@data <- merge(poly@data, sdv, by.x = "JoinID", by.y = "id")

#leaflet可视化
pal <-colorNumeric(c("green", "white", "red"),poly@data$res)
leaflet(poly) %>% addTiles()%>%addProviderTiles("Esri.WorldTerrain")%>%
  addPolygons(color=~pal(poly@data$res),fillOpacity  = 0.8,weight=1)%>%
  addLegend(pal = pal, values = poly@data$res,position="bottomright",
            title = "残差")

#查看正向残差和负向残差的个数
length(sdv$res[sdv$res>0])
length(sdv$res[sdv$res<0])

poly@data$absres <- abs(poly@data$res)
pal <-colorNumeric(c("green", "white", "red"),poly@data$absres)
leaflet(poly) %>% 
  addPolygons(color=~pal(poly@data$absres),fillOpacity  = 0.8,weight=1)%>%
  addLegend(pal = pal, values = poly@data$absres,position="bottomright",
            title = "残差")


sdres <- sd(poly@data$res)
poly@data$ressd <-(poly@data$res - sdres) / sdres
pal <-colorNumeric(c("blue", "yellow", "red"),poly@data$ressd)
leaflet(poly) %>% 
  addPolygons(popup=~paste(poly@data$"市",poly@data$"县",
                           "</br>","残差=",poly@data$res,
                           "</br>","残差与标准差的倍数=",poly@data$ressd),
              color=~pal(poly@data$ressd),fillOpacity  = 1,weight=1)%>%
  addLegend(pal = pal, values = poly@data$ressd,position="bottomright",
            title = "残差与标准差的倍数")

pal <-colorNumeric(c("blue", "yellow", "red"),poly@data$rsd)
leaflet(poly) %>% 
  addPolygons(popup=~paste(poly@data$"市",poly@data$"县",
                           "</br>","残差=",poly@data$res,
                           "</br>","标准化残差=",poly@data$rsd),
              color=~pal(poly@data$rsd),fillOpacity  = 1,weight=1)%>%
  addLegend(pal = pal, values = poly@data$rsd,position="bottomright",
            title = "标准化残差")

