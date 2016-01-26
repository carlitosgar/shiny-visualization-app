# Authors:
# Carlos García @ cm.garsua@gmail.com
# Adam Alpire @ am.rivero13@gmail.com


library(shiny)
require(rCharts)
shinyUI(fluidPage(
  titlePanel("Arrests 2010"),
  helpText("Create parallel coordinates chart with 
        information from the 2010 US Arrests"),
  showOutput("parcor","parcoords"),
  hr(),
  
  fluidRow(
    column(6,
           h4("Crimes Explorer"),
           selectizeInput(
             'crime', "",choices = colnames(arrests[,-c(1,2)]), 
             multiple = TRUE
           ),
           br()
    ),
    column(6,
           h4("States Explorer"),
           selectizeInput(
             'state', "",choices = as.character(arrests$State), 
             selected=as.character(arrests$State),
             multiple = TRUE
           )
    
  ))
    
    #mainPanel(showOutput("parcor","parcoords"))
  
))