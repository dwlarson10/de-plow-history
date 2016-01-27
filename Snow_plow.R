setwd(dir = "Desktop/de-plow-history/data/")

require(jsonlite)
require(tidyr)
require(dplyr)

files <- list.files(full.names = TRUE)
snow <- data.frame()
for (i in files){
  
  snow <- rbind(snow,fromJSON(i))
}
snow <- tbl_df(snow)%>%group_by(id)

n<- table(factor(snow$name))
barplot(n)




