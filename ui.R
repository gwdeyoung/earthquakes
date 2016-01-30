library(ggplot2)
library(shiny)
library(ggmap)
library(mapproj)
library(lattice)

shinyUI(pageWithSidebar(
    headerPanel("Oklahoma Earthquakes"),
    sidebarPanel(
        h4('Description'),
        p('Please wait for initial loading of plots and data. It may take a 
          minute or two.'),
        p('Displayed is the distribution of the time between quakes and the 
          location of the quakes that occurred in the chosen year in the area 
          around Oklahoma city and northward to the Kansas border.'),
        sliderInput('year', 'Select year (2000-2015)', 
                     2008,
                     min = 2001,
                     max = 2015,
                     step = 1,round=True,sep=''),
        h4('Summary Statistics'),
        p('Count'),
        verbatimTextOutput("count"),
        p('Magnitude'),
        verbatimTextOutput("mag"),
        p('Days between quakes'),
        verbatimTextOutput("time")
    ),
    mainPanel(
        h4('Time between earthquakes'),
        plotOutput('newHist'),
        h4('Earthquake location'),
        plotOutput('newLocation')
    )
))