#Calcul de PBC
#PBC = number of positions where there is only one read/nb of positions where there is >= one reads
# Possibilité de faire une courbe des PBC par chromosomes.?
library(bPeaks)
data(dataPDR1)

PBC=function(chrx,fichier){
  subtab=subset(fichier,V1 == chrx)
n1= length(which(subtab[,3]==1))
nd= length(which(subtab[,3]>=1))
print(paste("le PBC de",chrx,"vaut",n1/nd))
return(n1/nd)
}

PBC(chrx = "chrIV", fichier = dataPDR1[["IPdata"]])
