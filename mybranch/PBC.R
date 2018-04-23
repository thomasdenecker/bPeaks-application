#Calcul de PBC
#PBC = number of positions where there is only one read/nb of positions where there is >= one reads
# Possibilité de faire une courbe des PBC par chromosomes.?
library(bPeaks)
data(dataPDR1)

meanIPcov = baseLineCalc(dataPDR1$IPdata[,3])
print(meanIPcov)

bPeaksAnalysis(IPdata = dataPDR1$IPdata[40000:50000,],
               controlData = dataPDR1$controlData[40000:50000,],
               windowSize = 150, windowOverlap = 50,
               IPcoeff = 6, controlCoeff = 2, log2FC = 3,
               averageQuantiles = 0.9,
               resultName = "bPeaks_example",
               peakDrawing = TRUE, promSize = 800)

load("peakStats.Robject")

data(yeastCDS)

pdr1Data = dataReading(IPdata, controlData, yeastSpecies = yeastCDS$Saccharomyces.
                       cerevisiae)

PBC= function(chrmx){
  print(length(chrmx))
  for(i in dataPDR1[["IPdata"]][["V3"]])
    if (i ==1){
      n1= n1+1
    }else if ( i>=1){
      nd=nd+1
    }print("le PBC du chromosome" ,chrmx, "est de :" ,n1/nd,)
}
