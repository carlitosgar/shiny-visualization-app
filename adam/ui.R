# Authors:
# Carlos García @ cm.garsua@gmail.com
# Adam Alpire @ am.rivero13@gmail.com


library(shiny)

shinyUI(fluidPage(
  titlePanel("Map distribution"),
  
  
  sidebarLayout(
    sidebarPanel(
      helpText("Create demographic maps with 
        information from the 2010 US Census."),
      
      selectInput("var", 
                  label = "Choose a variable to display",
                  choices = colnames(arrests[,3:length(arrests)]),
                  selected = "percent white"),
      
      checkboxInput("pob", "Relative to the poblation", 
                    value = FALSE)
      
    ),

    
    mainPanel(
      htmlOutput("map"),
      htmlOutput("chart")
      )
  )
))