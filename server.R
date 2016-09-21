# Authors:
# Carlos García @ cm.garsua@gmail.com
# Adam Alpire @ am.rivero13@gmail.com

# Install:
#   install.packages("devtools")
#   devtools::install_github("jcheng5/googleCharts")
#   install.packages('googleVis')

library(shiny)
library(googleCharts)
library(googleVis)
source("helpers.R")
source("global.R")

shinyServer(
  function(input, output) {
    #MAP
    dataInput <- reactive({
      if (input$pob) {
        myData <-data.frame(
          names,
          arrests[,input$var]/arrests[,ncol(arrests)]*100
        )
        names(myData)<-c("state","val")
        datminmax = data.frame(state=c("Min", "Max"), 
                               val=c(0, 0))
        myData <- rbind(myData[,1:2], datminmax)
      } else {
        myData <-data.frame(
          names,
          arrests[,input$var]/arrests[,2]*100
        )
        names(myData)<-c("state","val")
        datminmax = data.frame(state=c("Min", "Max"), 
                               val=c(0, 0))
        myData <- rbind(myData[,1:2], datminmax)
      }
      return(myData)
    })
    
    
    colorInput <- reactive({
      return(paste("{colors:['#F2F2F2','",colors[input$var],"']}",sep=""))
    })
    
    dataInputChart <- reactive({
      if (input$region){
        dataDoughnut <- data.frame(
          colnames(arrests[,5:length(arrests)-2]),
          t(arrests[input$region+1,5:length(arrests)-2]/arrests[5,2]*100))
        return(dataDoughnut)
      }
      else{
        dataDoughnut <- data.frame(
          colnames(arrests[,5:length(arrests)-2]),
          t(arrests[1,5:length(arrests)-2]/arrests[5,2]*100))
        return(dataDoughnut)
      }
    })
    
    output$map <- renderGvis({
      
      myData <- dataInput()
      color <- colorInput()
      gvisGeoChart(myData,
                   locationvar="state", colorvar="val",
                   options=list(region="US", displayMode="regions", 
                                resolution="provinces",
                                colorAxis=color,
                                gvis.listener.jscode = "
                                var sel = chart.getSelection()
                                var row=sel[0].row;
                                Shiny.onInputChange('region',row)
                                "
                                )
                   )    
    })
    
    #PIE CHART
    output$chart <- renderGvis({
        
        gvisPieChart(data <- dataInputChart() ,
          options=list(
            width="100%",
            height= 600,
            pieHole=0.3,
            title=paste('Doughnut chart of:',names[,1][input$region+1]),
            sliceVisibilityThreshold=0.03
            )
        )
    })

    # Clustering (Bubble Chart)
    selectedDataClustering <- reactive({
      arrests[, c(input$axisX, input$axisY)]
    })
    
    chartData <- reactive({
      # Put the columns in the order that Google's Bubble Chart expects
      # them (name, x, y, color, size).
      data <- arrests
      data$Cluster <- clusters()$cluster
      data <- data[,c("State",input$axisX,input$axisY,"Cluster","EstimatedPopulation")] 
    })
    
    clusters <- reactive({
        kmeans(selectedDataClustering(), input$cluster)
    })
    
    chartColors <- reactive({
      colorsClusters <- colorRampPalette(c("red", "yellow", "cyan","blue"))(input$cluster)
      return(structure(
        lapply(colorsClusters, function(color) { list(color=color) }),
        names = levels(as.factor(clusters()$cluster))
      ))
    })
    
    output$bubbleChart <- reactive({
      googleChartsInit()
      xlim <- list(
        min = 0,
        max = max(arrests[input$axisX]) + 1000
      )
      ylim <- list(
        min = 0,
        max = max(arrests[input$axisY]) + 1000
      )
      # Return the data and options
      list(
        data = googleDataTable(chartData()),
        series = chartColors(),
        options = list(
          title = sprintf(paste(input$axisX, "vs.",input$axisY)),
          # series = chartColors(),
          fontName = "Source Sans Pro",
          fontSize = 13,
          # Set axis labels and ranges
          hAxis = list(
            title = input$axisX,
            viewWindow = xlim
          ),
          vAxis = list(
            title = input$axisY,
            viewWindow = ylim
          ),
          # The default padding is a little too spaced out
          chartArea = list(
            top = 50, left = 75,
            height = "75%", width = "100%"
          ),
          # Allow pan/zoom
          explorer = list(),
          # Set bubble visual props
          bubble = list(
            opacity = 0.4, stroke = "none",
            # Hide bubble label
            textStyle = list(
              color = "none"
            )
          ),
          # Set fonts
          titleTextStyle = list(
            fontSize = 16
          ),
          tooltip = list(
            textStyle = list(
              fontSize = 12
            )
          )
        )
      )
    })
  }
)