library(tree)
图片数量<- c(1,2,3,4,5,6,7,8,9,10)
客户意见 <- c("YES","YES","YES","YES","YES","NO","NO","NO","NO","NO")

样本数据集 <- data.frame(图片数量,客户意见)
t.te <- tree(客户意见~. ,data=样本数据集)
summary(t.te)
plot(t.te)
text(t.te)

