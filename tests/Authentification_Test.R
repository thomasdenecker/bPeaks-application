app <- ShinyDriver$new("../")
app$snapshotInit("Authentification_Test")

#-------------------------------------------------------------------------------
# Login 
#-------------------------------------------------------------------------------
app$setInputs(EMAIL = "admin")
app$setInputs(PW="admin")
app$setInputs(login="click")

#-------------------------------------------------------------------------------
# Add user 
#-------------------------------------------------------------------------------
app$setInputs(AddDB = "click")
app$setInputs(AddUsers = "click")
app$setInputs(EMAIL_ADMIN="admin")
app$setInputs(PW_ADMIN="admin")
app$setInputs(USERNAME_NU="tutu")
app$setInputs(FN_NU="toto")
app$setInputs(LN_NU="titi")
app$setInputs(EMAIL_NU="toto@mail.com")
app$setInputs(TEMP_PW="tata")
app$setInputs(COUNTRY_NU="France")
app$setInputs(UserType="Admin")

#-------------------------------------------------------------------------------
# Change Password 
#-------------------------------------------------------------------------------
app$setInputs(Change = "click")
app$setInputs(ChangePW = "click")
app$setInputs(EMAIL_CPW="toto@mail.com")
app$setInputs(PW_new="toto")
app$setInputs(PW_old="titi")

#-------------------------------------------------------------------------------
# Sign up 
#-------------------------------------------------------------------------------
app$setInputs(SignUp="click")
app$setInputs(BackAuthen = "click")
app$setInputs(application="Authentification")


app$snapshot()
