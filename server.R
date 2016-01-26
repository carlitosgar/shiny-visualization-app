# Authors:
# Carlos García @ cm.garsua@gmail.com
# Adam Alpire @ am.rivero13@gmail.com

library(shiny)
require(rCharts)
source("helpers.R")
arrests <- read.csv("./data/arrestsUSA2010.csv", sep=";")
pal <- colorRampPalette(c("red", "yellow", "cyan","blue"))(nrow(arrests$Total))
library(maps)
library(mapproj)

shinyServer(
  function(input, output) {
    output$parcor <- renderChart({
      show <- c("State",input$crime,"Total")
      states <- arrests[ which( arrests$State %in% input$state) , show]
      p1 <- rCharts$new()
      p1$field('lib', 'parcoords')
      p1$setLib("parcoords") 
      p1$set(padding = list(top = 24, left = 150, bottom = 12, right = 0))
      p1$set(data = toJSONArray(states, json = F), 
             colorby = 'Total', 
             range = range(as.numeric(arrests$State)),
             colors = pal
      )
      p1$addParams(dom = 'parcor')
      return(p1)
    })
    #output$map <- renderPlot({
      #args <- switch(input$var,
                     #"Percent White" = list(counties$white, "darkgreen", "% White"),
                     #"Percent Black" = list(counties$black, "black", "% Black"),
                     #"Percent Hispanic" = list(counties$hispanic, "darkorange", "% Hispanic"),
                     #"Percent Asian" = list(counties$asian, "darkviolet", "% Asian"))
      #args$min <- input$range[1]
      #args$max <- input$range[2]
      
      #do.call(percent_map, args)
    #})
  }
)