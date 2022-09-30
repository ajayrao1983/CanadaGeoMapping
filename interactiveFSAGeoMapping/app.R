# Load packages ----
library(shinydashboard)
library(data.table)
library(ggplot2)
library(DT)
library(leaflet)
library(htmltools)
library(rgdal)
library(scales)
library(tidyverse)

# Load Image File ----

load("data/shpFile.RData")

# Define UI for data upload app ----
ui <- dashboardPage(
  
  # App title ----
  dashboardHeader(title = "Forward Sortation Area Map"),
  
  # Sidebar layout with input and output definitions ----
  dashboardSidebar(
    sidebarMenu(
      menuItem("Interactive Map",
               tabName = "geoMap",
               icon = icon("map"))
    )
  ),
    
    # Main panel for displaying outputs ----
    dashboardBody(
      
      tabItems(
        tabItem(tabName = "geoMap",
                
                # Select province to display
                fluidRow(box(selectInput("prov", "Select Province",
                                       choices = unique(shpPopDT$Province),
                                       selected = "Ontario"),
                             height = 100,
                             width = 500)
                ),
                
                # Plot Map
                fluidRow(box(
                  leafletOutput("myMap", width = "100%", height = 500),
                             width = 500)
                  )
                
                )
      
    )
  )
)



# Define server logic to read selected file ----
server <- function(input, output) {
  
  plotDT <- reactive({
    
    DT1 <- shpPopDT[shpPopDT$Province == input$prov, ]
    
    return(DT1)

  })
  
  
  popDT <- reactive(
    {
      DT2 <- data.table(plotDT()@data)
      
      DT2$Population <- comma(DT2$Population)
      DT2$Dwellings <- comma(DT2$Dwellings)   
      
      return(DT2)
    }
    
    
  )



  ## Plotting the map
  output$myMap <- renderLeaflet(
    {
      
      latlonList <- list(
          "Nova Scotia" = c(-63.09, 45.23, 7),
          "Newfoundland and Labrador" = c(-57.73, 53.66, 5),
          "Prince Edward Island" = c(-63.21, 46.33, 7),
          "New Brunswick" = c(-66.21, 46.62, 6),
          "Quebec" = c(-71.69, 52.51, 5),
          "Ontario" = c(-84.81, 49.74, 5),
          "Manitoba" = c(-97.08, 55.15, 5),
          "Saskatchewan" = c(-105.90, 54.84, 5),
          "Alberta" = c(-114.81, 55.38, 5),
          "British Columbia" = c(-125.51, 55.07, 5),
          "Nunavut/Northwest Territories" = c(-108.63, 64.45, 5),
          "Yukon" = c(-136.12, 64.53, 5)
        )
    
    ## labels
    labs <- lapply(seq(nrow(popDT())), function(i) {
      paste0( '<p><b>', popDT()[i, "FSAName"], '</b></p><p>',
              "<i>Population: </i>", popDT()[i, "Population"],'</p><p>',
              "<i>Dwellings: </i>", popDT()[i, "Dwellings"], '</p>' )
    }
    )

    # Palette
    
    pal <- colorNumeric(
      palette = "Reds",
      domain = plotDT()$Population
      )
    
    
    
      leaflet(plotDT()) %>%
        addTiles() %>%
        setView(latlonList[[input$prov]][1],
                latlonList[[input$prov]][2],
                zoom = latlonList[[input$prov]][3]) %>%
        addPolygons(
          data = plotDT(),
          fillColor = ~pal(Population),
          weight = 2,
          opacity = 1,
          color = "white",
          dashArray = "3",
          fillOpacity = 0.7,
          highlightOptions = highlightOptions(
            weight = 5,
            color = "#666",
            dashArray = "",
            fillOpacity = 0.7,
            bringToFront = TRUE),
          label = lapply(labs, HTML),
          labelOptions = labelOptions(
            style = list("font-weight" = "normal", padding = "3px 8px"),
            textsize = "12px",
            direction = "auto")
        ) %>% addLegend(pal = pal, values = ~Population, opacity = 0.7, title = "Population",
                        position = "bottomleft")
    
    }
  )
}

# Create Shiny app ----
shinyApp(ui, server)