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

#自然临域空间关系
t_nb <- tri2nb(ctData@coords,row.names = IDs)
ctData$NAME[1]
for(n in t_nb[1]){
  print(ctData$NAME[n])
}
plot(nb2listw(t_nb),ctData@coords,col='blue',add=T)

t_nb2 <- tri2nb(coordinates(cnData),row.names = cnData$Code)
plot(cnData,border="grey")
plot(nb2listw(t_nb2),coordinates(cnData),col='blue',add=T)

cnData$FIRST_NAME <- iconv(cnData$FIRST_NAME,"UTF-8","GBK")
cnData$FIRST_NAME[1]
for(n in t_nb2[1]){
  print(cnData$FIRST_NAME[n])
}
