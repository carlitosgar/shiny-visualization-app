# Authors:
# Carlos García @ cm.garsua@gmail.com
# Adam Alpire @ am.rivero13@gmail.com

library(shiny)
source("helpers.R")
arrests<- read.csv("../data/arrestsUSA2010.csv",sep=";")
# arrests<-(arrests[,5:ncol(arrests)-2])/1000*arrests[,2]*1000/rowSums(arrests[,5:ncol(arrests)-2])
# arrests<-round
names<- read.csv("../data/Nombres.csv",sep=";",header=F,stringsAsFactors = F)
arrests[is.na(arrests)] <- 0
arr2=data.frame(t(arrests))
colors <-random_colors(length(arrests)-2)
#colors<-cm.colors(length(arrests)-2, alpha = 1)
names(colors)<- colnames(arrests[,3:length(arrests)])
colors<- substr(colors,1,nchar(colors)-2)
print(colors)

library(maps)
library(mapproj)
library(googleVis)

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
    
    #PIE CHART / BAR CHART
    output$chart <- renderGvis({
        
        gvisPieChart(data <- dataInputChart() ,
          options=list(
            width="100%",
            height= 600,
            pieHole=0.3,
            title=paste('Doughnut chart of:',names[,1][input$region+1])
            )
          
        )
      
      
    })
  }
)



