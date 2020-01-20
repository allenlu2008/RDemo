#判定依赖包是否存在，如果不存在就进行安装
if (!requireNamespace("sp", quietly = TRUE))
  install.packages("sp")

if (!requireNamespace("maptools", quietly = TRUE))
  install.packages("maptools")

if (!requireNamespace("aspace", quietly = TRUE))
  install.packages("aspace")

if (!requireNamespace("rgdal", quietly = TRUE))
  install.packages("rgdal")

#加载依赖包
library("aspace")
library("sp")
library("maptools")
library("rgdal")

长短半轴之比

#数据存放的路径
path <- "D:\\workspace\\DevWork\\example\\GitRDemo\\RDemo\\009标准差椭圆\\SD\\"

#分点线面进行加载
pnt <- readOGR(paste(path,"伤寒.shp",sep =""))
poly1 <- readOGR(paste(path,"太湖流域.shp",sep =""))
poly2 <- readOGR(paste(path,"太湖流域河流.shp",sep =""))

#定义坐标系：

pnt <- spTransform(pnt,"+proj=longlat +datum=WGS84")
poly1 <- spTransform(poly1,"+proj=longlat +datum=WGS84")
poly2 <- spTransform(poly2,"+proj=longlat +datum=WGS84")


xy <- data.frame(pnt$coords.x1,pnt$coords.x2)
sde = calc_sde(id=1, filename=paste(path,"sdOut.txt",sep=""), centre.xy=NULL,calccentre=TRUE,weighted=FALSE, weights=NULL, points=xy, verbose=FALSE)
plot(poly1, axes=TRUE,col="#FFFFBE")
plot(poly2,col=rgb(red=151,green=219,blue = 241,max=255),add=T)
points(pnt,col="red",pch=20)
lines(sde$x,sde$y,col="blue",lwd=4)

##########################################
#
# 中心
#
##########################################

mmp <- mean_centre(id=1,filename="e:/output.txt",weighted=FALSE,weights=NULL,points=xy)
plot(poly1, axes=TRUE,col="#FFFFBE")
plot(poly2,col=rgb(red=151,green=219,blue = 241,max=255),add=T)
points(pnt,col="red",pch=20)
points(mmp$CENTRE.x,mmp$CENTRE.y,cex=3,col="green",pch=17)


###########################################
#
# 分组做标准差椭圆
#
###########################################

xy2000 <- data.frame(pnt$coords.x1[pnt$year==2000],pnt$coords.x2[pnt$year==2000])
xy2001 <- data.frame(pnt$coords.x1[pnt$year==2001],pnt$coords.x2[pnt$year==2001])
sde2000 = calc_sde(id=1, filename=paste(path,"sdOut2000.txt",sep=""), 
                   centre.xy=NULL,calccentre=TRUE,weighted=FALSE, 
                   weights=NULL, points=xy2000, verbose=FALSE)

sde2001 = calc_sde(id=1, filename=paste(path,"sdOut2001.txt",sep=""), 
                   centre.xy=NULL,calccentre=TRUE,weighted=FALSE, 
                   weights=NULL, points=xy2001, verbose=FALSE)

plot(poly1, axes=TRUE,col="#FFFFBE")
p2 <- slot(slot(poly2@polygons[[1]],"Polygons")[[1]],"coords")
polygon(p2[,1],p2[,2],col=rgb(red=151,green=219,blue = 241,max=255))
points(pnt,col="red",pch=20)
lines(sde2000$x,sde2000$y,col="blue",lwd=4)
lines(sde2001$x,sde2001$y,col="red",lwd=4)
