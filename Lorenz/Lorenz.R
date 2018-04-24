library(bPeaks)
data(dataPDR1)

# 1-On veut obtenir une fenetre de 150 nucléotides de longueur, avec un chevauchement de 50 nucléotides et la faire glisser.
# 2-trier ces moyennes 
# 3-en faire une courbe cumulative

  
library(evobiR)
Lorenz=function(chrx="chrIV", fichierIP=dataPDR1[["IPdata"]][["V3"]], fichiercontrol=ataPDR1[["controlData"]][["V3"]]){
  #creation of the Lorenz function with x argument
    subtabIP=subset(fichierIP,"V1" == chrx)
    subtabC=subset(fichiercontrol,"V1" == chrx)
IPLor=SlidingWindow(FUN=mean, data=subtabIP, window=150, step=100)
#sliding window setting= FUN=function applied per window, data=folder, window=size of window,step)
IPLor=sort(IPLor, decreasing = FALSE)
#The averages are sorted in ascending order
ContLor=SlidingWindow(FUN=mean, data=subtabC, window=150, step=100)
ContLor=sort(ContLor, decreasing = FALSE)
#pareil
perlen=(1:length(IPLor))*100/length(IPLor)
#percentage of read per position
perIP=cumsum(IPLor)*100/max(cumsum(IPLor))
#cumulative percentage 
perC=cumsum(ContLor)*100/max(cumsum(ContLor))
#cumulative percentage 
#we transfer our data in percentages
plot(x=perlen,y=perC, type="l",xlab= "Reads per position in %" ,ylab = "Cumulative sum of window averages in %",main = "Lorenz curve obtained for the PDR1 protein on chromosome IV",col="blue")
#First plot containing for the moment only the IP curve controls with title, axes, color.
lines(x=perlen,y=perIP,col="green")
#second curve appears with color -> control curve
lines(0:100,0:100,col="black")
#third curve appears in black-> line of equality
legend("topleft", 70, legend=c("line of equality","Control Lorenz curve", "IP Lorenz curve"),
       col=c("black","blue", "green"), lty=1, cex=0.8,box.lty = 0) #added a legend of different curves
}

Lorenz("chrIV",dataPDR1[["IPdata"]][["V3"]],dataPDR1[["controlData"]][["V3"]])



