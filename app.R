################################################################################
# bPeaks application
# Thomas DENECKER
# 05-07/2018
#
# bPeaks Package :
# https://cran.r-project.org/web/packages/bPeaks/index.html
#
# GitHub :
# https://github.com/thomasdenecker/bPeaks-application
################################################################################

################################################################################
# Library
################################################################################

library(shiny)
library(shinyjs)
library(shinyFiles)
library(evobiR)
library(plotly)
library(ape)
library('RPostgreSQL')
library(shinyalert)
library(googleVis)

################################################################################
# Admin adress
################################################################################

adminAdress = "thomas.denecker@gmail.com"

################################################################################
# Country list (from googleVis in population dataframe)
################################################################################

COUNTRY = as.list(sort(Population$Country))
names(COUNTRY) = sort(Population$Country)


################################################################################
# Database connection
################################################################################

ipDB = read.table("Database/ipDB.txt", header = F, stringsAsFactors = F)[1,1]
pg <- dbDriver("PostgreSQL")
con <- dbConnect(pg, user="docker", password="docker",
                 host=ipDB, port=5432)

################################################################################
# UI
################################################################################

ui <- fluidPage(useShinyjs(), useShinyalert(),
                ################################################################
                # Head
                ################################################################
                
                # Add a application title
                tags$head(tags$title("bPeaks application")),
                
                # Add nav icon
                tags$head(tags$link(href = "Images/bPeaks_logo_mini.png",
                                    rel ="icon", type="image/png")),
                
                # Add css style
                tags$head(HTML('<link rel="stylesheet" type="text/css"
                               href="style.css" />')),
                
                # Add JS script
                tags$head(tags$script(src="script.js")),
                
                ################################################################
                # BODY
                ################################################################
                
                tabsetPanel(id = "application",
                            #---------------------------------------------------
                            # Authentification
                            #---------------------------------------------------
                            
                            tabPanel(title = "Authentification", value = "Authentification",
                                     
                                     HTML("<div class ='container'>"),
                                     
                                     br(),
                                     
                                     div(
                                       class = "authen",
                                       h1("Authentification", class ="center"),
                                       h3("Identifier"),
                                       div(class = "center_input", textInput("EMAIL", NULL,  placeholder = "Username or email")),
                                       h3("Password"),
                                       div(class = "center_input",passwordInput("PW", NULL, placeholder = "Password")),
                                       br(),
                                       actionButton("login", "Login"), 
                                       hr(class="hrStyle"),
                                       actionButton("SignUp", "Sign up"),br(),br(),
                                       actionButton("ChangePW", "Change your password"), br(),br(),
                                       actionButton("AddUsers", "Add new user (admin)")
                                       
                                     ),
                                     
                                     HTML("</div>")
                            ),
                            
                            #---------------------------------------------------
                            # Add users
                            #---------------------------------------------------
                            
                            tabPanel(title = "AddUsersPage", value = "AddUsersPage",
                                     
                                     HTML("<div class ='container'>"),
                                     br(),
                                     div(
                                       class = "authen",
                                       h1("Add new user", class ="center"),
                                       h2("Admin part"),
                                       h3("Admin Authentification"),
                                       div(class = "center_input",textInput("EMAIL_ADMIN", NULL, placeholder = "Admin username or email")),
                                       h3("Admin password"),
                                       div(class = "center_input", passwordInput("PW_ADMIN", NULL, placeholder = "Admin password")),
                                       hr(),
                                       h2("New user part"),
                                       h3("New user name"),
                                       div(class = "center_input",textInput("USERNAME_NU", NULL, placeholder = "Username")),
                                       h3("New user first name"),
                                       div(class = "center_input",textInput("FN_NU", NULL, placeholder = "First name")),
                                       h3("New user last name"),
                                       div(class = "center_input",textInput("LN_NU", NULL, placeholder = "Last name")),
                                       h3("New user email"),
                                       div(class = "center_input",textInput("EMAIL_NU", NULL, placeholder = "Email")),
                                       h3("Country"),
                                       div(class = "center_input",selectInput("COUNTRY_NU", NULL, 
                                                                              choices = COUNTRY, 
                                                                              selected = "France")),
                                       
                                       h3("Temp password"),
                                       div(class = "center_input",textInput("TEMP_PW", label = NULL)), 
                                       h3("User type"),
                                       div(class = "center_input",selectInput("UserType", NULL,
                                                                              c("Admin" = "Admin",
                                                                                "User" = "User"))),
                                       br(),
                                       actionButton("AddDB", "Add in database")
                                     ),
                                     
                                     HTML("</div>")
                            ),
                            
                            #---------------------------------------------------
                            # ChangePassWord
                            #---------------------------------------------------
                            
                            tabPanel(title = "ChangePassWord", value = "ChangePassWord",
                                     
                                     HTML("<div class ='container'>"),
                                     br(),
                                     div(
                                       class = "authen",
                                       h1("Change your passeword", class ="center"),
                                       h3("Username"),
                                       textInput("EMAIL_CPW", NULL, placeholder = "Username or email"),
                                       h3("Old password"),
                                       passwordInput("PW_old", NULL, placeholder = "Old password"),
                                       h3("New password"),
                                       passwordInput("PW_new", NULL, placeholder = "New password"),
                                       br(),
                                       actionButton("Change", "Change")
                                     ),
                                     HTML("</div>")
                            ),
                            
                            #---------------------------------------------------
                            # Sign in
                            #---------------------------------------------------
                            
                            tabPanel(title = "PageSignUP", value = "PageSignUP",
                                     
                                     HTML("<div class ='container'>"),
                                     
                                     br(),
                                     
                                     div(
                                       class = "authen",
                                       h1("Sign in", class ="center"),
                                       h3("Contact"),
                                       p(class="justify", "To register in the database, send an 
                                         email to the administrator of your bPeaks application instance:"),
                                       br(),
                                       p(class = "center", adminAdress),
                                       
                                       h3("Mail template"),
                                       p("In the email, 3 informations are essential: your first name, your 
                                         last name and your email. You will receive a confirmation email and a 
                                         temporary password. A model email is proposed below:"), br(),
                                       
                                       div(class = "template","Hello admin!", br(), br(),
                                           "I would like to access your bPeaks application instance.
                                          To register, my identifiers are as follows:", br(),
                                           tags$ul(
                                             tags$li("First name :"),
                                             tags$li("Last name :"),
                                             tags$li("Email :")
                                           ),"Thank you very much."),
                                       br(),
                                       actionButton("BackAuthen", "Back")
                                     ),
                                     
                                     HTML("</div>")
                            ),
                            
                            #---------------------------------------------------
                            # Home page
                            #---------------------------------------------------
                            
                            tabPanel(title = "Home page", value = "Homepage",
                                     img(src = "Images/bPeaks_logo.svg",
                                         class= "logo center"),
                                     
                                     HTML("<div class ='container'>"),
                                     
                                     h1("bPeaks Application : A bioinformatics tool to perform peak calling from ChIPseq data in small eukaryotic genomes", class ="title_principal center"),
                                     br(),
                                     fluidRow( class="row-flex",
                                               column(width = 6,
                                                      div( class="div_area",
                                                           h1("bPeaks Analyzer", class ="center"),
                                                           div(class="pad",actionButton(inputId = "goToAnalyzer", label = "Let's go!", class ="center", class= "myBtn" )),
                                                           p('bPeaks analyzer is a Web interface to run a peak calling analysis with the bPeaks R package')
                                                      )
                                               ),
                                               column(width =6,
                                                      div( class="div_area",
                                                           h1("bPeaks explorer", class= "center"),
                                                           div(class="pad",actionButton(inputId = "goToExplorer", class= "myBtn", label = "Let's go!", class ="center")),
                                                           p("bPeaks explorer is a Web interface to explore and visualize the peak calling results, obtained with the bPeaks R package")
                                                      )
                                               )
                                     ),
                                     
                                     br(),
                                     
                                     div( class="div_area", 
                                          h1('In a few numbers', class = 'center'),
                                          br(),
                                          fluidRow( class="row-flex",
                                                    column(width = 3, 
                                                           div( class = "peaks_detected boxDashboard",
                                                                p("Peak detected", class= "center"),
                                                                div(class='UpPolice', textOutput("peaks_detected")))),
                                                    
                                                    column(width = 3, 
                                                           div( class = "chromosome_studied boxDashboard",
                                                                p("Chomosome Studied", class= "center"),
                                                                div(class='UpPolice', textOutput("chromosome_studied")))),
                                                    
                                                    column(width = 3, 
                                                           div( class = "nbr_analysis boxDashboard",
                                                                p("# of analysis performed", class= "center"),
                                                                div(class='UpPolice', textOutput("nbr_analysis")))),
                                                    
                                                    column(width = 3, 
                                                           div( class = "nbr_exploration boxDashboard",
                                                                p("# of exploration performed", class= "center"),
                                                                div(class='UpPolice', textOutput("nbr_exploration"))))
                                          ),
                                          br(),
                                          h1('Users', class = 'center'),
                                          
                                          fluidRow( class="row-flex",
                                                    column(width = 6, 
                                                           h3("Contact us"),
                                                           dataTableOutput(outputId = "UsersTable")),
                                                    
                                                    column(width = 6,   
                                                           h3("Where are we?"),
                                                           htmlOutput("UsersMap"))
                                          ),
                                          
                                          br(),
                                          h1('Utilisation', class = 'center'),
                                          
                                          fluidRow( class="row-flex",
                                                    htmlOutput("calendarAnalyzer")
                                          ),
                                          
                                          fluidRow( class="row-flex",      
                                                    htmlOutput("calendarExplorer")
                                          )
                                          
                                     ),
                                     
                                     HTML("</div>")
                            ),
                            
                            #---------------------------------------------------
                            # Analyzer page
                            #---------------------------------------------------
                            
                            tabPanel(title = "bPeaks analyzer", value = "bPeaks_analyzer",
                                     img(src = "Images/Analyzer_bPeaks_logo.svg", class= "logo center"),
                                     
                                     HTML("<div class ='container'>"),
                                     br(),
                                     p('bPeaks is a simple approach to perform peak calling from ChIPseq data. Our general philosophy is to provide an easy-to-use tool,
                                       well-adapted for small eukaryotic genomes (< 20 Mb). bPeaks uses a combination
                                       of 4 cutoffs (T1, T2, T3 and T4) to mimic "good peak" properties as described
                                       by biologists who visually inspect the ChIP-seq data on a genome browser.
                                       For yeast genomes, bPeaks calculates the proportion of peaks that fall in
                                       promoter sequences. These peaks are good candidates as transcription factor
                                       binding sites.',alin="center"),
                                     
                                     #>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
                                     # FILE SELECTION
                                     #>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
                                     
                                     fluidRow(class="div_TITLE", column(12,tags$h3(strong("File selection"),align = "center"))),
                                     
                                     #..........................................
                                     # IP file
                                     #..........................................
                                     
                                     fluidRow(column(4,HTML('<h3>IPdata <a href="#" data-toggle="tooltip"
                                                            data-placement="bottom" title="A dataframe with sequencing results of the IP sample. This dataframe has three columns (chromosome, position, number of sequences) and should have been created with the dataReading function">
                                                            <img src="Images/IntP.png" alt="" height="15px"></a></h3>'),
                                                     fileInput("fileIP",label = NULL,
                                                               buttonLabel = "Browse...",
                                                               placeholder = "No file selected"),align = "center",
                                                     tags$hr(),
                                                     
                                                     # Input: Checkbox if file has header
                                                     radioButtons("header_IP", "Header",
                                                                  choices = c("Yes" = TRUE,
                                                                              "No" = FALSE),
                                                                  selected = TRUE, inline=T),
                                                     
                                                     # Input: Select separator ----
                                                     radioButtons("sep_IP", "Separator",
                                                                  choices = c(Comma = ",",
                                                                              Semicolon = ";",
                                                                              Tab = "\t"),
                                                                  selected = "\t", inline=T),
                                                     
                                                     # Input: Select quotes ----
                                                     radioButtons("quote_IP", "Quote",
                                                                  choices = c(None = "",
                                                                              "Double Quote" = '"',
                                                                              "Single Quote" = "'"),
                                                                  selected = "", inline=T),
                                                     
                                                     h3("Preview"),
                                                     dataTableOutput(outputId = "contents_IP")
                                                     
                                                     
                                     ),
                                     
                                     #..........................................
                                     # CO file
                                     #..........................................
                                     
                                     column(4,HTML('<h3>Control data <a href="#" data-toggle="tooltip"
                                                   data-placement="bottom" title="A dataframe with sequencing results of the control sample. This dataframe has three columns (chromosome, position, number of sequences) and should have been created with the dataReading function">
                                                   <img src="Images/IntP.png" alt="" height="15px"></a></h3>'),
                                            fileInput("fileCO",
                                                      NULL,
                                                      buttonLabel = "Browse...",
                                                      placeholder = "No file selected"),align = "center",
                                            tags$hr(),
                                            
                                            # Input: Checkbox if file has header
                                            radioButtons("header_CO", "Header",
                                                         choices = c("Yes" = TRUE,
                                                                     "No" = FALSE),
                                                         selected = TRUE, inline=T),
                                            
                                            # Input: Select separator ----
                                            radioButtons("sep_CO", "Separator",
                                                         choices = c(Comma = ",",
                                                                     Semicolon = ";",
                                                                     Tab = "\t"),
                                                         selected = "\t", inline=T),
                                            
                                            # Input: Select quotes ----
                                            radioButtons("quote_CO", "Quote",
                                                         choices = c(None = "",
                                                                     "Double Quote" = '"',
                                                                     "Single Quote" = "'"),
                                                         selected = "", inline=T),
                                            
                                            h3("Preview"),
                                            dataTableOutput(outputId = "contents_CO")
                                     ),
                                     
                                     #..........................................
                                     # CDS file
                                     #..........................................
                                     
                                     column(4,HTML('<h3>CDS position <a href="#" data-toggle="tooltip"
                                                   data-placement="bottom" title="Not mandatory. A table (matrix) with positions of CDS (genes). Four columns are required (chromosome, starting position, ending position, strand (W or C), description). CDS positions for several yeast species are stored in bPeaks package (see the dataset yeastCDS and also peakLocation function)">
                                                   <img src="Images/IntP.png" alt="" height="15px"></a></h3>'),
                                            fileInput("fileCDS",
                                                      NULL,
                                                      buttonLabel = "Browse...",
                                                      placeholder = "No file selected"),align = "center",
                                            tags$hr(),
                                            
                                            # Input: Checkbox if file has header
                                            radioButtons("header_CDS", "Header",
                                                         choices = c("Yes" = TRUE,
                                                                     "No" = FALSE),
                                                         selected = TRUE, inline=T),
                                            
                                            # Input: Select separator ----
                                            radioButtons("sep_CDS", "Separator",
                                                         choices = c(Comma = ",",
                                                                     Semicolon = ";",
                                                                     Tab = "\t"),
                                                         selected = "\t", inline=T),
                                            
                                            # Input: Select quotes ----
                                            radioButtons("quote_CDS", "Quote",
                                                         choices = c(None = "",
                                                                     "Double Quote" = '"',
                                                                     "Single Quote" = "'"),
                                                         selected = "", inline=T),
                                            
                                            h3("Preview"),
                                            dataTableOutput(outputId = "contents_CDS")
                                     )),
                                     
                                     #>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
                                     # BPeaks parameters
                                     #>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
                                     
                                     fluidRow(class="div_TITLE",column(12,tags$h3(strong("bPeaks parameters"),align = "center"))),
                                     
                                     fluidRow(column(4,HTML('<h3>Windows size <a href="#" data-toggle="tooltip"
                                                            data-placement="bottom" title="Size of the sliding windows to scan chromosomes">
                                                            <img src="Images/IntP.png" alt="" height="15px"></a></h3>'),
                                                     
                                                     numericInput("numWs", NULL,
                                                                  value = 150,  width = "100%"),
                                                     class = "center"),
                                              
                                              
                                              column(4,HTML('<h3>IP coeff <a href="#" data-toggle="tooltip"
                                                            data-placement="bottom" title="Threshold T1. Value for the multiplicative parameter that will be combined with the value of the mean genome-wide read depth (see baseLineCalc). As an illustration, if the IPcoeff = 6, it means that to be selected, the IP signal should be GREATER than 6 * (the mean genome-wide read depth). Note that a vector with different values can be specified, the bPeaks analysis will be therefore repeated using successively each value for peak detection. For a list of values, separate them by ; (i.e : 2;3 ).">
                                                            <img src="Images/IntP.png" alt="" height="15px"></a></h3>'),
                                                     textAreaInput("numIPcoeff", NULL, "2", width = "100%",
                                                                   resize = "none", rows = 1),
                                                     class = "center"),
                                              
                                              column(4,HTML('<h3>Log2FC <a href="#" data-toggle="tooltip"
                                                            data-placement="bottom" title="Threshold T3. Threshold to consider log2(IP/control) values as sufficiently important to be interesting. Note that a vector with different values can be specified, the bPeaks analysis will be therefore repeated using successively each value for peak detection. For a list of values, separate them by ; (i.e : 2;3 ).">
                                                            <img src="Images/IntP.png" alt="" height="15px"></a></h3>'),
                                                     textAreaInput("numLog2FC", NULL, "2", width = "100%",
                                                                   resize = "none", rows = 1),
                                                     class = "center")
                                     ),
                                     
                                     fluidRow(column(4,HTML('<h3>Windows overlap <a href="#" data-toggle="tooltip"
                                                            data-placement="bottom" title="Size of the overlap between two successive windows">
                                                            <img src="Images/IntP.png" alt="" height="15px"></a></h3>'),
                                                     numericInput("numWo",
                                                                  NULL,
                                                                  value = 50,  width = "100%"),
                                                     class = "center"),
                                              
                                              column(4,HTML('<h3>Control coeff <a href="#" data-toggle="tooltip"
                                                            data-placement="bottom" title="Threshold T2. Value for the multiplicative parameter that will be combined with the value of the mean genome-wide read depth (see baseLineCalc). As an illustration, if the controlCoeff = 2, it means that to be selected, the control signal should be LOWER than 2 * (the mean genome-wide read depth). Note that a vector with different values can be specified, the bPeaks analysis will be therefore repeated using successively each value for peak detection. For a list of values, separate them by ; (i.e : 2;3 ).">
                                                            <img src="Images/IntP.png" alt="" height="15px"></a></h3>'),
                                                     textAreaInput("numCOcoeff", NULL, "2", width = "100%",
                                                                   resize = "none", rows = 1),
                                                     class = "center"),
                                              
                                              column(4,HTML('<h3>Average quantiles <a href="#" data-toggle="tooltip"
                                                            data-placement="bottom" title="Threshold T4. Threshold to consider (log2(IP) + log2(control)) / 2 as sufficiently important to be interesting. This parameter ensures that the analyzed genomic region has enough sequencing coverage to be reliable. These threshold should be between [0, 1] and refers to the quantile value of the global distribution observed with the analyzed chromosome. For a list of values, separate them by ; (i.e : 2;3 ). ">
                                                            <img src="Images/IntP.png" alt="" height="15px"></a></h3>'),
                                                     textAreaInput("numAq", NULL, "0.9", width = "100%",
                                                                   resize = "none", rows = 1),
                                                     class = "center")),
                                     
                                     #>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
                                     # Advanced parameters
                                     #>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
                                     
                                     a(id = "toggleAdvanced", "Show/hide advanced info", href = "#"),
                                     shinyjs::hidden(
                                       div(id = "advanced",
                                           fluidRow(class="div_TITLE",column(12,tags$h3(strong("Advanced parameters"),align = "center"))),
                                           fluidRow(
                                             column(4,HTML('<h3>Result name <a href="#" data-toggle="tooltip"
                                                           data-placement="bottom" title="Name for output files created during bPeaks procedure">
                                                           <img src="Images/IntP.png" alt="" height="15px"></a></h3>'),
                                                    textInput("resultName",
                                                              NULL,
                                                              value = "bPeaks",  width = "100%"),
                                                    class = "center"),
                                             
                                             column(4,HTML('<h3>Peak drawing <a href="#" data-toggle="tooltip"
                                                           data-placement="bottom" title="TRUE or FLASE. If TRUE, the function peakDrawing is called and PDF files with graphical representations of detected peaks are created.">
                                                           <img src="Images/IntP.png" alt="" height="15px"></a></h3>'),
                                                    radioButtons("peakDrawing", NULL,
                                                                 c("TRUE" = "TRUE",
                                                                   "FALSE" = "FALSE"), width = "100%"),
                                                    class = "center"),
                                             
                                             column(4,HTML('<h3>Prom Size <a href="#" data-toggle="tooltip"
                                                           data-placement="bottom" title="Size of the genomic regions to be considered as "upstream" to the annotated genomic features (see documentation of the function peakLocation for more information).">
                                                           <img src="Images/IntP.png" alt="" height="15px"></a></h3>'),
                                                    numericInput("promSize",
                                                                 NULL,
                                                                 value = 800,  width = "100%"),
                                                    class = "center")
                                           ),
                                           fluidRow(
                                             column(4,HTML('<h3>Without overlap <a href="#" data-toggle="tooltip"
                                                           data-placement="bottom" title="If TRUE, this option allows to filter peak that are located in a promoter AND a CDS.">
                                                           <img src="Images/IntP.png" alt="" height="15px"></a></h3>'),
                                                    radioButtons("withoutOverlap", NULL,
                                                                 c("TRUE" = "TRUE",
                                                                   "FALSE" = "FALSE"), width = "100%"),
                                                    class = "center"),
                                             
                                             column(4,HTML('<h3>Smoothing value <a href="#" data-toggle="tooltip"
                                                           data-placement="bottom" title="The number (n/2) of surrounding positions to use for mean calculation in the dataSmoothing function">
                                                           <img src="Images/IntP.png" alt="" height="15px"></a></h3>'),
                                                    numericInput("smoothingValue",
                                                                 NULL,
                                                                 value = 20,  width = "100%"),
                                                    class = "center")
                                           )
                                       )
                                     ),
                                     
                                     #>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
                                     # Outputs parameters
                                     #>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
                                     
                                     fluidRow(class="div_TITLE",column(12,tags$h3(strong("Output parameters"),align = "center"))),
                                     
                                     fluidRow(
                                       column(4,HTML('<h3>Folder name <a href="#" data-toggle="tooltip"
                                                     data-placement="bottom" title="Folder name where results will be saved">
                                                     <img src="Images/IntP.png" alt="" height="15px"></a></h3>'),
                                              textInput("folderName",
                                                        NULL,
                                                        value = "bPeaks_Results",  width = "100%"),
                                              class = "center"),
                                       
                                       column(4,HTML('<h3>Graphical outputs <a href="#" data-toggle="tooltip"
                                                     data-placement="bottom" title="TRUE or FLASE. If TRUE, PBC, Lorenz curve and read repartition will be ploted.">
                                                     <img src="Images/IntP.png" alt="" height="15px"></a></h3>'),
                                              radioButtons("graphicalTF", NULL,
                                                           c("TRUE" = "TRUE",
                                                             "FALSE" = "FALSE"), width = "100%", inline=T),
                                              class = "center"),
                                       
                                       column(4,HTML('<h3>Graphical extention <a href="#" data-toggle="tooltip"
                                                     data-placement="bottom" title="Graphical extention">
                                                     <img src="Images/IntP.png" alt="" height="15px"></a></h3>'),
                                              radioButtons("graphicalType", NULL,
                                                           c("pdf" = "pdf",
                                                             "png" = "png",
                                                             "jpg" = "jpg"), width = "100%", inline=T),
                                              class = "center")
                                     ),
                                     
                                     #>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
                                     # RUN
                                     #>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
                                     
                                     fluidRow(
                                       HTML("<div id='Hidebox'>"),
                                       column(6,  actionButton(inputId = "RUN", label = "RUN", class= "myBtn" )),
                                       column(6, downloadButton("downloadData", label = "Download", class ="downloadData center")),
                                       HTML("</div>")
                                     ),
                                     
                                     #>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
                                     # Download
                                     #>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
                                     
                                     fluidRow(
                                       HTML("<div class='DivDownload'>"),
                                       h4("Summary of the last analysis", class="center"),
                                       HTML("<p class='center warning'> &#9888; Analyses are not stored on the server. Download the results with the button above &#9888;</p>"),
                                       textOutput("folderName"),
                                       textOutput("bPeakDetected"),
                                       dataTableOutput("SummaryRun"),
                                       br(),
                                       
                                       HTML("</div>")
                                     ),
                                     
                                     HTML("</div>")
                            ),
                            
                            
                            #===================================================
                            # Explorer page
                            #===================================================
                            
                            tabPanel(title = "bPeaks Explorer", value = "bPeaks_Explorer",
                                     HTML("<div class='cont'>"),
                                     img(src = "Images/Explorer_bPeaks_logo.svg", class= "logo center"),
                                     h1("bPeaks Explorer is a graphical tool to quickly analyze data generated by bPeaks analyzer.
                                       The tool provides dynamic plotly visualizations of detected peaks, PBC,
                                        Lorenz curve and read distribution.", class ="title_principal center"),
                                     br(),
                                     fluidRow(
                                       
                                       column(2, class="SidePanel",
                                              h3("Input file"),
                                              tags$hr(),
                                              h4("Select Zip folder"),
                                              p("Select an output bPeaks analyzer folder"),
                                              # shinyDirButton('folder', class ="loadFolder" ,'Browse...', 'Please select a folder', FALSE),
                                              fileInput("InputZip",label = NULL,
                                                        buttonLabel = "Browse...",
                                                        placeholder = "No file selected"),
                                              
                                              h4("GFF file (.gff or gff.gz) "),
                                              tags$i(HTML("<a href='https://www.ncbi.nlm.nih.gov/genome'  target='_blank'>Find your gff</a>")),
                                              fileInput("GFF",label = NULL,
                                                        buttonLabel = "Browse...",
                                                        placeholder = "No file selected"),
                                              
                                              
                                              h3("Chromosome selection"),
                                              tags$hr(),
                                              radioButtons("ChromRadio",NULL, c("None"),inline=T),
                                              h5("Supplementary data (by chromosome)"),
                                              downloadButton("DL_SUM", "Summary"),
                                              downloadButton("DL_DRAW", "Drawing"),
                                              h4("Detected peaks"),
                                              plotlyOutput("peaks_barplot", height = "300px"),
                                              
                                              h3("Summary"),
                                              tags$hr(),
                                              tableOutput("Summary")
                                       ),
                                       
                                       column(10, class="MainPanel",
                                              
                                              #/////////////////////////////////
                                              # Area with general plot
                                              #/////////////////////////////////
                                              
                                              fluidRow(
                                                plotlyOutput("GenomeBrowser",
                                                             height = "541px")
                                              ),
                                              
                                              #/////////////////////////////////
                                              # Area to change the view window
                                              #/////////////////////////////////
                                              
                                              fluidRow(
                                                p("(Peaks are highlighted by gray rectangles)", class= 'center'),
                                                
                                                column(1,h5("Start")),
                                                column(2,numericInput("min", label = NA, value = NULL)),
                                                column(1,h5("End")),
                                                column(2,numericInput("max", label = NA, value = NULL)),
                                                column(2,actionButton("limite", label = "Change")),
                                                column(2,selectizeInput("SearchGeneList", NULL, choices=c(1:6000), 
                                                                        selected = NULL, multiple = FALSE,
                                                                        options = list(
                                                                          placeholder = 'Search a gene',
                                                                          maxOptions = 100,
                                                                          onInitialize = I('function() { this.setValue(""); }')
                                                                        )
                                                )),
                                                column(2, actionButton("SearchGene", label = "Search gene"))
                                              ),
                                              
                                              #/////////////////////////////////
                                              # Area with general plot
                                              #/////////////////////////////////
                                              
                                              fluidRow(
                                                h3(class='center', "Annotations"),
                                                p(class='center',"Click on extremity of genes (if a GFF is loaded)" ),
                                                column(6,htmlOutput(class='AnnotDB',"AnnotDB")),
                                                column(6,htmlOutput(class='AnnotGFF',"AnnotGFF"))
                                                
                                              ),
                                              
                                              #/////////////////////////////////
                                              # Area with quality control plots
                                              #/////////////////////////////////
                                              
                                              fluidRow(
                                                h3(class='center', "Quality controls"),
                                                column(4,
                                                       div(class="figure",plotlyOutput("IPCO_boxplot"))),
                                                column(4,
                                                       div(class="figure",plotlyOutput("LOGFC_boxplot"))),
                                                column(4,
                                                       div(class="figure",plotlyOutput("QUANTILE_boxplot")))
                                                
                                              ),
                                              fluidRow(
                                                column(4,
                                                       div(class="figure",plotlyOutput("LORENZ_plot"))),
                                                column(4,
                                                       div(class="figure",plotlyOutput("PBC_plot"))),
                                                column(4,
                                                       div(class="figure",plotlyOutput("REPARTITION_barplot")))
                                                
                                                
                                              )
                                              
                                       )
                                     ),
                                     HTML("</div>")
                                     
                            )
                )
)

################################################################################
# SERVER
################################################################################

server <- function(input, output, session) {
  
  #=============================================================================
  # End session
  #=============================================================================
  
  session$onSessionEnded(function() {
    
    dbDisconnect(con)
    dbUnloadDriver(pg)
    if(length(isolate(rv$userTempFolder)) != 0){
      unlink(paste0(getwd(),"/Outputs/", isolate(rv$userTempFolder)), recursive = T)
    }
    
  })
  
  #=============================================================================
  # General
  #=============================================================================
  
  # Creation reactive values to update plots
  rv <- reactiveValues()
  
  #Increase the size of files allowed by shiny
  options(shiny.maxRequestSize=1000*1024^2)
  
  # Show or hide advanced parameter
  shinyjs::onclick("toggleAdvanced",
                   shinyjs::toggle(id = "advanced", anim = TRUE))
  
  
  #=============================================================================
  # TEST 
  #=============================================================================
  output$AnnotDB <- renderText({
    s <- event_data("plotly_click")
    if (length(s) == 0) {
      ""
    } else {
      if(s$curveNumber != 0 & s$curveNumber != 1){
        nameInter = grep("^Name=",unlist(strsplit(rv$GFF_CHR[s$curveNumber-1,"attributes"], ";")), value = T)
        nameInter = gsub("Name=", "", nameInter)
        REQUEST_ANNOT = paste0("SELECT * from annotation where primary_id_database = '",nameInter
                               ,"' or feature_name ='",nameInter
                               ,"' or standard_name = '",nameInter,"';")
        
        annotInter = dbGetQuery(con, REQUEST_ANNOT)
        paste("<h4 class='center'> Annotation in DB</h4><br/>",
              "<b>Feature_name</b> :", annotInter[1,1], '<br/>' ,
              "<b>Primary ID</b> :", annotInter[1,2], '<br/>', 
              "<b>Standard_name</b> :", annotInter[1,3], '<br/>' ,
              "<b>Start</b> :", annotInter[1,4], '<br/>' ,
              "<b>Stop</b> :", annotInter[1,5], '<br/>' ,
              "<b>Chromosome</b> :", annotInter[1,6], '<br/>' ,
              "<b>Description</b> :", annotInter[1,7], '<br/>' ,
              "<b>Specie</b> :", annotInter[1,8] )
        
      } else {
        "Click on extremity of genes"
      }
    }
  })
  
  output$AnnotGFF <- renderText({
    s <- event_data("plotly_click")
    if (length(s) == 0) {
      ""
    } else {
      if(s$curveNumber != 0 & s$curveNumber != 1){
        
        paste("<h4 class='center'> Annotation in GFF</h4><br/>",
              paste(unlist(strsplit(rv$GFF_CHR[s$curveNumber-1,"attributes"], ";")), 
                    collapse = "<br/>")
        )
        
      } else {
        "Click on extremity of genes"
      }
    }
  })
  
  
  
  #=============================================================================
  # END TEST 
  #=============================================================================
  
  
  #=============================================================================
  # Authentification
  #=============================================================================
  
  #-----------------------------------------------------------------------------
  # Change password
  #-----------------------------------------------------------------------------
  
  observeEvent(input$ChangePW, {
    # Show bPeaks Analy
    showTab(inputId = "application", target = "ChangePassWord")
    
    # Move in this next page
    updateTabsetPanel(session, "application",
                      selected = "ChangePassWord")
    
  })
  
  observeEvent(input$Change, {
    REQUEST_CHANGE = paste0("UPDATE users SET password = crypt('",
                            input$PW_new,"', password) WHERE ( email = '",input$EMAIL_CPW,"' 
                     or user_name = '",input$EMAIL_CPW,"') AND password =crypt('",
                            input$PW_old,"', password);")
    
    dbGetQuery(con, REQUEST_CHANGE)
    
    REQUEST_CHECK = paste0("SELECT * 
                           FROM users
                           WHERE ( email = '",input$EMAIL_CPW,"' or user_name = '",input$EMAIL_CPW,"') 
                           AND password = crypt('",input$PW_new,"', password);")
    
    if(nrow(dbGetQuery(con, REQUEST_CHECK)) != 0 ){
      # Show bPeaks home page
      showTab(inputId = "application", target = "Authentification")
      
      # Move in this next page
      updateTabsetPanel(session, "application",
                        selected = "Authentification")
      
      shinyalert("Done!","Your password are changed!", type = "success")
      
    } else {
      shinyalert("Oops!", "Something went wrong (Username or old password).", type = "error")
    }
    
  })
  
  #-----------------------------------------------------------------------------
  # Add users
  #-----------------------------------------------------------------------------
  
  observeEvent(input$AddUsers, {
    # Show bPeaks Analy
    showTab(inputId = "application", target = "AddUsersPage")
    
    # Move in this next page
    updateTabsetPanel(session, "application",
                      selected = "AddUsersPage")
    
    updateTextInput(session, "TEMP_PW",
                    value = paste(sample(c(LETTERS, 0:9), 8, replace = T), collapse = ""))
    
  })
  
  observeEvent(input$AddDB, {
    
    REQUEST_ADMIN = paste0("SELECT * 
                           FROM users
                           WHERE ( email = '",input$EMAIL_ADMIN,"' or user_name = '",input$EMAIL_ADMIN,"') 
                           AND password = crypt('",input$PW_ADMIN,"', password) 
                           AND usertype = 'Admin';")
    
    
    if(nrow(dbGetQuery(con, REQUEST_ADMIN)) == 0 ){
      shinyalert("Oops!", "Something went wrong (Are you admin?).", type = "error")
    } else {
      REQUEST_EXISTING = paste0("SELECT *
                                FROM users
                                WHERE email = '",input$EMAIL_NU,"' or user_name = '",input$USERNAME_NU,"';")
      if(nrow(dbGetQuery(con, REQUEST_EXISTING)) != 0 ){
        shinyalert("Oops!", "This user is already in the database", type = "error")
      } else {
        
        REQUESTE_ADD = paste0("INSERT INTO users (first_name, last_name, user_name, email, UserType, Country, password) VALUES (
                              '",input$FN_NU, "',
                              '",input$LN_NU, "',
                              '",input$USERNAME_NU,"',
                              '",input$EMAIL_NU, "',
                              '",input$UserType, "',
                              '",input$COUNTRY_NU, "',
                              crypt('",input$TEMP_PW,"', gen_salt('bf'))
        );
                              ")
        dbGetQuery(con, REQUESTE_ADD)
        
        shinyalert("Nice!", paste0("Communicate these informations to the new user: To use bPeaks application
                                   your mail is : ", input$EMAIL_NU,
                                   ", your username is ", input$USERNAME_NU,
                                   " and your temp password is ", input$TEMP_PW,". Don't forget to change your password!")
                   , type = "success")
        # Show bPeaks Analy
        showTab(inputId = "application", target = "Authentification")
        
        # Move in this next page
        updateTabsetPanel(session, "application",
                          selected = "Authentification")
      }
    }
    
  })
  
  #-----------------------------------------------------------------------------
  # Sign up
  #-----------------------------------------------------------------------------
  
  observeEvent(input$SignUp, {
    # Show bPeaks Analy
    showTab(inputId = "application", target = "PageSignUP")
    
    # Move in this next page
    updateTabsetPanel(session, "application",
                      selected = "PageSignUP")
    
  })
  
  observeEvent(input$BackAuthen, {
    
    # Show bPeaks Analy
    showTab(inputId = "application", target = "Authentification")
    
    # Move in this next page
    updateTabsetPanel(session, "application",
                      selected = "Authentification")
    
  })
  
  
  #-----------------------------------------------------------------------------
  # Login
  #-----------------------------------------------------------------------------
  
  observeEvent(input$login, {
    
    REQUEST = paste0("SELECT * 
            FROM users
            WHERE ( email = '",input$EMAIL,"' or user_name = '",input$EMAIL,"') 
            AND password = crypt('",input$PW,"', password);")
    
    if(input$EMAIL != "" & input$PW != ""){
      RESULT_REQUEST = dbGetQuery(con, REQUEST)
      
      if(nrow(RESULT_REQUEST) != 0 ){
        # Show bPeaks Analy
        showTab(inputId = "application", target = "Homepage")
        
        # Move in this next page
        updateTabsetPanel(session, "application",
                          selected = "Homepage")
        
        rv$userTempFolder <- paste0(RESULT_REQUEST[1,'user_name'],"_",format(Sys.time(),'%y%m%d_%H%M%S'))
        
        dir.create(paste0("./Outputs/", rv$userTempFolder))
        
      } else {
        shinyalert("Oops!", "Something went wrong (Username or password).", type = "error")
      }
    }else {
      shinyalert("Oops!", "Username or password is empty.", type = "error")
    }
  })
  
  #=============================================================================
  # Home page
  #=============================================================================
  
  #Link action buttons to their respective pages
  observeEvent(input$goToAnalyzer, {
    # Show bPeaks Analy
    showTab(inputId = "application", target = "bPeaks_analyzer")
    
    # Move in this next page
    updateTabsetPanel(session, "application",
                      selected = "bPeaks_analyzer")
  })
  
  observeEvent(input$goToExplorer, {
    # Show bPeaks Analy
    showTab(inputId = "application", target = "bPeaks_Explorer")
    
    # Move in this next page
    updateTabsetPanel(session, "application",
                      selected = "bPeaks_Explorer")
    library(plotly)
  })
  
  #-----------------------------------------------------------------------------
  # Few numbers
  #-----------------------------------------------------------------------------
  
  output$peaks_detected <- renderText({
    REQUEST_PD = paste("SELECT sum(peaks_detected) FROM dashboard where type_use = 'analysis';")
    dbGetQuery(con, REQUEST_PD)[1,1]
  })
  
  output$chromosome_studied <- renderText({
    REQUEST_CS = paste("SELECT sum(chromosome_studied) FROM dashboard where type_use = 'analysis';")
    dbGetQuery(con, REQUEST_CS)[1,1]
  })
  
  output$nbr_analysis <- renderText({
    REQUEST_NA = paste("SELECT count(*) FROM dashboard where type_use = 'analysis';")
    dbGetQuery(con, REQUEST_NA)[1,1]
  })
  
  output$nbr_exploration <- renderText({
    REQUEST_NA = paste("SELECT count(*) FROM dashboard where type_use = 'exploration';")
    dbGetQuery(con, REQUEST_NA)[1,1]
  })
  
  #-----------------------------------------------------------------------------
  # Contact us
  #-----------------------------------------------------------------------------
  
  output$UsersTable = renderDataTable({
    formatDate = "'YYYY-MM-DD'"
    SEP_SQL = "' '"
    REQUEST_Table = paste('SELECT concat_ws(',SEP_SQL ,', first_name, last_name)  as "Name",',
                          'email as "Email",',
                          'to_char(creation_date,',formatDate,') as "Joined on"',
                          'FROM users;')
    dbGetQuery(con, REQUEST_Table)
  },  options = list(scrollX = TRUE , dom = 't'))
  
  
  #-----------------------------------------------------------------------------
  # Google plots
  #-----------------------------------------------------------------------------
  
  output$UsersMap <- renderGvis({
    REQUEST_MAP = paste0("SELECT country, count(*) FROM users GROUP BY country ;")
    MapTable = dbGetQuery(con, REQUEST_MAP)
    gvisGeoChart(MapTable, locationvar="country", 
                 colorvar="count",
                 options=list(projection="kavrayskiy-vii"))
  })
  
  output$calendarAnalyzer <- renderGvis({
    
    REQUEST_CA = "SELECT to_char(utilisation_date,'YYYY-MM-DD') as Date, count(*) 
    FROM dashboard
    WHERE type_use = 'analysis' GROUP BY to_char(utilisation_date,'YYYY-MM-DD');"
    
    calendarA = dbGetQuery(con, REQUEST_CA)
    
    if(nrow(calendarA) != 0){
      calendarA[,1] = as.Date(calendarA[,1])
      gvisCalendar(calendarA, 
                   datevar="date", 
                   numvar="count",
                   options=list(
                     title="bPeaks analysis",
                     height=200,
                     width=1000,
                     colorAxis="{colors:['#ffe6e6','#b30000'], minValue:1}", 
                     calendar="{focusedCellColor: {stroke:'red'}}")
      )} else{
        return()
      }
  })
  
  output$calendarExplorer <- renderGvis({
    
    REQUEST_CE = "SELECT to_char(utilisation_date,'YYYY-MM-DD') as Date, count(*) 
    FROM dashboard
    WHERE type_use = 'exploration' GROUP BY to_char(utilisation_date,'YYYY-MM-DD');"
    
    calendarE = dbGetQuery(con, REQUEST_CE)
    
    if(nrow(calendarE) != 0){
      calendarE[,1] = as.Date(calendarE[,1])
      gvisCalendar(calendarE, 
                   datevar="date", 
                   numvar="count",
                   options=list(
                     title="bPeaks explorer",
                     height=200,
                     width=1000,
                     colorAxis="{colors:['#ffe6e6','#b30000'], minValue:1}", 
                     calendar="{focusedCellColor: {stroke:'red'}}")
      )
    }else {
      return()
    }
    
  })
  
  #=============================================================================
  # bPeaks Analyzer
  #=============================================================================
  
  #-----------------------------------------------------------------------------
  # Data Preview
  #-----------------------------------------------------------------------------
  
  #*****************************************************************************
  # IP preview
  #*****************************************************************************
  
  output$contents_IP <-  renderDataTable({
    
    req(input$fileIP)
    
    df <- read.csv(input$fileIP$datapath,
                   header = as.logical(input$header_IP),
                   sep = input$sep_IP,
                   quote = input$quote_IP,
                   nrows=10
    )
    
  },  options = list(scrollX = TRUE , dom = 't'))
  
  #*****************************************************************************
  # CO preview
  #*****************************************************************************
  
  output$contents_CO <-  renderDataTable({
    
    req(input$fileCO)
    
    
    df <- read.csv(input$fileCO$datapath,
                   header = as.logical(input$header_CO),
                   sep = input$sep_CO,
                   quote = input$quote_CO,
                   nrows=10
    )
    
  },  options = list(scrollX = TRUE, dom = 't'))
  
  #*****************************************************************************
  # CDS preview
  #*****************************************************************************
  
  output$contents_CDS <-  renderDataTable({
    
    req(input$fileCDS)
    
    df <- read.csv(input$fileCDS$datapath,
                   header = as.logical(input$header_CDS),
                   sep = input$sep_CDS,
                   quote = input$quote_CDS,
                   nrows=10
    )
    
  },  options = list(scrollX = TRUE, dom = 't'))
  
  #-----------------------------------------------------------------------------
  # Output
  #-----------------------------------------------------------------------------
  
  observe({
    if(input$graphicalTF == FALSE){
      disable("graphicalType")
    }else{
      enable("graphicalType")
    }
  })
  
  
  #-----------------------------------------------------------------------------
  # RUN
  #-----------------------------------------------------------------------------
  
  observe({
    if(is.null(input$fileIP) || is.null(input$fileCO)){
      disable("RUN")
    }else{
      enable("RUN")
    }
  })
  
  #-----------------------------------------------------------------------------
  # Check values
  #-----------------------------------------------------------------------------
  
  #*****************************************************************************
  # IPcoeff
  #*****************************************************************************
  
  observeEvent(input$numIPcoeff, {
    IPcoeff = as.numeric(as.character(unlist(strsplit(input$numIPcoeff, ";"))))
    if(sum(is.na(IPcoeff)) != 0 || length(IPcoeff) == 0){
      showNotification(id ="NotifIP",  "Error : IP coeff is not numeric!", type = "error", 
                       duration = NULL, closeButton = FALSE)
      disable("RUN")
    }else{
      removeNotification(id = "NotifIP")
      if(is.null(input$fileIP) || is.null(input$fileCO)){
        disable("RUN")
      }else{
        enable("RUN")
      }
    }
  })
  
  #*****************************************************************************
  # numAq
  #*****************************************************************************
  
  observeEvent(input$numAq, {
    numAq = as.numeric(as.character(unlist(strsplit(input$numAq, ";"))))
    if(sum(is.na(numAq)) != 0 || length(numAq) == 0){
      showNotification(id ="NotifAq",  "Error : Average quantiles is not numeric!", type = "error", 
                       duration = NULL, closeButton = FALSE)
      disable("RUN")
    }else{
      removeNotification(id = "NotifAq")
      if(is.null(input$fileIP) || is.null(input$fileCO)){
        disable("RUN")
      }else{
        enable("RUN")
      }
    }
  })
  
  #*****************************************************************************
  # Log2FC
  #*****************************************************************************
  
  observeEvent(input$numLog2FC, {
    Log2FCcoeff = as.numeric(as.character(unlist(strsplit(input$numLog2FC, ";"))))
    if(sum(is.na(Log2FCcoeff)) != 0 || length(Log2FCcoeff) == 0){
      showNotification(id ="NotifLogFC",  "Error : LogFC is not numeric!", type = "error", 
                       duration = NULL, closeButton = FALSE)
      disable("RUN")
    }else{
      removeNotification(id = "NotifLogFC")
      if(is.null(input$fileIP) || is.null(input$fileCO)){
        disable("RUN")
      }else{
        enable("RUN")
      }
    }
  })
  
  #*****************************************************************************
  # COcoeff
  #*****************************************************************************
  
  observeEvent(input$numCOcoeff, {
    COcoeff = as.numeric(as.character(unlist(strsplit(input$numCOcoeff, ";"))))
    if(sum(is.na(COcoeff)) != 0 || length(COcoeff) == 0){
      showNotification(id ="NotifCO",  "Error : Co coeff is not numeric!", type = "error", 
                       duration = NULL, closeButton = FALSE)
      disable("RUN")
    }else{
      removeNotification(id = "NotifCO")
      if(is.null(input$fileIP) || is.null(input$fileCO)){
        disable("RUN")
      }else{
        enable("RUN")
      }
    }
  })
  
  #-----------------------------------------------------------------------------
  # Analyze
  #-----------------------------------------------------------------------------
  
  #Create a button that launches the bPeaks analysis taking into account the entered parameters
  observeEvent(input$RUN,{
    
    shinyjs::hide(id = "Hidebox")
    if(!is.null(paste0("./Outputs/",rv$userTempFolder,"/", rv$folder_name_final, ".zip"))){
      unlink(paste0("./Outputs/",rv$userTempFolder,"/", rv$folder_name_final, ".zip"), recursive = T)
    }
    
    withProgress(message = 'bPeaks analysis', value = 0, {
      
      n = 12
      #*************************************************************************
      # Folder creation
      #*************************************************************************
      
      setwd(paste0("Outputs/",rv$userTempFolder))
      incProgress(1/n, detail = "Create folder")
      folder_name = gsub(" ","_",input$folderName)
      
      folder_name_final = paste0(folder_name,"_", format(Sys.time(), "%Y-%m-%d_%H-%M-%S"))
      
      if(length(as.numeric(as.character(unlist(strsplit(input$numIPcoeff, ";"))))) > 1 ||
         length(as.numeric(as.character(unlist(strsplit(input$numCOcoeff, ";"))))) > 1 ||
         length(as.numeric(as.character(unlist(strsplit(input$numLog2FC, ";"))))) > 1 ||
         length(as.numeric(as.character(unlist(strsplit(input$numAq, ";"))))) > 1){
        folder_name_final = paste0(folder_name_final, "_(tempFolder)")
      }
      
      dir.create(folder_name_final)
      
      setwd(folder_name_final)
      dir.create("bPeaks")
      dir.create("LorenzCurve")
      dir.create("PBC")
      dir.create("Repartition")
      dir.create("Temp")
      
      #*************************************************************************
      # Read data
      #*************************************************************************
      incProgress(1/n, detail = "Read data")
      
      inFileIP= input$fileIP
      inFileCO=input$fileCO
      inFileCDS=input$fileCDS
      
      if (!is.null(input$fileCDS$datapath)){
        file.copy(input$fileCDS$datapath, "Temp")
        filename = unlist(strsplit(input$fileCDS$datapath, "/"))
        filename = filename[length(filename)]
        file.rename(paste0("Temp/", filename), paste0("Temp/", "CDS"))
      }
      
      file.copy(input$fileIP$datapath, "Temp")
      filename = unlist(strsplit(input$fileIP$datapath, "/"))
      filename = filename[length(filename)]
      file.rename(paste0("Temp/", filename), "Temp/IP")
      
      file.copy(input$fileCO$datapath, "Temp")
      filename = unlist(strsplit(input$fileCO$datapath, "/"))
      filename = filename[length(filename)]
      file.rename(paste0("Temp/", filename), "Temp/CO")
      
      #Condition to run the application without informing the CDSdata
      if (!is.null(input$fileCDS$datapath)){
        CDS=read.csv2('Temp/CDS',
                      header = as.logical(input$header_CDS),
                      sep = input$sep_CDS,
                      quote = input$quote_CDS)
      }else {
        CDS=NULL
      }
      
      incProgress(1/n, detail = "Read data IP")
      
      IP=read.csv2('Temp/IP',
                   header = as.logical(input$header_IP),
                   sep = input$sep_IP,
                   quote = input$quote_IP)
      
      incProgress(1/n, detail = "Read data CO")
      
      CO=read.csv2('Temp/CO',
                   header = as.logical(input$header_CO),
                   sep = input$sep_CO,
                   quote = input$quote_CO)
      
      #*************************************************************************
      # Analysis
      #*************************************************************************
      
      setwd("bPeaks")
      
      # Increment the progress bar, and update the detail text.
      incProgress(4/n, detail = "Analysis")
      
      if(length(which(search() == "package:plotly")) != 0){
        detach("package:plotly", unload=TRUE)
      }
      
      bPeaks::bPeaksAnalysis(IPdata = IP,
                             controlData = CO,
                             cdsPositions = CDS,
                             smoothingValue = input$smoothingValue,
                             windowSize = input$numWs,
                             windowOverlap = input$numWo,
                             IPcoeff = as.numeric(as.character(unlist(strsplit(input$numIPcoeff, ";")))),
                             controlCoeff = as.numeric(as.character(unlist(strsplit(input$numCOcoeff, ";")))),
                             log2FC = as.numeric(as.character(unlist(strsplit(input$numLog2FC, ";")))),
                             averageQuantiles = as.numeric(as.character(unlist(strsplit(input$numAq, ";")))),
                             resultName = input$resultName,
                             peakDrawing = as.logical(input$peakDrawing),
                             promSize = input$promSize,
                             withoutOverlap = as.logical(input$withoutOverlap))
      
      
      rv$SummaryRun = read.table(paste0(input$resultName,"_bPeaks_parameterSummary.txt"), 
                                 sep = "\t", header = T)
      
      #>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
      # Add informations in database
      #>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
      
      TEMP = read.table(paste0(input$resultName,"_bPeaks_allGenome.bed"), 
                        sep = "\t", header = F)
      REQUEST_Table = paste("INSERT INTO dashboard (Peaks_detected, Chromosome_studied, type_use) VALUES(",
                            nrow(TEMP), ",", length(unique(TEMP[,1])), ", 'analysis');")
      
      rm(TEMP)
      
      dbGetQuery(con, REQUEST_Table)
      
      
      dir.create("Subdata")
      for(chromosome in unique(IP[,1])){
        write.table(subset(IP, IP[,1] == chromosome), paste0("Subdata/SubIP_", chromosome,".txt"), col.names = F, sep = "\t", quote = F, row.names = F)
        write.table(subset(CO, CO[,1] == chromosome), paste0("Subdata/SubCO_", chromosome,".txt"), col.names = F, sep = "\t", quote = F, row.names = F)
      }
      
      library(plotly)
      setwd("..")
      
      #*************************************************************************
      # PBC
      #*************************************************************************
      
      incProgress(1/n, detail = "PBC")
      
      setwd("PBC")
      
      PBC=function(chr = "ALL", signal_data, c_chr , c_reads ){
        
        # If ALL, complet table are analyzed else a subset are realized with chr
        if(chr != "ALL"){
          signal_data = subset(signal_data,signal_data[,c_chr] == chr)
        }
        
        pbc = length(which(signal_data[,c_reads]==1)) / length(which(signal_data[,c_reads]>=1))
        
        return(pbc)
      }
      
      chr=as.character(unique(IP[,1]))
      
      # Add NA for total table : see function
      chr = c(chr, "ALL")
      
      # Init PBC vector
      PBC_IP = NULL
      PBC_CO = NULL
      
      for (c in chr){
        PBC_IP = c(PBC_IP,PBC(chr = c, signal_data = IP, c_chr = 1, c_reads = 3))
        PBC_CO = c(PBC_CO,PBC(chr = c, signal_data = CO, c_chr = 1, c_reads = 3))
      }
      
      # rename PBC_IP & PBC_CO
      names(PBC_IP) = gsub("chr=chrmt", "chrM", chr)
      names(PBC_CO) = gsub("chr=chrmt", "chrM", chr)
      # sorti txt de nos données
      
      write.table(cbind(PBC_IP,PBC_CO,chr),file="PBC.txt",quote= FALSE,sep="\t",row.names = FALSE)
      
      #*************************************************************************
      # Figures
      #*************************************************************************
      
      if(as.factor(input$graphicalTF) == TRUE ){
        if(input$graphicalType == "pdf"){
          pdf("pbc_final.pdf")
        }else if(input$graphicalType == "png"){
          png("pbc_final.png")
        } else if(input$graphicalType == "jpg"){
          jpeg("pbc_final.jpg")
        }
        
        layout(matrix(c(1,2), 1, 2, byrow = TRUE),
               widths = c(5,1))
        
        par(mar = c(5, 4, 0, 0) + 0.1)
        plot(PBC_IP, pch = 19, col = "forestgreen",
             ylim = c(0,max(PBC_IP)),
             ylab = "PBC", xlab = "Chromosomes",las = 1, axes =FALSE)
        lines(PBC_IP[-length(PBC_IP)], col = "forestgreen" )
        
        points(PBC_CO, col = "cornflowerblue", pch = 19)
        lines(PBC_CO[-length(PBC_CO)], col = "cornflowerblue")
        
        
        text(1:length(chr), -0.014 ,
             srt = 45, adj= 1, xpd = TRUE,
             labels = gsub("chr=chrmt", "chrM", chr), cex=1)
        
        axis(1,at = 1:length(chr), labels = rep("", length(chr)) )
        axis(2, at = seq(0, max(PBC_IP), 0.03), labels = seq(0,max(PBC_IP), 0.03), las = 1)
        
        # Legend
        par(mar =  c(5, 0, 0, 0) + 0.1)
        plot(1, type="n", axes = F, xlab ="", ylab = "")
        legend("left", legend = c("IP", "Control"), box.lty = 0, lty = 1,
               col = c("forestgreen", "cornflowerblue"))
        dev.off()
      }
      
      
      setwd("..")
      
      #*************************************************************************
      # Lorenz curve
      #*************************************************************************
      
      incProgress(1/n, detail = "Lorenz curve")
      
      setwd("LorenzCurve")
      
      #fonction lorenz
      Lorenz=function(chr, fileIP, fileC,c_chr, c_reads,
                      window, step){
        
        if(chr != "ALL"){
          fileIP = subset(fileIP,fileIP[,c_chr]== chr)
          fileC = subset(fileC,fileC[,c_chr] == chr)
        }
        
        IPLor=SlidingWindow(FUN=mean, data=fileIP[,c_reads],
                            window=window, step=step)
        IPLor=sort(IPLor, decreasing = FALSE)
        
        ContLor=SlidingWindow(FUN=mean, data=fileC[,c_reads],
                              window=window, step=step)
        ContLor=sort(ContLor, decreasing = FALSE)
        
        # Percent calculs
        perlen=(1:length(IPLor))*100/length(IPLor)
        perIP=cumsum(IPLor)*100/max(cumsum(IPLor))
        perC=cumsum(ContLor)*100/max(cumsum(ContLor))
        
        EM=which.max(abs(perIP-perC))
        
        # sorti txt de nos données
        
        cbind(perIP,perC,perlen)
        write.table(cbind(perIP,perC,perlen),file=paste0("LorenzCurve_data_",chr,".txt"),
                    quote= FALSE,sep="\t",row.names = FALSE)
        
        if(as.factor(input$graphicalTF) == TRUE ){
          if(input$graphicalType == "pdf"){
            pdf(paste0("LorenzCurve_",chr,".pdf"))
          }else if(input$graphicalType == "png"){
            png(paste0("LorenzCurve_",chr,".png"))
          } else if(input$graphicalType == "jpg"){
            jpeg(paste0("LorenzCurve_",chr,".jpg"))
          }
          
          #curve
          plot(x=perlen,y=perC, type="l", lwd = 2,
               xlab= "average reads per window in %" ,ylab = "Cumulative
               sum of window averages in %",
               main = paste("Lorenz curve obtained for the PDR1 protein on ",chr),
               col="blue")
          
          lines(x=perlen,y=perIP,col="green", lwd = 2)
          
          lines(0:100,0:100,col="black", lwd = 2)
          arrows(perlen[EM], perIP[EM], perlen[EM], perC[EM], code = 3,
                 length = 0.1, col = "firebrick", lwd = 3)
          text(perlen[EM], mean(c(perIP[EM],perC[EM])),
               labels = paste(floor(abs(perIP[EM] - perC[EM])), "%"), cex = 0.7,
               pos = 4)
          
          legend("topleft", legend=c("line of equality",
                                     "Control Lorenz curve",
                                     "IP Lorenz curve",
                                     "EM=ecart maximal"), inset = 0.01,
                 col=c("black","blue", "green", "firebrick"), lty=c(rep(1,3), NA),
                 bty="n") #added a legend of different curves
          
          par(font = 5) #change font to get arrows
          legend("topleft", legend = rep(NA,4), pch=c(rep(NA,3),171),inset = 0.01,
                 lty = c(rep(1,3),NA),col=c("black","blue", "green", "firebrick"),
                 bty="n")
          
          par(font = 1) #back to default
          
          dev.off()
        }
      }
      
      # Loop for all chromosomes
      chr=as.character(unique(IP[,1]))
      chr = c(chr, "ALL")
      for (c in chr){
        Lorenz(chr = c,fileIP = IP, fileC = CO,c_chr = 1,c_reads = 3,
               window = input$numWs, step = input$numWo)
      }
      
      setwd("..")
      
      #*************************************************************************
      # Read repartitions
      #*************************************************************************
      
      incProgress(1/n, detail = "Read repartitions")
      
      setwd("Repartition")
      
      Barpo=function(chr,fileIP,fileCO,c_chr,c_read){
        
        if(chr != "ALL"){
          
          fileIP= subset(fileIP,fileIP[,c_chr]==chr)
        }
        testIP=table(fileIP[,c_read])
        
        x=testIP[-1]
        
        tab_inter = as.data.frame(cbind(LOG = log(x), POS = as.numeric(names(x))))
        
        write.table(tab_inter,file=paste0("ReadRepartition_",chr,".txt"),quote= FALSE,sep="\t",row.names = FALSE)
        
        if(as.factor(input$graphicalTF) == TRUE ){
          if(input$graphicalType == "pdf"){
            pdf(paste0("ReadRepartition_",chr,".pdf"))
          }else if(input$graphicalType == "png"){
            png(paste0("ReadRepartition_",chr,".png"))
          } else if(input$graphicalType == "jpg"){
            jpeg(paste0("ReadRepartition_",chr,".jpg"))
          }
          
          plot(tab_inter$POS, tab_inter$LOG,ylim=c(0,12), type = "h",
               xlim = c(1, 16000),
               xlab = "Number of reads",
               ylab = "log(number of positions)",
               main = paste0("Repartition of reads quantity for ",chr))
          
          # Loess curve
          loessMod <- loess(LOG ~ POS,
                            data = tab_inter, span=0.1)
          smoothed <- predict(loessMod)
          lines( tab_inter$POS,smoothed, col= "red", lwd=2)
          
          # Legende
          legend('topright', "Loess curve", lty = 1, col = "red", lwd = 3,
                 inset = 0.01, box.lty = 0)
          
          dev.off()
        }
        
      }
      
      chr=as.character(unique(IP[,1]))
      chr = c(chr, "ALL")
      for (c in chr){
        Barpo(chr = c,fileIP = IP, fileCO = CO,c_chr =1 ,c_read = 3)
      }
      
      setwd("../..")
      
      incProgress(1/n, detail = "Zip folder")
      rv$folder_name_final = folder_name_final
      zip(folder_name_final, folder_name_final)
      unlink(folder_name_final, recursive = T)
      setwd("../..")
      
    })
    
    shinyjs::show(id = "Hidebox")
    
  })
  
  #-----------------------------------------------------------------------------
  # Download zone
  #-----------------------------------------------------------------------------
  
  output$downloadData <- downloadHandler(
    filename <- function() {
      paste(rv$folder_name_final, "zip", sep=".")
    },
    
    content <- function(file) {
      file.copy(paste0("./Outputs/",rv$userTempFolder,"/", rv$folder_name_final, ".zip"), file)
      unlink(paste0("./Outputs/",rv$userTempFolder,"/", rv$folder_name_final, ".zip"), recursive = T)
    },
    contentType = "application/zip"
  )
  
  output$folderName <- renderText({
    paste0("Folder name : ", rv$folder_name_final)
  })
  
  output$bPeakDetected <- renderText({
    paste0("Peaks detected : ", rv$SummaryRun[1,"bPeaksNumber"])
  })
  
  output$SummaryRun <- renderDataTable(
    {if(!is.null(rv$SummaryRun)){
      rv$SummaryRun
    }else{
      return()
    }},
    options = list(scrollX = TRUE, dom = 't')
  )
  
  #=============================================================================
  # bPeaks Explorer
  #=============================================================================
  
  #-----------------------------------------------------------------------------
  # GFF
  #-----------------------------------------------------------------------------
  
  observeEvent(input$GFF,{
    rv$GFF = read.gff(input$GFF$datapath)
    rv$Region = subset(rv$GFF, type == "region", select = c("seqid", "attributes"))
    for(i in 1:nrow(rv$Region)){
      inter = unlist(strsplit(rv$Region[i,2], ";"))
      rv$Region[i,2] = paste0("chr",unlist(strsplit(inter[grep('Name=', inter)], "="))[2])
    }
    
    if(input$ChromRadio != "none"){
      SEQID = as.character(rv$Region[which(rv$Region[,2] == rv$CHROMOSOME[1]),1])
      rv$GFF_CHR = subset(rv$GFF, rv$GFF$seqid == SEQID & rv$GFF$type == "gene")
    } else {
      SEQID = as.character(rv$Region[which(rv$Region[,2] == input$ChromRadio),1])
      rv$GFF_CHR = subset(rv$GFF, rv$GFF$seqid == SEQID
                          & rv$GFF$type == "gene")
    }

    Genes_Chromosome = NULL
    tempGenes = subset(rv$GFF, rv$GFF$type == "gene")
    for(i in 1:nrow(tempGenes)){
      nameInter = grep("^Name=",unlist(strsplit(tempGenes[i,"attributes"], ";")), value = T)
      nameInter = gsub("Name=", "", nameInter)
      Genes_Chromosome = rbind(Genes_Chromosome,
                               c(nameInter, tempGenes$seqid[i]))
    }
    
    rv$Genes_Chromosome = Genes_Chromosome
    updateSelectInput(session, "SearchGeneList",
                      choices = Genes_Chromosome[,1]
    )
    
    
  })
  
  #-----------------------------------------------------------------------------
  # ZIP result choose
  #-----------------------------------------------------------------------------
  
  observeEvent(input$InputZip,{
    
    # Get complet path to folder
    unzip(input$InputZip$datapath, exdir = paste0("./Outputs/", rv$userTempFolder))
    rv$PATH = paste0("./Outputs/",rv$userTempFolder,"/",unlist(strsplit(input$InputZip$name, ".zip"))[1])
    
    # Get output name of bPeaks package
    filelist = list.files(paste0(rv$PATH,"/bPeaks/"))
    rv$FILENAME = unlist(strsplit(filelist[grep(pattern = "*_bPeaks_allGenome.bed",filelist)], "_bPeaks_allGenome.bed"))
    
    #...........................................................................
    # bPeaks package results
    #...........................................................................
    
    id <- showNotification("Read summary", duration = NULL)
    
    # Peak informations
    rv$allGenome = read.table(paste0(rv$PATH,"/bPeaks/",rv$FILENAME,"_bPeaks_allGenome.bed"), sep = "\t", header = F)
    
    REQUEST_Explo = paste("INSERT INTO dashboard (Peaks_detected, Chromosome_studied, type_use) VALUES(",
                          nrow(rv$allGenome), ",", length(unique(rv$allGenome[,1])), ", 'exploration');")
    
    dbGetQuery(con, REQUEST_Explo)
    
    # Parameter informations
    interSum = read.table(paste0(rv$PATH,"/bPeaks/",rv$FILENAME,"_bPeaks_parameterSummary.txt"), sep = "\t", header = F)
    interSum = t(interSum)
    colnames(interSum) = c('Parameters', "Values")
    rv$SUMMARY = interSum
    
    # Get chromosome names to generate radio button
    rv$CHROMOSOME = sort(unique(rv$allGenome[,1]))
    
    updateRadioButtons(session, "ChromRadio",
                       choices = rv$CHROMOSOME ,
                       selected = rv$CHROMOSOME[1], inline = T
    )
    
    rv$SubTableAll = subset(rv$allGenome,rv$allGenome[,1] == rv$CHROMOSOME[1] )
    rv$ChrSelected = rv$CHROMOSOME[1]
    removeNotification(id)
    
    #...........................................................................
    # Signal data
    #...........................................................................
    
    id <- showNotification("Read IP data", duration = NULL)
    rv$SIGNAL_IP = read.table(paste0(rv$PATH,"/bPeaks/Subdata/SubIP_",rv$CHROMOSOME[1],".txt"), sep = "\t", header = F)
    removeNotification(id)
    
    id <- showNotification("Read CO data", duration = NULL)
    rv$SIGNAL_CO = read.table(paste0(rv$PATH,"/bPeaks/Subdata/SubCO_",rv$CHROMOSOME[1],".txt"), sep = "\t", header = F)
    removeNotification(id)
    
    # add in reactive variable plot limits
    rv$min <- min(c(rv$SIGNAL_IP[,2], rv$SIGNAL_CO[,2]))
    rv$max <- max(c(rv$SIGNAL_IP[,2], rv$SIGNAL_CO[,2]))
    
    # Change plot limits in inputs
    updateNumericInput(session, "min", value = rv$min)
    updateNumericInput(session, "max", value = rv$max)
    
    #...........................................................................
    # Quality results
    #...........................................................................
    
    # Repartition
    id <- showNotification("Read repartition data", duration = NULL)
    rv$REPARTITION = read.table(paste0(rv$PATH,"/Repartition/ReadRepartition_",rv$CHROMOSOME[1],".txt"), sep = "\t", header = T)
    removeNotification(id)
    
    # Lorenz curve
    id <- showNotification("Read Lorenz curve data", duration = NULL)
    rv$LORENZ = read.table(paste0(rv$PATH,"/LorenzCurve/LorenzCurve_data_",rv$CHROMOSOME[1],".txt"), sep = "\t", header = T)
    removeNotification(id)
    
    # PBC
    id <- showNotification("Read PBC data", duration = NULL)
    rv$PBC =  as.matrix(read.table(paste0(rv$PATH,"/PBC/PBC.txt"), sep = "\t", header = T))
    removeNotification(id)
    
    if(!is.null(rv$Region)){
      SEQID = as.character(rv$Region[which(rv$Region[,2] == rv$CHROMOSOME[1]),1])
      rv$GFF_CHR = subset(rv$GFF, rv$GFF$seqid == SEQID & rv$GFF$type == "gene")
      
    }
    
  })
  
  observeEvent(input$ChromRadio,{
    if(!is.null(rv$REPARTITION)){
      rv$ChrSelected = input$ChromRadio
      rv$SubTableAll = subset(rv$allGenome,rv$allGenome[,1] == input$ChromRadio )
      
      rv$REPARTITION = read.table(paste0(rv$PATH,"/Repartition/ReadRepartition_",input$ChromRadio,".txt"), sep = "\t", header = T)
      rv$LORENZ = read.table(paste0(rv$PATH,"/LorenzCurve/LorenzCurve_data_",input$ChromRadio,".txt"), sep = "\t", header = T)
      
      rv$SIGNAL_IP = read.table(paste0(rv$PATH,"/bPeaks/Subdata/SubIP_",input$ChromRadio,".txt"), sep = "\t", header = F)
      rv$SIGNAL_CO = read.table(paste0(rv$PATH,"/bPeaks/Subdata/SubCO_",input$ChromRadio,".txt"), sep = "\t", header = F)
      
      # add in reactive variable plot limits
      rv$min <- min(c(rv$SIGNAL_IP[,2], rv$SIGNAL_CO[,2]))
      rv$max <- max(c(rv$SIGNAL_IP[,2], rv$SIGNAL_CO[,2]))
      
      # Change plot limits in inputs
      updateNumericInput(session, "min", value = rv$min)
      updateNumericInput(session, "max", value = rv$max)
      
      if(!is.null(rv$GFF)){
        SEQID = as.character(rv$Region[which(rv$Region[,2] == input$ChromRadio),1])
        rv$GFF_CHR = subset(rv$GFF, rv$GFF$seqid == SEQID
                            & rv$GFF$type == "gene")
      }
    }
  })
  
  
  output$Summary <- renderTable(
    if(!is.null(rv$SUMMARY)){
      rv$SUMMARY
    }else{
      return()
    }
  )
  
  #-----------------------------------------------------------------------------
  # Download buttons (data summary & bPeaks drawing)
  #-----------------------------------------------------------------------------
  
  output$DL_SUM <- downloadHandler(
    filename = function(){paste0(rv$FILENAME,"-",input$ChromRadio,"_dataSummary.pdf")},
    content = function(file) {
      file.copy(paste0(rv$PATH,"/bPeaks/",rv$FILENAME,"-",input$ChromRadio,"_dataSummary.pdf"), file)}
  )
  
  output$DL_DRAW <- downloadHandler(
    filename = function(){paste0(rv$FILENAME,"-",input$ChromRadio,"_bPeaksDrawing.pdf")},
    content = function(file) {
      file.copy(paste0(rv$PATH,"/bPeaks/",rv$FILENAME,"-",input$ChromRadio,"_bPeaksDrawing.pdf"), file)}
  )
  
  #-----------------------------------------------------------------------------
  # Genome Browser
  #-----------------------------------------------------------------------------
  
  output$GenomeBrowser<- renderPlotly({
    if(!is.null(rv$SIGNAL_IP)){
      
      if(length(nrow(rv$SubTableAll)) != 0){
        
        MAX = max(c(rv$SIGNAL_IP[,3], rv$SIGNAL_CO[,3]))
        rect_list <- list()
        
        compt = 0
        for(i in 1:nrow(rv$SubTableAll)){
          compt = compt + 1
          rect_list[[i]] <-
            list(type = "rect",layer = "bellow",
                 fillcolor = "gray", line = list(color = "gray"), opacity = 0.3,
                 x0 = rv$SubTableAll[i,2], x1 = rv$SubTableAll[i,3], xref = "x", name = paste("peak", i),
                 y0 = 0, y1 = (max(c(rv$SIGNAL_IP[,3], rv$SIGNAL_CO[,3])) * 1.1 ), yref = "y")
        }
        
        p <- plot_ly(x = rv$SIGNAL_IP[,2]) %>%
          add_trace(y = rv$SIGNAL_CO[,3], name = 'CO', type="scatter", mode = 'lines',line = list(color = 'royalblue')) %>%
          add_trace(y = rv$SIGNAL_IP[,3], name = 'IP', type="scatter", mode = 'lines', line = list(color = 'red'))%>%
          layout(shapes = rect_list, 
                 yaxis = list(title = 'Number of reads', showgrid = F),
                 xaxis = list(title = 'Position' , range = c(rv$min, rv$max), showgrid = F))
        
        if(!is.null(rv$GFF_CHR)){
          for(i in 1:nrow(rv$GFF_CHR)){
            
            #position_inter = as.numeric(as.character(rv$GFF_CHR$start[i])):as.numeric(as.character(rv$GFF_CHR$end[i]))
            position_inter = c(as.numeric(as.character(rv$GFF_CHR$start[i])),
                               as.numeric(as.character(rv$GFF_CHR$end[i])))
            
            if(rv$GFF_CHR$strand[i] == "+"){
              p <- add_trace(p,  
                             x = position_inter,
                             y = rep(-100,2) ,
                             type="scatter",
                             mode = 'lines',line = list(color = 'orange'),
                             text = gsub(";", "<br>", rv$GFF_CHR$attributes[i]) ,
                             hoverinfo = 'text',
                             showlegend = F
              )
              
              
              
            } else {
              p <- add_trace(p, type="scatter", 
                             x = position_inter,
                             y = rep(-200,2) ,
                             mode = 'lines',line = list(color = 'purple'),
                             text = gsub(";", "<br>", rv$GFF_CHR$attributes[i]) ,
                             hoverinfo = 'text',
                             showlegend = F
              )
            }
          }
        }
        p
        
      } else {
        plot_ly(x = rv$SIGNAL_IP[,2]) %>%
          add_trace(y = rv$SIGNAL_CO[,3], name = 'CO', type="scatter", mode = 'lines',line = list(color = 'red')) %>%
          add_trace(y = rv$SIGNAL_IP[,3], name = 'IP', type="scatter", mode = 'lines', line = list(color = 'royalblue'))%>%
          layout(yaxis = list(title = 'Number of reads'),
                 xaxis = list(title = 'Position' , range = c(rv$min, rv$max)))
      }
      
    } else {
      return()
    }
  })
  
  #-----------------------------------------------------------------------------
  # Genome browser limites
  #-----------------------------------------------------------------------------
  
  observeEvent(input$limite, {
    rv$min <- input$min
    rv$max <- input$max
  })
  
  #-----------------------------------------------------------------------------
  # Search gene
  #-----------------------------------------------------------------------------
  
  observeEvent(input$SearchGene, {
    chrInter = rv$Genes_Chromosome[ which(rv$Genes_Chromosome[,1] == input$SearchGeneList),2]
    
    if(paste0("chr",chrInter) %in% rv$CHROMOSOME){
      chrInter = paste0("chr",chrInter)
      updateRadioButtons(session, "ChromRadio",
                         selected = chrInter
      )
    } else if (paste0("chr",as.roman(chrInter)) %in% rv$CHROMOSOME ) {
      chrInter = paste0("chr",as.roman(chrInter))
      updateRadioButtons(session, "ChromRadio",
                         selected = chrInter
      )
    } else {
      shinyalert("No data was found for the chromosome of this gene.", type = "warning")
    }

    
  })
  
  #-----------------------------------------------------------------------------
  # Barplot : Number of detected peaks
  #-----------------------------------------------------------------------------
  
  output$peaks_barplot <- renderPlotly({
    if(!is.null(rv$allGenome)){
      t = sort(table(rv$allGenome[,1]))
      table <- data.frame(x = names(t),
                          y = as.vector(t))
      table$x <- factor(table$x, levels = names(t))
      
      plot_ly(data=table, x = ~x, y = ~y,name = NULL, type = "bar",
              marker = list(color = 'firebrick'),
              line = list(color = 'firebrick') ) %>%
        layout(paper_bgcolor='rgba(0,0,0,0)',margin = list(b = 50),
               plot_bgcolor='rgba(0,0,0,0)',
               yaxis = list(title = 'Number of detected peaks'),
               xaxis = list(title = ""))
    } else {
      return()
    }
    
  })
  
  #-----------------------------------------------------------------------------
  # Boxplot : Mean values of peaks
  #-----------------------------------------------------------------------------
  
  output$IPCO_boxplot <- renderPlotly({
    if(!is.null(rv$SubTableAll)){
      
      inter_final = cbind(c(rv$SubTableAll[,5], rv$SubTableAll[,6],rv$allGenome[,5], rv$allGenome[,6]),
                          
                          c(rep(input$ChromRadio, (length(rv$SubTableAll[,5])+ length(rv$SubTableAll[,6]))),
                            rep("Total", (length(rv$allGenome[,5]) + length(rv$allGenome[,6])))),
                          c(rep("IP", length(rv$SubTableAll[,5])),
                            rep("CO", length(rv$SubTableAll[,6])),
                            rep("IP", length(rv$allGenome[,5])),
                            rep("CO", length(rv$allGenome[,6]))))
      
      colnames(inter_final) = c("Value", "Focus", "Signal")
      inter_final = as.data.frame(inter_final)
      inter_final[,1] = as.numeric(as.character(inter_final[,1]))
      
      plot_ly(inter_final, x = ~Signal, y = ~Value, color = ~Focus, type = "box",colors = c('chartreuse',"forestgreen")) %>%
        layout(boxmode = "group") %>%
        layout(title = "Mean values of peaks")
      
    }else {
      return()
    }
  })
  
  #-----------------------------------------------------------------------------
  # Boxplot : Average LogFC
  #-----------------------------------------------------------------------------
  
  output$LOGFC_boxplot <- renderPlotly({
    if(!is.null(rv$SubTableAll) &&  !is.null(rv$allGenome)){
      
      plot_ly(type = 'box') %>%
        add_boxplot(y = rv$SubTableAll[,7],
                    marker = list(color = 'chartreuse'),
                    line = list(color = 'chartreuse'),
                    name = input$ChromRadio) %>%
        add_boxplot(y = rv$allGenome[,7], name = "All",
                    marker = list(color = 'forestgreen'),
                    line = list(color = 'forestgreen'))%>%
        layout(yaxis = list(title = "Average LogFC"), title = "Mean logFC of peaks")
      
    }else {
      return()
    }
  })
  
  #-----------------------------------------------------------------------------
  # Boxplot : Average quantile
  #-----------------------------------------------------------------------------
  
  output$QUANTILE_boxplot <- renderPlotly({
    if(!is.null(rv$SubTableAll) &&  !is.null(rv$allGenome)){
      
      plot_ly(type = 'box') %>%
        add_boxplot(y = rv$SubTableAll[,8],
                    marker = list(color = 'chartreuse'),
                    line = list(color = 'chartreuse'),
                    name = input$ChromRadio) %>%
        add_boxplot(y = rv$allGenome[,8], name = "All",
                    marker = list(color = 'forestgreen'),
                    line = list(color = 'forestgreen'))%>%
        layout(yaxis = list(title = "Average quantile"), title = "Mean quantile of peaks")
      
    }else {
      return()
    }
  })
  
  #-----------------------------------------------------------------------------
  # Barplot : Repartition of reads quantity
  #-----------------------------------------------------------------------------
  
  output$REPARTITION_barplot <- renderPlotly({
    if(!is.null(rv$SubTableAll) &  !is.null(rv$allGenome)){
      
      loessMod <- loess(rv$REPARTITION[,1] ~ rv$REPARTITION[,2],
                        data = rv$REPARTITION, span=0.1)
      smoothed <- predict(loessMod)
      
      plot_ly(
        x = rv$REPARTITION[,2],
        y = smoothed,
        name = "Loess",
        type = 'scatter', mode = 'lines',
        line = list(color = 'orange')
      )%>%
        add_bars(x=rv$REPARTITION[,2] , y = rv$REPARTITION[,1], name = 'Loess',
                 marker = list(color = 'purple'),
                 line = list(color = 'purple')) %>%
        layout(yaxis = list(title = "log(number of position)"),
               xaxis = list(title = "Number of reads"),
               title = "Repartition of reads quantity")
      
    }else {
      return()
    }
  })
  
  #-----------------------------------------------------------------------------
  # Plot : Lorenz curves
  #-----------------------------------------------------------------------------
  
  output$LORENZ_plot <- renderPlotly({
    if(!is.null(rv$SubTableAll) &  !is.null(rv$allGenome)){
      
      EM=which.max(abs(rv$LORENZ[,1]-rv$LORENZ[,2]))
      
      plot_ly(x=rv$LORENZ[,3],y=rv$LORENZ[,1], name='IP',type = 'scatter',mode= 'lines',
              line = list(color = 'red')) %>%
        add_trace(y= rv$LORENZ[,2],name='Control',  type="scatter", mode='lines',  
                  line = list(color = 'blue')) %>%
        add_trace(x=c(0,100),y= c(0,100),name='Equality', 
                  line = list(color = 'gray', width = 4, dash = 'dash'))%>%
        add_trace(x=c(rv$LORENZ[EM,3],rv$LORENZ[EM,3]),y= c(rv$LORENZ[EM,1],rv$LORENZ[EM,2]),name='Max. dif.',
                  line = list(color = 'black', width = 4), mode = 'lines')%>%
        add_trace(x=10,y= 80,
                  line = list(color = 'black', width = 4),type = 'scatter',
                  mode = 'text', text = paste("Maximum difference :",round(max(abs(rv$LORENZ[,1]-rv$LORENZ[,2])),1),"%"),
                  textposition = 'middle right',  showlegend = FALSE, 
                  textfont = list(color = '#000000', size = 16))%>%
        layout(yaxis = list(title = "Sum of window averages in %"),
               xaxis = list(title = "Average reads per window in %"),
               title = "Lorenz curves")
    }else {
      return()
    }
  })
  
  #-----------------------------------------------------------------------------
  # Plot : PBC
  #-----------------------------------------------------------------------------
  
  output$PBC_plot <- renderPlotly({
    if(!is.null(rv$PBC) & !is.null(rv$allGenome) & !is.null(rv$ChrSelected)){
      
      if(input$ChromRadio != "none")
        plot_ly(type = 'scatter', mode = 'markers') %>%
        add_trace(x = as.numeric(rv$PBC[,1]),
                  y = as.numeric(rv$PBC[,2]),
                  name = "Others", text = rv$PBC[,3],
                  marker = list(color = 'blue')) %>%
        add_trace(x = as.numeric(rv$PBC[which(rv$PBC[,3] == "ALL"),1]),
                  y = as.numeric(rv$PBC[which(rv$PBC[,3] == "ALL"),2]),
                  name = 'ALL', text = "ALL",
                  marker = list( color = 'forestgreen')) %>%
        add_trace(x = as.numeric(rv$PBC[which(rv$PBC[,3] == rv$ChrSelected),1]),
                  y = as.numeric(rv$PBC[which(rv$PBC[,3] == rv$ChrSelected),2]),
                  name = rv$ChrSelected, text = rv$ChrSelected,
                  marker = list(color = 'chartreuse')) %>%
        
        layout(yaxis = list(title = "PBC of CO"),
               xaxis = list(title = "PBC of IP"),
               title = "PBC")
    }else {
      return()
    }
  })
  
}

shinyApp(ui, server)
