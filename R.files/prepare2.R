# This is an update with the new data that runs to end 2013.  Vix has been removed. 
rm(list = ls())
da <- read.csv("Data/CEEUIP.csv", header = TRUE, stringsAsFactors = FALSE)
da$Date <- as.Date(da$Date, format = "%d/%m/%Y")
head(da)
str(da)
# call(prepare.R) # If needed------------------------------
require(zoo) # for lagging series
require(xtable) # to create table
# This calculates forward rate and the profits and creates data frame--------
forp <- function(fx, b, m){
  M <- paste(m, "MD", sep = "")
  ra1 <- paste(fx, M, sep = "")
  ra2 <- paste(b, M, sep = "")
  fw <- paste(ra1, "f", sep = "")
  # title can be uesd
  das <- subset(da, select = c(fx, b, ra1, ra2))
  das$fw <- ((1 + das[,3]/100)^(m/12))/((1 + das[,4]/100)^(m/12))*(das[,1]/das[,2])
  daz <- as.zoo(das, order.by = da$Date)
  daz$l1 <- lag(daz[,1], k = m)
  daz$l2 <- lag(daz[,2], k = m)
# I change the columns 8 and 7 to 7 and 6 in the following line because VIX has been removed. 
    daz$p <- (((daz[,1]/daz[,2])*(1 + daz[,3]/100)^(m/12))*(daz[,7]/daz[,6]))/
    (1 + daz[,4]/100)^(m/12)
  g <- list(data = daz, fx = fx, fund = b, period = M, profit = daz[,8])
  return(g)
}
a <- forp("HUF", "EUR", 1)
head(a$data)
title <- paste("Profits from ", a$fx, "-", a$fund, a$period, sep= "")
hist(a$profit, prob = TRUE, main = title, xlab = "Profit")
lines(density(a$profit, na.rm = TRUE), col = 'red', lwt = 2)
#This is an attempt to create a list of data that can be tested.  The test
# is in Raw.R
datalist <- list()
for(i in c("HUF", "PLN")){
  name <- paste(i, "EuR", sep = "")
  a <- forp(i, "EUR", 1)
datalist[i] <- list(name = a$data) 
}
names(datalist)
head(datalist$PLN)
# This now works.
datalist[[2]][1][[8]]
# to choose the second item in list, first row and eight element.
plot(datalist$HUF$p, main = title)
abline(h = 1, col = 'red')