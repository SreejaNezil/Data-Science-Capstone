#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

source("predict.R")
# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
    userText <- reactive({
      validate(
        need(input$userInput != "", "Please enter a phrase or a word")
      )
      textInput <- input$userInput
    cleanedUserText <- cleanInputText(textInput)
    }
    
  )
   
  output$you_entered <- renderText({ userText() })
  output$predictedWord <- renderTable({ predictNextWord(input$userInput) })
  
})
