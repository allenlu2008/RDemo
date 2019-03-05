#判定各种包是否安装了，没有安装就去安装
if (!requireNamespace("sp", quietly = TRUE))
  install.packages("sp")

if (!requireNamespace("maptools", quietly = TRUE))
  install.packages("maptools")

if (!requireNamespace("spdep", quietly = TRUE))
  install.packages("spdep")

library("sp")
library("maptools")
library("spdep")

path <- "E:\\workspace\\IDE\\Rworkspace\\空间分析\\空间权重矩阵\\china\\"

#将中国的省级行政区划读取为ploygon,省会读取成point
cnData <- readShapePoly(paste(path,"CNPG_S.shp",sep =""))
ctData <- readShapePoints(paste(path,"city_SH.shp",sep =""))
#定义投影为wgs84
proj4string(cnData) <- "+proj=longlat +datum=WGS84"
proj4string(ctData) <- "+proj=longlat +datum=WGS84"
#定义唯一标识符，用行政区划的编码
IDs <- ctData@data$ADCODE99
#将名称转换为gbk编码
ctData$NAME <- iconv(ctData$NAME,"UTF-8","GBK")
plot(cnData,border="grey")
plot(ctData,pch=19,cex=1,col='red',add=T)
text(ctData@coords[,1],ctData@coords[,2]+1,labels = ctData$NAME)

par(mfrow=c(3,2),mar=c(1,1,1,0))
#定义k临近关系,k=2：
kn1 <- knearneigh(ctData, k=2)
w_kn1 <- knn2nb(kn1, row.names=IDs)
w_kn1_mat <- nb2listw(w_kn1)
plot(cnData,border="grey")
plot(ctData,pch=19,cex=1,col='red',add=T)
plot(w_kn1_mat,ctData@coords,add=T,col='blue')
text(ctData@coords[,1],ctData@coords[,2]+1,labels = ctData$NAME)
title("K临近，K=2")

#定义k临近关系,k=3：
kn2 <- knearneigh(ctData, k=3)
w_kn2 <- knn2nb(kn2, row.names=IDs)
w_kn2_mat <- nb2listw(w_kn2)
plot(cnData,border="grey")
plot(ctData,pch=19,cex=1,col='red',add=T)
plot(w_kn2_mat,ctData@coords,add=T,col='blue')
text(ctData@coords[,1],ctData@coords[,2]+1,labels = ctData$NAME)
title("K临近，K=3")

#定义k临近关系,k=5：
kn3 <- knearneigh(ctData, k=5)
w_kn3 <- knn2nb(kn3, row.names=IDs)
w_kn3_mat <- nb2listw(w_kn3)
plot(cnData,border="grey")
plot(ctData,pch=19,cex=1,col='red',add=T)
plot(w_kn3_mat,ctData@coords,add=T,col='blue')
text(ctData@coords[,1],ctData@coords[,2]+1,labels = ctData$NAME)
title("K临近，K=5")

#定义k临近关系,k=7：
kn4 <- knearneigh(ctData, k=7)
w_kn4 <- knn2nb(kn4, row.names=IDs)
w_kn4_mat <- nb2listw(w_kn4)
plot(cnData,border="grey")
plot(ctData,pch=19,cex=1,col='red',add=T)
plot(w_kn4_mat,ctData@coords,add=T,col='blue')
text(ctData@coords[,1],ctData@coords[,2]+1,labels = ctData$NAME)
title("K临近，K=7")

#定义k临近关系,k=15：
kn5 <- knearneigh(ctData, k=15)
w_kn5 <- knn2nb(kn5, row.names=IDs)
w_kn5_mat <- nb2listw(w_kn5)
plot(cnData,border="grey")
plot(ctData,pch=19,cex=1,col='red',add=T)
plot(w_kn5_mat,ctData@coords,add=T,col='blue')
text(ctData@coords[,1],ctData@coords[,2]+1,labels = ctData$NAME)
title("K临近，K=15")

#定义k临近关系,k=33：
kn6 <- knearneigh(ctData, k=length(ctData)-1)
w_kn6 <- knn2nb(kn6, row.names=IDs)
w_kn6_mat <- nb2listw(w_kn6)
plot(cnData,border="grey")
plot(ctData,pch=19,cex=1,col='red',add=T)
plot(w_kn6_mat,ctData@coords,add=T,col='blue')
text(ctData@coords[,1],ctData@coords[,2]+1,labels = ctData$NAME)
title("K临近，K=33")

k <- c(2,3,5,6,10,31)
par(mfrow=c(3,2),mar=c(1,1,1,0))
cnMap <- coordinates(cnData)
for(ki in k){
  print(ki)
  knx <- knearneigh(cnMap, k=ki)
  IDs <- cnData$Code
  w_knx <- knn2nb(knx, row.names=IDs)
  w_knx_mat <- nb2listw(w_knx)
  plot(cnData,border="grey")
  plot(w_knx_mat,cnMap,add=T,col='blue')
  title(paste("K临近，K=",ki))
}

