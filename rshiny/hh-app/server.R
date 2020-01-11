# Define server logic required to draw a histogram
shinyServer(function(input, output) { 

  for( ifile in list.files( pattern = '\\bs-.+[.][Rr]$', recursive = TRUE, full.names = TRUE ) ) source( ifile, local = TRUE )
  rm(ifile)
   
})
