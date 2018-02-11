###############################################################################
##  Coursera Data Science Capstone Project
##  Text Predictor Application  
###############################################################################
## Shiny Application to collect input phrase from the user and display the next word
###############################################################################

library(shinythemes)
fluidPage( 
  h1("WORD PREDICTOR"),
  h3("Data Science Capstone Project"),
  theme = shinytheme("flatly"),
       sidebarPanel( 
         p(strong("Overview")),
         p('This is a text predictor application designed to predict the probable next word, when the user enters a phrase. The prediction model was trained and tested using dataset extracted from a corpus called HC Corpora. This corpus contained text from various blogs, news and twitter posts which were then cleaned and modelled for prediction.  ' )
       ), 
  conditionalPanel(condition="$('html').hasClass('shiny-busy')",
                   tags$div("Loading...",id="loadmessage")
  ),
       mainPanel( 
             tabsetPanel( 
                    tabPanel(p(icon("lightbulb-o"), "Predict Next Word"), 
                             h4("Please enter a word or phrase and click on PREDICT button below"), 
                             p('Please note only english language text is supported'), 
                             textInput("userInput", label="",value=""), 
                             submitButton(text="PREDICT",icon=NULL,width=NULL),
                             tags$hr(),
                             h5("Your phrase is interpreted as"), 
                             textOutput("you_entered"),
                             tags$hr(),
                              h4('The next probable word/s: '),
                             tableOutput("predictedWord")
                    ), 
                   tabPanel(p(icon("list-alt"), "About"), 
                            fluidRow(
                              
                              column(10,
                                    p("This application is designed as a part of Coursera Data Science Specilization Capstone project. The goal of the project is to build an application that will predict the next word for any given phrase."),
                                    p("The partners offering this project are"),
                                    tags$div(
                                      tags$ul(
                                        tags$li("Johns Hopkins University"),
                                        tags$li("Coursera"),
                                        tags$li("SwiftKey")
                                        
                                      )
                                    ),
                                    p("The data used for this project is downloaded from a corpus called HC Corpora. The corpora are collected from publicly available sources like blogs, news and twitter by a web crawler. Once the raw corpus has been collected, it is parsed further, to remove duplicate entries and split into individual lines. Approximately 50% of each entry is then deleted. The entries are anonymised and this is a non-profit venture that would fall under Fair Use.")
                            ))
                   ) 
               ),
             tags$hr()
         ) 
       ) 
