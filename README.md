# Canada - Interactive Map - Forward Sortation Area

Link to GitHub repository - https://github.com/ajayrao1983/CanadaGeoMapping

##Libraries Used:

* pacman
* data.table
* leaflet
* rgdal
* sp
* htmltools
* pdftools
* tidyverse
* scales
* shinydashboard
* DT


##Folder Structure and Files in Repository
.

|--Data

| |- fsa-list-april-2022.pdf

| |- T1201EN.CSV

| |- lfsa000b16a_e.dbf

| |- lfsa000b16a_e.prj

| |- lfsa000b16a_e.shp

| |- lfsa000b16a_e.shx

|--interactiveFSAGeoMapping

| |--data

| | |- shpFile.RData #Processed data. Refer code in file "GeoMappingFSAShiny.Rmd"

| |- app.R #Shiny App

|- GeoMappingFSAShiny.Rmd #Code to process the data in 'Data' folder

|- loadDashboardToShiny.Rmd #Code to load the shiny app to shinyapp.io server

|--README.md

##Project Description

This is an attempt at setting up an interactive Forward Sortation Area map on Shiny using the 2016 Census data