
library(shiny)
library(leaflet)
library(RColorBrewer)
library(spData)
library(sf)
library(dplyr)

shinyServer(function(input, output) {
  
  data("world")
  
  
  # filter the data here
  filterdata <- reactive({

  world[world$continent==input$continent,]
  }) 
  
  
  bins <- seq(50,90,by=5)
  pal <- colorBin("YlOrRd", domain = world$lifeExp, bins=bins)
  
  
  output$map <- renderLeaflet({
    leaflet(world) %>% 
      addProviderTiles("MapBox",options = providerTileOptions(
        id = "mapbox.light",
        accessToken = Sys.getenv('MAPBOX_ACCESS_TOKEN'))) %>%
      setView(42, 16, 4)%>%
      addLegend(pal = pal, values = ~lifeExp, opacity = 0.7, title = NULL,
                position = "bottomright")
    
    # Fill in leaflet code here
    
  })

  observe({
    labels <- sprintf(
      "<strong>%s</strong><br/>%g years old (avg)",
      filterdata()$name_long, filterdata()$lifeExp
    ) %>% lapply(htmltools::HTML)
    leafletProxy("map", data=filterdata()) %>%
      clearShapes()%>%
      addPolygons(
        fillColor = ~pal(lifeExp),
        weight = 2,
        opacity = 1,
        color = "white",
        dashArray = "3",
        fillOpacity = 0.7,
        highlight = highlightOptions(
          weight = 5,
          color = "#666",
          dashArray = "",
          fillOpacity = 0.7,
          bringToFront = TRUE),label = labels,
        labelOptions = labelOptions(
          style = list("font-weight" = "normal", padding = "3px 8px"),
          textsize = "15px",
          direction = "auto"))
  })

  
})


