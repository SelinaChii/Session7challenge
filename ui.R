
library(shiny)
library(leaflet)


shinyUI(
  
  bootstrapPage(
    tags$style(type = "text/css", "html, body {width:100%;height:100%}"),
    leafletOutput("map",height = "100%"),
    
    
    absolutePanel(top = 10, right = 10,
                  wellPanel(
                    h4("Life Expectancy by Country"),
                    # Add Shiny inputs for filtering here
                    selectInput("continent", label = h3("Select Continent"), 
                                choices = list("Oceania", "Africa","North America" ,         
                                               "Asia","South America","Europe" ,                
                                               "Seven seas (open ocean)", "Antarctica"))
                  )
    )
  ))
