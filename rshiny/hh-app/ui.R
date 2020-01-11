# Read in any user-interface files.
for( i in list.files( pattern = '\\bu-.+[.][Rr]$', recursive = TRUE, full.names = TRUE ) ) source(i)
rm(i)

# Define starting UI. Use a function to allow for bookmarking later on if necessary.
ui = function() shinyUI( fluidPage(
  
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "general.css"),
    tags$link(rel = "stylesheet", type = "text/css", href = "specific.css"),
    tags$link(rel = "stylesheet", type = "text/css", href = "shiny-override.css"),
    tags$title( 'HarrisHack')
  ),

  mainPanel( 
    
    div( style = 'margin: 15px; display: inline-block; ', 
      plotlyOutput( 'congress_parliament_plot', width = 800, height = 400  )
    )
  )
  
))
