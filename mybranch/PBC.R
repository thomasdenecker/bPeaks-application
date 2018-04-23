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


# PBC deuxiemes essai

PBC=function(chrx,fichier){
  ni=0
  np=0
  Fi=0
  Fp=0
  subtab=subset(fichier,V1 == chrx)
  for (i in subtab){
    if(i$V3 == 1){
      if (Fp==T){
        Fp=F
        np=np+1
      }else {Fi=T}
    }else if(i$V3 > 1){
      if(Fi == T){
        Fi=F
        ni=ni+1
      }else {
        Fp=T
      } 
    }else if(Fi==T){
      Fi=F
      ni=ni+1
    }else if (Fp==T){
      Fp=F
      np=np+1
      
    }
  }
  print(ni/(np+ni))
  return(ni/(np+ni))
}

a =PBC(chrx = "chrIV", fichier = dataPDR1[["IPdata"]])

