# Read in any user-interface files.
for( i in list.files( pattern = '\\bu-.+[.][Rr]$', recursive = TRUE, full.names = TRUE ) ) source(i)
rm(i)

# Define starting UI. Use a function to allow for bookmarking later on if necessary.
ui = function() shinyUI( fluidPage(
  
  uihead(),

  mainPanel( 
    
    width = 12, style = 'padding-top:15px', 

    plotlyOutput( 'congress_parliament_plot' )
    
  )
  
))
