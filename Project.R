setwd("~/Coursera/Course9/project")

library(ggplot2)
library(shiny)
library(ggmap)
library(mapproj)
library(lattice)

getEarthQuakeData <- function(redo=FALSE){
    if (redo | !file.exists('data/EarthQuakesOK.rds')) {
        
        U1 <- "http://earthquake.usgs.gov/fdsnws/event/1/query.csv?starttime="
        U2 <- "-01-01%2000:00:00&latitude=35.2&longitude=-98.5&maxradiuskm=300&minmagnitude=1&eventtype=earthquake&endtime="
        U3 <- "-12-31%2023:59:59&orderby=time"
        
        EarthQuakes = data.frame()
        for (year in seq(from=2000,to=2015,by=1)){
            URL  <-  paste0(U1,year,U2,year,U3)
            print(URL)
            TMP <- read.csv(file(description = URL))
            print(dim(TMP))
            EarthQuakes <- rbind(EarthQuakes,TMP)
            Sys.sleep(1)
        }
        
        EarthQuakesOK <- EarthQuakes[grep('Oklahoma',EarthQuakes$place),]
        gd <- EarthQuakesOK$mag>0 & !is.na(EarthQuakesOK$mag)
        EarthQuakesOK <- EarthQuakesOK[gd,]
        EarthQuakesOK$year <- format(as.Date(EarthQuakesOK$time),'%Y')
        EarthQuakesOK$ptime <- as.POSIXct(sub('T',' ',EarthQuakesOK$time))
        EarthQuakesOK <- EarthQuakesOK[order(EarthQuakesOK$ptime),]
        
        save(EarthQuakesOK,file='data/EarthQuakesOK.rds')
        assign('EarthQuakesOK',EarthQuakesOK,envir = .GlobalEnv);
    } else {
        load(file = 'data/EarthQuakesOK.rds',envir = .GlobalEnv)
    }
    
    TD <- data.frame(year=EarthQuakesOK[EarthQuakesOK$ptime<max(EarthQuakesOK$ptime),c('year')])
    TD$start <- EarthQuakesOK[EarthQuakesOK$ptime<max(EarthQuakesOK$ptime),c('ptime')]
    TD$end <- EarthQuakesOK[EarthQuakesOK$ptime>min(EarthQuakesOK$ptime),c('ptime')]
    TD$diff <- as.numeric(TD$end-TD$start)/(24*60*60)
    assign('TD',TD,envir = .GlobalEnv);
    
    if (redo | !file.exists('data/map.rds')) {
        map <- get_map(location = c(lon = -97.75, lat = 35.9), zoom = 8, maptype = "roadmap")
        save(map,file='data/map.rds')
        assign('map',map,envir = .GlobalEnv)
    } else {
        load(file = 'data/map.rds',envir = .GlobalEnv)
    }
    
}

makeplots <- function(redo=FALSE){
    if (redo | !file.exists('data/plotList.rds') ){
        
        plotList = list()
        for (year in seq(from=2001,to=2015,by=1)) {
            TMP <- EarthQuakesOK[EarthQuakesOK$year==year,]
            mapPoints <- ggmap(map) + 
                geom_point(na.rm = TRUE,
                           aes(x = longitude, y = latitude, col=mag), 
                           data = TMP,
                           alpha=.4,size=2) +
                ggtitle(paste("Earthquakes in",year))+
                xlab("Longitude") +
                ylab("Latitude") +
                scale_colour_gradient(limits=c(1, 5), low="red", high="blue")
            
            plotList[[year-2000]] <- mapPoints
        }
        
        save(plotList,file='data/plotList.rds')
        assign('plotList',plotList,envir = .GlobalEnv)
    } else {
        if (!exists('plotList',envir = .GlobalEnv)){
            load(file = 'data/plotList.rds',envir = .GlobalEnv)
        }
    }
}

getPlot <- function(N){
    NN <- N-2000;
    plotList[NN]
}

getMagHist <- function(N){
    tmp  <- EarthQuakesOK$mag[EarthQuakesOK$year==N]
    if (length(tmp)>0){
        Hstg <- histogram(tmp
                          ,xlab=paste('Earthquake Magintude'),
                          ylab=paste('Percent of total during',N),
                          xlim=c(1,6)
        )
        return(Hstg)
    } else {
        Hstg <- histogram(-1,
                          xlab=paste('Earthquake Magintude'),
                          ylab=paste('Percent of total during',N),
                          xlim=c(1,6),ylim=c(0,100)
        )
        return(Hstg)
    }
}

getTDHist <- function(N){
    tmp  <- TD$diff[TD$year==N]
    if (length(tmp)>0){
        Hstg <- histogram(tmp
                          ,xlab=paste('Days before next earthquake'),
                          ylab=paste('Percent of total for',N)
        )
        return(Hstg)
    } else {
        Hstg <- histogram(-1,
                          xlab=paste('Days before next earthquake'),
                          ylab=paste('Percent of total during',N),
                          xlim=c(1,100),ylim=c(0,100)
        )
        return(Hstg)
    }
}

getEarthQuakeData()
makeplots()

print(getTDHist(2013))