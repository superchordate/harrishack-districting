require( shiny )
require( easyr )
require( plotly )

# clear variables to reset workspace.
rm( list= ls() )

# setwd(dirname(rstudioapi::getActiveDocumentContext()$path)) # set workspace to file location.

options(stringsAsFactors = FALSE)
Sys.setenv( TZ = 'America/Chicago' )

load('source.RData')
