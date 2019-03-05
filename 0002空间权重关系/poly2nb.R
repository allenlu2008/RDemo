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
points(map_crd,col='red',pch='*')

#使用poly2nb方法，定义空间关系，现在共点共边（queen =T）
w_cn <- poly2nb(cnData, queen=T)
beijing <- which(cnData$FIRST_NAME == "北京")
print(beijing)
print(w_cn[[beijing]])
print(cnData$FIRST_NAME[[2]])
print(cnData$FIRST_NAME[[32]])

w_cn_mat <- nb2listw(w_cn, style="W", zero.policy=TRUE)
plot(cnData)
points(map_crd,col='red',pch='*')
plot(w_cn_mat,coords=map_crd, cex=0.1, col="blue", add=T)

#利用默认的空间关系计算莫兰指数
m <-moran.test(cnData$GDP_2009, listw=w_cn_mat, zero.policy=T)
m

############################
# 绘制2009年中国GDP专题图
############################
mycolors <- colorRampPalette(c("darkgreen", "yellow", "orangered"))(32)
spplot(cnData, zcol="GDP_2009", col.regions=mycolors, main="中国2009年各省GDP")


#######################
# 自定义七大区域划分  #
#######################
#东北
db <- c("吉林","辽宁","黑龙江")
#华北
hb <-c("内蒙古","北京","天津","河北","山东","山西")
#华中
hz <- c("河南","湖北","湖南","江西")
#华东
hd <- c("安徽","江苏","上海","福建","浙江")
#华南
hn <- c("广东","广西","海南")
#西南
xn <- c("贵州","云南","四川","重庆","西藏")
#西北
xb <- c("陕西","青海","甘肃","宁夏","新疆")

#进行自定义临近关系
w_cm_cn <- w_cn
ccn <-list(db,hb,hz,hd,hn,xn,xb)
for(area in ccn){
  for(i in area){
    i_id <-which(cnData$FIRST_NAME == as.character(i))
    temp<-c()
    for (j in area){
      j_id <-which(cnData$FIRST_NAME == as.character(j))
      if(i_id != j_id){
        temp <- c(temp,as.integer(j_id))
      }
    }
    w_cm_cn[[i_id]] <- temp
  }
}

#绘制自定义的临近关系
w_cm_cn_mat <- nb2listw(w_cm_cn, style="W", zero.policy=TRUE)
plot(cnData)
points(map_crd,col='red',pch='*')
plot(w_cm_cn_mat,coords=map_crd, cex=0.1, col="blue", add=T)
#利用七大区域划分空间权重矩阵来计算莫兰指数
m <-moran.test(cnData$GDP_2009, listw=w_cm_cn_mat, zero.policy=T)
m

#############################################
# 自定义七大区域划分：制造东部沿海发达区域  #
#############################################
#东北
db <- c("吉林","辽宁","黑龙江")
#华北
hb <-c("内蒙古","北京","天津","河北","山西")
#华中
hz <- c("河南","湖北","湖南","江西","安徽")
#华东（人为制造华东为东部沿海发达区域）
hd <- c("江苏","上海","福建","浙江","山东","广东")
#华南
hn <- c("广西","海南")
#西南
xn <- c("贵州","云南","四川","重庆","西藏")
#西北
xb <- c("陕西","青海","甘肃","宁夏","新疆")

#进行自定义临近关系
w_cm_cn2 <- w_cn
ccn <-list(db,hb,hz,hd,hn,xn,xb)
for(area in ccn){
  for(i in area){
    i_id <-which(cnData$FIRST_NAME == as.character(i))
    temp<-c()
    for (j in area){
      j_id <-which(cnData$FIRST_NAME == as.character(j))
      if(i_id != j_id){
        temp <- c(temp,as.integer(j_id))
      }
    }
    w_cm_cn2[[i_id]] <- temp
  }
}

#绘制自定义的临近关系
w_cm_cn_mat2 <- nb2listw(w_cm_cn2, style="W", zero.policy=TRUE)
plot(cnData)
points(map_crd,col='red',pch='*')
plot(w_cm_cn_mat2,coords=map_crd, cex=0.1, col="blue", add=T)

#利用新的七大区域计算莫兰指数
m <-moran.test(cnData$GDP_2009, listw=w_cm_cn_mat2, zero.policy=T)
m