pop2012 <- read.csv("D:\\workspace\\DevWork\\example\\GitRDemo\\RDemo\\005聚类和异常值_莫兰散点图\\pop2012.csv")


plot(pop2012$MORAN_STD,pop2012$MORAN_LAG,pch=1,col='red',xaxt="n",xlab="STD",ylab="LAG",cex=1,ylim=c(-3,3),xlim=c(-3,3))
#lines(m$OBJECTID,m$ExpectedK,col='red',)
#points(m$OBJECTID,m$ObservedK,pch=16,col='blue',cex=2)
#lines(m$OBJECTID,m$ObservedK,col='blue')
#points(m$OBJECTID,m$LwConfEnv,pch=16,col='black')
#lines(m$OBJECTID,m$LwConfEnv,col='black')
#points(m$OBJECTID,m$HiConfEnv,pch=16,col='black')
#lines(m$OBJECTID,m$HiConfEnv,col='black')
axis(1,c(-3:10),c(-3:10))
abline(v=0,col='blue',lty=2,lwd=2)
abline(h=0,col='blue',lty=2,lwd=2)




xmsd <- pop2012$MORAN_STD[ pop2012$LISA_P<=0.05]
ymlg <- pop2012$MORAN_LAG[pop2012$LISA_P<=0.05]
t <- pop2012$NAME[pop2012$LISA_P<=0.05]

#all
plot(xmsd,ymlg,pch=1,col='red',xaxt="n",xlab="STD",ylab="LAG",cex=1,ylim=c(-2,2),xlim=c(-2,9))
axis(1,c(-3:10),c(-3:10))
abline(v=0,col='blue',lty=2,lwd=2)
abline(h=0,col='blue',lty=2,lwd=2)
text(xmsd,ymlg,t)

#1象限 
plot(xmsd,ymlg,pch=1,col='red',xaxt="n",xlab="STD",ylab="LAG",cex=1,ylim=c(0,3),xlim=c(0,9))
axis(1,c(-3:10),c(-3:10))
abline(v=0,col='blue',lty=2,lwd=2)
abline(h=0,col='blue',lty=2,lwd=2)
text(xmsd,ymlg,t)

#2象限 
plot(xmsd,ymlg,pch=1,col='red',xaxt="n",xlab="STD",ylab="LAG",cex=1,ylim=c(0,2),xlim=c(-1,0))
axis(1,c(-3:10),c(-3:10))
abline(v=0,col='blue',lty=2,lwd=2)
abline(h=0,col='blue',lty=2,lwd=2)
text(xmsd,ymlg,t)

#3象限
plot(xmsd,ymlg,pch=1,col='red',xaxt="n",xlab="STD",ylab="LAG",cex=1,ylim=c(-1.5,0),xlim=c(-1.5,0))
axis(1,c(-3:10),c(-3:10))
abline(v=0,col='blue',lty=2,lwd=2)
abline(h=0,col='blue',lty=2,lwd=2)
text(xmsd,ymlg,t)

#4象限
plot(xmsd,ymlg,pch=1,col='red',xaxt="n",xlab="STD",ylab="LAG",cex=1,ylim=c(-1.5,0),xlim=c(0,1))
axis(1,c(-3:10),c(-3:10))
abline(v=0,col='blue',lty=2,lwd=2)
abline(h=0,col='blue',lty=2,lwd=2)
text(xmsd,ymlg,t)
