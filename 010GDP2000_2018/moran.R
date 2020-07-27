library(spdep)
library(rgdal)
w = read.gal("D:\\workspace\\DevWork\\github\\RDemo_gitee\\010GDP2000_2018\\data\\cngdp2000_2018_queen.gal",
             override.id=TRUE)
w2 = read.gal("D:\\workspace\\DevWork\\github\\RDemo_gitee\\010GDP2000_2018\\data\\cngdp2000_2018_area7.gal",
              override.id=TRUE)
cngdp <- readOGR("D:\\workspace\\DevWork\\github\\RDemo_gitee\\010GDP2000_2018\\data\\cngdp2000_2018.shp")
map_crd <- coordinates(cngdp)

w_T = nb2listw(w,style = "W", zero.policy = TRUE)
year <- c(2000:2018)
queen_M <- c()
for (i in year){
  queen_M <- c(queen_M,as.numeric(moran.test(cngdp@data[paste("GDP",i,sep="")][,1],
                                     w_T,zero.policy = TRUE)$statistic))
}


w_T2 = nb2listw(w2,style = "W", zero.policy = TRUE)

year <- c(2000:2018)
queen_M2 <- c()
for (i in year){
  queen_M2 <- c(queen_M2,as.numeric(moran.test(cngdp@data[paste("GDP",i,sep="")][,1],
                                             w_T2,zero.policy = TRUE)$statistic))
}

plot(cngdp)
title("传统Queen空间权重模式")
points(map_crd,col="red",pch="*")
plot(w,coords=map_crd,pch=19,cex=0.1,col="red", add=T)
title("传统Queen空间权重模式莫兰指数")
plot(queen_M,x = year,col="red")
lines(queen_M,x=year,col="red")

plot(cngdp)
title("自定义七分区空间权重模式")
points(map_crd,col="blue",pch="*")
title("自定义七分区空间权重模式莫兰指数")
plot(w2,coords=map_crd,pch=19,cex=0.1,col="blue", add=T)
points(x=year,y=queen_M2,col="blue")
lines(queen_M2,x=year,col="blue")

