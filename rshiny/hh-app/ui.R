# Read in any user-interface files.
for( i in list.files( pattern = '\\bu-.+[.][Rr]$', recursive = TRUE, full.names = TRUE ) ) source(i)
rm(i)

# Define starting UI. Use a function to allow for bookmarking later on if necessary.
ui = function() shinyUI( fluidPage(
  
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "general.css"),
    tags$link(rel = "stylesheet", type = "text/css", href = "specific.css"),
    tags$link(rel = "stylesheet", type = "text/css", href = "shiny-override.css"),
    HTML( '<link href="https://fonts.googleapis.com/css?family=Oswald|Raleway|Open Sans&display=swap" rel="stylesheet">' ),
    tags$title( 'HarrisHack')
  ),

  mainPanel(
    
    h1( 'No Quorum or Split-Vote', style = 'font-family: Oswald; font-size: 42pt; ' ),
    p( 'Explore your representation based on 2010 districts. ', style = 'font-size: 14pt;' ),

    div( 

      div( class = 'col-md-3', 
      style = 'min-height: 750px;  min-width: 300px; vertical-align: top; ',

        br(),
        uiOutput('wardmapui'),
        
        #div( style = 'margin: 15px; display: inline-block; ', 
        #  leafletOutput( 'congressmap', width = 800, height = 400  )
        #)
    ),

    div( class = 'col-md-3',
      uiOutput('alderman')
    ),

    div(  class = 'col-md-3', 

      style = 'max-width: 48%; vertical-align: top; padding: 20px; ',
      uiOutput('warddata')
    ),

      
      h3( 
        'HarrisHack 2020', 
        style = 'font-family: Raleway; font-size: 16pt; position: fixed; bottom: 0; right: 0; padding: 15px; padding-right: 20pt; ' 
      )

  )
  )
  
))
