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

    div(

      h1( 'No Quorum or Split-Vote', style = 'font-family: Oswald; font-size: 42pt; ' ),
      p( 'Explore your representation based on 2010 districts. ', style = 'font-size: 14pt;' ),

      br(),    
      div( 
        style = 'width: 600px; max-width: 100%; ', 
        textInput(
          'address', label = NULL, placeholder = 'Enter Your Street Address', width = '100%', 
          value = '540 W Madison'
        ),
        onkeyup = JS('if( (event.keyCode ? event.keyCode : event.which) == "13" ) $("#subaddress").click();')
      ),
      div( actionButton( 'subaddress', label = 'Submit' ) ),    
      #uiOutput('latlng'),
      
      #br(),
      #div( 
      #  style = 'padding: 15px; background-color: white; display: inline-block; ',
      #  plotlyOutput( 'congress_parliament_plot', height = 300, width = 600 - 30 )
      #),

      div(
        uiOutput( 'wardlabel' ), 
        style = 'max-width: 600px; height: 500px; margin-top: 10px;  ', leafletOutput( 'myward' ) 
      ),
      
      #div( style = 'margin: 15px; display: inline-block; ', 
      #  leafletOutput( 'congressmap', width = 800, height = 400  )
      #)

      
      h3( 
        'HarrisHack 2020', 
        style = 'font-family: Raleway; font-size: 16pt; position: fixed; bottom: 0; right: 0; padding: 15px; padding-right: 20pt; ' 
      )

    ),

    div(
    )

  )
  
))
