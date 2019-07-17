# 加载ipdw包，如果加载错误，则进行安装
if (!require("ipdw")){
  install.packages("ipdw")
}


spdf <- data.frame(z=runif(10,35,120))
xy   <- data.frame(x = runif(10,35,120), y = runif(10,20, 40))
coordinates(spdf) <- xy
plot(spdf,cex=spdf@data$z/20,pch=16,col=spdf@data$z)

m <- matrix(1, 100, 50)
costras <- raster(m, xmn = 35, xmx = 120, ymn = 20, ymx = 40)
#spdf 点空间要素数据框
#costras 插值结果承载的栅格
# range 子集搜索临近数量
# paramlist 插值的Z值字段名称
r <- ipdw(spdf,costras,100,c("z"))
plot(r)
plot(spdf, add = TRUE)




m <- matrix(1, 10, 10)
costras <- raster(m, xmn = 0, xmx = ncol(m), ymn = 0, ymx = nrow(m))

costras[] <- runif(ncell(costras), min = 1, max = 10)
plot(costras)
#introduce spatial gradient
for(i in 1:nrow(costras)){
  costras[i,] <- costras[i,] + i
  costras[,i] <- costras[,i] + i
}


#spdf 点空间要素数据框
#costras 插值结果承载的栅格
# range 子集搜索临近数量
# paramlist 插值的Z值字段名称
rstack <- pathdistGen(spdf, costras, 100, progressbar = FALSE)
r = ipdwInterp(spdf, rstack, paramlist = c("z"), overlapped = TRUE)
plot(r)
plot(spdf, add = TRUE)
