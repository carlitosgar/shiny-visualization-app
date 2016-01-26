p1 <- rCharts$new()
p1$field('lib', 'parcoords')
p1$setLib("parcoords") 
p1$set(padding = list(top = 24, left = 0, bottom = 12, right = 200))
p1$set(data = toJSONArray(arrestsSubset, json = F), 
       colorby = 'State', 
       range = range(as.numeric(arrestsSubset$State)),
       colors = c('steelblue', 'brown')
)