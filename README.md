# earthquakes
A shiny app that show the location and time intervals between earthquakes in central/northern Oklahoma.

## Project URL
The compiled project may be veiwed at https://gdeyoung.shinyapps.io/project/
## Author
Gary De Young

## Description
This simple project shows the time between earthquakes and their location in 
central/northern portion of the state of Oklahoma. Also provided are the count, 
mean and standard of the magnitude, and the mean and standard deviation of the 
time between earthquakes. 

It is clear that as you browse the years that the number of earthquakes has 
dramatically increased in the last few years.

## Data
The data is collected from http://earthquake.usgs.gov/ in a circle of radius 300 
km and center at latitude of 35.2 and longitude of -98.5 with magnitude of 1 or 
greater and event type listed as "earthquake"


## R Libraries
Libraries that are used in the application are ggplot2, shiny, ggmap, mapproj, 
and lattice.

## Citations
1. ggmaps uses Google Maps for the map layer.
2. ggmaps is described in D. Kahle and H. Wickham. ggmap: Spatial Visualization with ggplot2. The R Journal, 5(1), 144-161. URL http://journal.r-project.org/archive/2013-1/kahle-wickham.pdf


