## geocoding function using OSM Nominatim API
## details: http://wiki.openstreetmap.org/wiki/Nominatim
## made by: D.Kisler 
# https://datascienceplus.com/osm-nominatim-with-r-getting-locations-geo-coordinates-by-its-address/

require(jsonlite)

nominatim_osm <- function(address = NULL)
{
  if(suppressWarnings(is.null(address)))
    return(data.frame())
  tryCatch(
    d <- jsonlite::fromJSON( 
      gsub('\\@addr\\@', gsub('\\s+', '\\%20', address), 
           'http://nominatim.openstreetmap.org/search/@addr@?format=json&addressdetails=0&limit=1')
    ), error = function(c) return(data.frame())
  )
  if(length(d) == 0) return(data.frame())
  return(data.frame(lon = as.numeric(d$lon), lat = as.numeric(d$lat)))
}

latlon = reactive({

    # reactivity.
    t = input$subaddress

    addr = isolate( input$address )
    if( is.null(addr)) return(NULL)

    if( nchar( addr ) > 0 ) {

      if( !grepl( 'chicago', addr, ignore.case = TRUE ) ) addr %<>% cc( ', Chicago, IL' )

      return( nominatim_osm( addr ) )

    }

})

output[[ 'latlng' ]] = renderUI({
    t = input$subaddress
    p( paste0( latlon(), collapse = ', ' ) )
})
