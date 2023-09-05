####################################
####		用R语言生成HotSpot图		####
####		作者：虾神							####
####		时间：2015年11月20日		####
####################################


#加载sp包，此包在本脚本中主要用于空间可视化。
library(sp)

#加载spdep包，此包用于定义空间关系和实现Getis-Ord Gi* 算法
library(spdep)

#生成空间关系矩阵
W_cont_el <- poly2nb(data, queen=T)

#定义空间关系为共点共边即为邻近，即Queen's Case
W_cont_el_mat <- nb2listw(W_cont_el, style="W", zero.policy=TRUE)

#定义数据投影为WGS84(EPSG:4326)
proj4string(data) <- CRS("+init=EPSG:4326")

#执行Getis-Ord Gi*算法，这里叫做localG,全称就是（local Getis-Ord G 局部Getis-ord G指数)
lg1 <- localG(data$Bush_pct, listw=W_cont_el_mat, zero.policy=T)

#将计算完成的Getis-Ord Gi*指数（Z得分）赋值给数据里面的lg1属性
data$lg1 <- lg1[]

#定义可视化色带，这里用蓝色-白色-红色这样的色带图
lm.palette <- colorRampPalette(c("blue","white", "red"), space = "rgb")

#可视化图形
spplot(data, zcol="lg1", col.regions=lm.palette(20), main="Getis-Ord Gi* (z scores)", pretty=T)