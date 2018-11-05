# server.R
# This Shiny app alculates drive times using the osrm package and displays those drive times 
# from a location (lat/long coordinate) using leaflet. 
# OSRM is a routing service based on OpenStreetMap data.

library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    
    
    iso_dat <- eventReactive(input$calc,
                             {osrmIsochrone(loc = c(input$location_lng, input$location_lat), 
                                            breaks = seq(input$minTime, input$maxTime, input$increTime))},
                             ignoreNULL = FALSE)
    
    timebreaks <- eventReactive(input$calc,
                                {seq(input$minTime, input$maxTime, input$increTime)}, ignoreNULL = FALSE)
    
    locs <- eventReactive(input$calc,
                          {c(input$location_lng, input$location_lat)}, ignoreNULL = FALSE)
    
    output$isochronePlot <- renderLeaflet({
        validate(
            need(is.numeric(input$location_lng), "Please enter Longitude in decimal degrees format (dd.ddd)")
        )
        validate(
            need(is.numeric(input$location_lat), "Please enter Latitude in decimal degrees format (dd.ddd)")
        )
        
        iso <- iso_dat()
        
        faclevels <- c(paste(0, "to", timebreaks()[1], "min"), paste(timebreaks()[-length(timebreaks())], "to", timebreaks()[-1], "min"))
        iso@data$drive_times <-  factor(paste(iso@data$min, "to", iso@data$max, "min"), levels = faclevels)
        factpal <- colorFactor(rev(heat.colors(length(timebreaks()))), iso@data$drive_times)
        
        leaflet() %>% 
            setView(locs()[1], locs()[2], zoom = 7) %>%
            addProviderTiles("CartoDB.Positron", group="Greyscale") %>% 
            addMarkers(lng = locs()[1], lat = locs()[2], popup = "Start Location") %>% 
            addPolygons(fill=TRUE, stroke=TRUE, color = "black",
                        fillColor = ~factpal(iso@data$drive_times),
                        weight=0.5, fillOpacity=0.2,
                        data = iso, popup = iso@data$drive_times,
                        group = "Drive Time") %>% 
            # Legend
            addLegend("bottomright", pal = factpal, values = iso@data$drive_time,   title = "Drive Time")
    })
    
})
