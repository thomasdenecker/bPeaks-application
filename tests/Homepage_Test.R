app <- ShinyDriver$new("../")
app$snapshotInit("Homepage_Test")

app$setInputs(goToAnalyzer="click")
app$setInputs(goToExplorer="click")

app$snapshot()