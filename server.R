# Authors:
# Carlos García @ cm.garsua@gmail.com
# Adam Alpire @ am.rivero13@gmail.com

library(shiny)
source("helpers.R")
europe <- read.csv("./data/europe.csv")
#counties <- readRDS("data/counties.rds")
library(maps)
library(mapproj)

shinyServer(
  function(input, output) {
    output$map <- renderPlot({
      #args <- switch(input$var,
                     #"Percent White" = list(counties$white, "darkgreen", "% White"),
                     #"Percent Black" = list(counties$black, "black", "% Black"),
                     #"Percent Hispanic" = list(counties$hispanic, "darkorange", "% Hispanic"),
                     #"Percent Asian" = list(counties$asian, "darkviolet", "% Asian"))
      args <- list(europe$GDP, "darkgreen", "GDP")
      args$min <- input$range[1]
      args$max <- input$range[2]
      
      do.call(percent_map, args)
    })
  }
)