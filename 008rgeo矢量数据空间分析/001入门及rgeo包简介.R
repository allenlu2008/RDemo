library(rgeos)
library(sp)
library(rgdal)

path <- "D:\\workspace\\DevWork\\example\\GitRDemo\\RDemo\\008rgeo矢量数据空间分析\\data\\beijing\\"
crs <-  CRS("+init=epsg:4326")

#加载并且绘制出北京行政区划
beijing <- readOGR(paste(path,"beijing.shp",sep =""))
proj4string(spTransform(beijing, crs))
plot(beijing,axes=TRUE,col="#FFFFBE")

#生成随机点
pntdf = data.frame(
  lng= runif(1000,min=115.5,max=117.5),
  lat = runif(1000,min=39.5,max=41),
  id = 1:1000,
  flag = rep(0,1000)
)
pnt <- SpatialPointsDataFrame(pntdf,data = pntdf,proj4string=crs)

#把点绘制上去
points(pnt,pch=20,cex=0.8)


#绘制tianandoor的位置为中心
ctpnt = SpatialPoints(data.frame(lon=c(116.391),lat=c(39.906)),
                      proj4string= crs)
points(ctpnt,pch=18,cex=2,col="red")

#以这个中心点，绘制一个0.2度缓冲区
ctbf <- gBuffer(ctpnt,id=1,width = 0.2,quadsegs=10)
ctbfxy <- slot(slot(ctbf@polygons[[1]],"Polygons")[[1]],"coords")
lines(x=ctbfxy[,1],y=ctbfxy[,2],col="blue",lwd=3)

#遍历所有的点，查找包含的点（不建议的低效率方法）
for (n in 1:length(pnt)){
  temppnt = SpatialPoints(data.frame(x=pnt@coords[n,1],
                                     y=pnt@coords[n,2]),
                          proj4string= crs)
  if(gIntersects(temppnt,ctbf)){
    pnt@data$flag[n]<- 1
  }
}
selPnt <- subset(pnt,pnt@data$flag==1)
points(selPnt,pch=3,col="red")

#线缓冲以及查询
bjline = Lines(list(Line(cbind(c(115.8,116,116.3,117.2),
                               c(41,39.7,40.3,39.8)))),ID = "1")
sline = SpatialLines(list(bjline),proj4string=crs) 
lineBF = gBuffer(sline,width = 0.2)
pnt@data$flag[] <-0
for (n in 1:length(pnt)){
  temppnt = SpatialPoints(data.frame(x=pnt@coords[n,1],
                                     y=pnt@coords[n,2]),
                          proj4string= crs)
  if(gIntersects(temppnt,lineBF)){
    pnt@data$flag[n]<- 1
  }
}
selPnt <- subset(pnt,pnt@data$flag==1)

plot(beijing,axes=TRUE,col="#FFFFBE")
points(pnt,pch=20,cex=0.8)
lines(sline,lwd=3,col="blue")
bl = slot(slot(lineBF@polygons[[1]],"Polygons")[[1]],"coords")
lines(x=bl[,1],y=bl[,2],col="red",lwd=2)
points(selPnt,pch=3,col="red")



library(dplyr)
f <- function(x,y){
  temppnt = SpatialPoints(data.frame(x=x,
                                     y=y),
                          proj4string= crs)
  return(gIntersects(temppnt,lineBF))
}
system.time(filter(pnt@data,f(lng,lat)))


