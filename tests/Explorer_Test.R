app <- ShinyDriver$new("../")
app$snapshotInit("Explorer_Test")

app$uploadFile(GFF="/srv/shiny-server/Data/Scerevisiae.gff.gz")
app$setInputs(limite = "click")
app$setInputs(ChromRadio="None")
app$uploadFile(InputZip="/srv/shiny-server/Data/Example.zip")
app$setInputs(max=NULL)
app$setInputs(min=NULL)

app$snapshot()