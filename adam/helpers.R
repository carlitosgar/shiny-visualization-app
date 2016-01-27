# Authors:
# Carlos García @ cm.garsua@gmail.com
# Adam Alpire @ am.rivero13@gmail.com

random_colors <- function(n){
  colores <- rep(TRUE, n)
  for (i in 1:n){
    colores[i]<- hcl(h = ((((360*4)/n*i)+n/4*i)%%360), c = 1000, l = 100, 1, fixup = TRUE)
  }
  return(colores);
}

adjust <- function(data){
  #(dataInput()[1]<-dataInput()[1]/arrests[,ncol(arrests)])
  months <- split(data) 
  print(months)
}