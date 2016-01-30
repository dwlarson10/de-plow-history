
#Set Directory and Load Packages
setwd(dir = "Desktop/de-plow-history/data/")

require(jsonlite)
require(tidyr)
require(dplyr)
require(ggmap)
require(ggplot2)

#import JSON Files and turn into Data.Frame
files <- list.files(full.names = TRUE)
snow <- data.frame()
for (i in files){
  snow <- rbind(snow,fromJSON(i))
}
snow <- tbl_df(snow)%>%group_by(id)%>%mutate(ts = as.POSIXct(asOf/1000,origin = "1970-01-01"))

#Exclude Stationary Snow Plows
snow2 <- subset(snow, snow$heading != "Stationary")

setwd(dir = "Desktop/de-plow-history/")
#Map of Delaware with Individual Points
D <- get_map(location = "Delaware", zoom = 8)
DE<- ggmap(D) + geom_point(aes(x = lon, y = lat), colour = "red", 
                     alpha = 0.1, size = 2, data = snow)
ggsave(DE, file = "DelawarePoints.png", width = 5, height = 4)


#Heat Map of Wilmington
Wilm <- get_map(location = "Wilmington", zoom = 11)
W<-ggmap(Wilm) + 
  geom_density2d(data = snow2, aes(x = lon, y = lat), size = 0.4) + 
  stat_density2d(data = snow2, aes(x = lon, y = lat, fill = ..level.., alpha = ..level..), size = 0.01, geom = "polygon") + scale_fill_gradient(low = "green", high = "red") + 
  scale_alpha(range = c(0, 0.4), guide = FALSE)
ggsave(W, file = "wilmMap.png", width = 5, height = 4)

#Heat Map of Lower Delaware
Low <- get_map(location = "Delaware", zoom = 9)
ld<-ggmap(Low) + 
  geom_density2d(data = snow2, aes(x = lon, y = lat), size = 0.4) + 
  stat_density2d(data = snow2, aes(x = lon, y = lat, fill = ..level.., alpha = ..level..), size = 0.01, geom = "polygon") + scale_fill_gradient(low = "green", high = "red") + 
  scale_alpha(range = c(0, 0.4), guide = FALSE)
ggsave(ld, file = "lwMap.png", width = 5, height = 4)
