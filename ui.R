# Authors:
# Carlos García @ cm.garsua@gmail.com
# Adam Alpire @ am.rivero13@gmail.com

# Install:
#   install.packages("devtools")
#   devtools::install_github("jcheng5/googleCharts")
#   install.packages('googleVis')

library(shiny)
library(googleCharts)

shinyUI(navbarPage("Arrests US - 2010",
  tabPanel("Map",
    fluidPage(
      titlePanel("US Map"),
        sidebarLayout(
          sidebarPanel(
            helpText("Map by states to explore the arrests in 2010 (%). Click in a state for a pie chart."),
            selectInput("var", 
              label = "Choose a crime to explore",
              choices = colnames(arrests[,3:length(arrests)]),
              selected = "percent white"),
            checkboxInput("pob", "Display info by relative terms", 
              value = FALSE)
          ),
       mainPanel(
         htmlOutput("map"),
         htmlOutput("chart")
       )
      )
    )
  ),
  tabPanel("Bubble Chart",
    fluidPage(
      titlePanel("Arrests clustering."),
      sidebarPanel(
        helpText("Zoom, move and explore while clustering."),
        selectInput(
          'axisX', 'Axis X', 
          choices = colnames(arrests[,-c(1,2,33,34)]),
          selectize = FALSE,
          selected = "Violent"
        ),
        selectInput(
          'axisY', 'Axis Y', 
          choices = colnames(arrests[,-c(1,2,33,34)]),
          selectize = FALSE,
          selected = "Robbery"
        ),
        sliderInput(
          "cluster", "Number of clusters",
          min = 2, max = 6,
          value = 3, 
          animate = TRUE
        )
      ),
      mainPanel(
        googleChartsInit(),
        googleBubbleChart("bubbleChart",width="800px", height = "600px")
      )
    )
  )
))