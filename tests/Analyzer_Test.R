app <- ShinyDriver$new("../")
app$snapshotInit("Analyzer_Test")

#-------------------------------------------------------------------------------
# File inputs
#-------------------------------------------------------------------------------
app$uploadFile(fileCDS="/srv/shiny-server/Data/cds.txt")
app$uploadFile(fileCO="/srv/shiny-server/Data/SUBCO.txt")
app$uploadFile(fileIP="/srv/shiny-server/Data/SUBIP.txt")

#-------------------------------------------------------------------------------
# Read file parameters 
#-------------------------------------------------------------------------------
app$setInputs(header_CDS="TRUE")
app$setInputs(header_CO="TRUE")
app$setInputs(header_IP="TRUE")
app$setInputs(quote_CDS="")
app$setInputs(quote_CO="")
app$setInputs(quote_IP="")
app$setInputs(sep_CDS="\t")
app$setInputs(sep_CO="\t")
app$setInputs(sep_IP="\t")

#-------------------------------------------------------------------------------
# Analysis parameters
#-------------------------------------------------------------------------------
app$setInputs(folderName="bPeaks_Results")
app$setInputs(graphicalTF="TRUE")
app$setInputs(graphicalType="pdf")
app$setInputs(numAq=0.9)
app$setInputs(numCOcoeff=2)
app$setInputs(numIPcoeff=2)
app$setInputs(numLog2FC=2)
app$setInputs(numWo=50)
app$setInputs(numWs=150)
app$setInputs(peakDrawing="TRUE")
app$setInputs(promSize=800)
app$setInputs(resultName="bPeaks")
app$setInputs(withoutOverlap="TRUE")
app$setInputs(smoothingValue=20)

app$setInputs(RUN= "click")

app$snapshot()