# ui.R
# This Shiny app alculates drive times using the osrm package and displays those drive times 
# from a location (lat/long coordinate) using leaflet. 
# OSRM is a routing service based on OpenStreetMap data.
#

library(shiny)
library(rgeos)
library(osrm)
library(leaflet)
library(tidyverse)
library(rgdal)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
    
    # Application title
    titlePanel("Drive Time Example"),
    
    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            h3("Description"),
            h4("This Shiny app calculates and displays drive times from a location (lat/long coordinate) using the osrm package. OSRM is a routing service based on OpenStreetMap data."),
            h4("Please give it a moment to load."),
            h3("Instructions"),
            h4("To use this app, first enter coordinates in decimal degrees. Then, enter a minimum, maximum, and increment time in minutes. Finally click the 'Recalcuate Drive Times' button."),
            hr(),
            h3("Enter Coordinates"),
            numericInput("location_lat", "Latitude (decimal degrees)", value = 36.151),
            numericInput("location_lng", "Longitude (decimal degrees)", value = -115.176),
            hr(),
            h3("Set up Drive Time Parameters"),
            numericInput("minTime", "Minimum drive time (minutes)", value = 180),
            numericInput("maxTime", "Maximum drive time (minutes)", value = 240),
            numericInput("increTime", "Increment time (minutes)", value = 15),
            actionButton("calc", "Recalculate Drive Times"),
            hr(),
            "This app is partially based on the 'How to create drive time polygons in R' tutorial located here:",
            a("Tutorial", href="https://rstudio-pubs-static.s3.amazonaws.com/259089_2f5213f21003443994b28aab0a54cfd6.html")
            ),
        
        # Show a plot of the generated distribution
        mainPanel(
            leafletOutput("isochronePlot", height = "100vh")
        )
    )
))
