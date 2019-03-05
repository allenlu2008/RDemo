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

#将中国的省级行政区划读取为ploygon
cnData <- readShapePoly(paste(path,"CNPG_S.shp",sep =""))
#定义投影为wgs84
proj4string(cnData) <- "+proj=longlat +datum=WGS84"
#定义唯一标识符，用省级行政区划的编码
IDs <- cnData@data$Code
#将名称转换为gbk编码
cnData$FIRST_NAME <- iconv(cnData$FIRST_NAME,"UTF-8","GBK")

#获取每个面状要素的中心点
map_crd <- coordinates(cnData)
#绘制面要素和各省面要素的中心点
plot(cnData)
points(map_crd,col='red',pch='*')#判定各种包是否安装了，没有安装就去安装
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

#将中国的省级行政区划读取为ploygon
cnData <- readShapePoly(paste(path,"CNPG_S.shp",sep =""))
#定义投影为wgs84
proj4string(cnData) <- "+proj=longlat +datum=WGS84"
#定义唯一标识符，用省级行政区划的编码
IDs <- cnData@data$Code
#将名称转换为gbk编码
cnData$FIRST_NAME <- iconv(cnData$FIRST_NAME,"UTF-8","GBK")

#获取每个面状要素的中心点
map_crd2 <- coordinates(cnData2)
#绘制面要素和各省面要素的中心点
plot(cnData2)
points(map_crd,col='red',pch='*')

par(mfrow=c(3,2),mar=c(0,0,1,0))

#不同范围：
#1、默认范围（触点连接）
w_cn1 <- poly2nb(cnData, queen=T)
plot(cnData)
points(map_crd,col='red',pch='*')
plot(nb2listw(w_cn1,zero.policy=TRUE),coords=coordinates(cnData), cex=0.1, col="blue", add=T)
title("默认范围（触点连接）")

#2、1度范围（约108公里）
w_cn2 <- poly2nb(cnData, queen=T,snap = 1)
plot(cnData)
points(map_crd,col='red',pch='*')
plot(nb2listw(w_cn2,zero.policy=TRUE),coords=coordinates(cnData), cex=0.1, col="blue", add=T)
title("1度范围（约108公里）")


#3、2度范围（约210公里）
w_cn3 <- poly2nb(cnData, queen=T,snap = 2)
plot(cnData)
points(map_crd,col='red',pch='*')
plot(nb2listw(w_cn3,zero.policy=TRUE),coords=coordinates(cnData), cex=0.1, col="blue", add=T)
title("2度范围（约210公里）")

#4、3度范围（约320公里）
w_cn4 <- poly2nb(cnData, queen=T,snap = 3)
plot(cnData)
points(map_crd,col='red',pch='*')
plot(nb2listw(w_cn4,zero.policy=TRUE),coords=coordinates(cnData), cex=0.1, col="blue", add=T)
title("3度范围（约320公里）")

#5、10度范围（约1000公里）
w_cn5 <- poly2nb(cnData, queen=T,snap = 10)
plot(cnData)
points(map_crd,col='red',pch='*')
plot(nb2listw(w_cn5,zero.policy=TRUE),coords=coordinates(cnData), cex=0.1, col="blue", add=T)
title("10度范围（约1000公里）")

#6、30度范围（约3000公里）
w_cn6 <- poly2nb(cnData, queen=T,snap = 30)
plot(cnData)
points(map_crd,col='red',pch='*')
plot(nb2listw(w_cn6,zero.policy=TRUE),coords=coordinates(cnData), cex=0.1, col="blue", add=T)
title("30度范围（约3000公里）")

#反距离权重
#自定义台湾与广东、福建、浙江三个省位临近要素
#自定义海南与广东广西为临近要素
w_cn <- poly2nb(cnData, queen=T)
w_cn[[hainan]] <- c(as.integer(guangdong),as.integer(guangxi))
w_cn[[taiwan]] <- c(as.integer(guangdong),as.integer(fujian),as.integer(zhejiang))
w_cn[[fujian]] <- c(w_cn[[fujian]],c(as.integer(taiwan)))
w_cn[[guangdong]] <- c(w_cn[[guangdong]],c(as.integer(hainan),as.integer(taiwan)))
w_cn[[guangxi]] <- c(w_cn[[guangxi]],c(as.integer(hainan)))
w_cn[[zhejiang]] <- c(w_cn[[zhejiang]],c(as.integer(taiwan)))


w_cn <- poly2nb(cnData, queen=T)
map_crd <- coordinates(cnData)

dlist <- nbdists(w_cn, map_crd[,c(1,2)], longlat = T)
dlist_p1 <- lapply(dlist, function(x) 1/x)
dlist_p2 <- lapply(dlist, function(x) 1/(x*x))

w_cn_mat <- nb2listw(w_cn,zero.policy=TRUE)
w_cn_mat_d <- nb2listw(w_cn, glist=dlist, zero.policy=TRUE)
w_cn_mat_d_p1 <- nb2listw(w_cn, glist=dlist_p1, zero.policy=TRUE)
w_cn_mat_d_p2 <- nb2listw(w_cn, glist=dlist_p2, zero.policy=TRUE)

library(leaflet)
par(mfrow=c(2,2),mar=c(0,0,1,0), bg="black")
w1<-c()
for(i in w_cn_mat$weights){
  w1 <- c(w1,i)
}
pal1 <- colorNumeric(c("blue", "darkgreen", "yellow", "orangered"), w1)
plot(cnData,border="grey")
points(map_crd,col='red',pch='*')
plot(w_cn_mat,coords=coordinates(cnData), cex=0.1, col=pal1(w1), add=T)
title("默认共点共边",col.main= "white")

w2<-c()
for(i in w_cn_mat_d$weights){
  w2 <- c(w2,i)
}
pal2 <- colorNumeric(c("blue", "darkgreen", "yellow", "orangered"), w2)
plot(cnData,border="grey")
points(map_crd,col='red',pch='*')
plot(w_cn_mat_d,coords=coordinates(cnData), cex=0.1, col=pal2(w2), add=T)
title("正距离权重",col.main= "white")


w3<-c()
for(i in w_cn_mat_d_p1$weights){
  w3 <- c(w3,i)
}
pal3 <- colorNumeric(c("blue", "darkgreen", "yellow", "orangered"), w3)
plot(cnData,border="grey")
points(map_crd,col='red',pch='*')
plot(w_cn_mat_d_p1,coords=coordinates(cnData), cex=0.1, col=pal3(w3), add=T)
title("反距离权重:幂为1",col.main= "white")


w4<-c()
for(i in w_cn_mat_d_p2$weights){
  w4 <- c(w4,i)
}
pal4 <- colorNumeric(c("blue", "darkgreen", "yellow", "orangered"), w4)
plot(cnData,border="grey")
points(map_crd,col='red',pch='*')
plot(w_cn_mat_d_p2,coords=coordinates(cnData), cex=0.1, col=pal4(w4), add=T)
title("反距离权重:幂为2",col.main= "white")


