output[[ 'myward' ]] = renderLeaflet({    

    if( !is.null(myward()) ){

         #hatch <- hatched.SpatialPolygons(
         #   myward(),
         #   density = 2, angle = c(45, 135),
         #                                 fillOddEven = TRUE
        #)
 
        leaflet::leaflet(
            options = leafletOptions(zoomControl = FALSE)
        ) %>% 
            addProviderTiles( providers$Stamen.TonerLite ) %>%
            #setView(
            #    lat = latlon()[1,2], lng = latlon()[1,1], zoom = 13 
            #) %>%
            addMarkers( 
                latlon()[1,1],
                latlon()[1,2]
            ) %>%
            addPolygons(data = myward(), 
                        color = "#0066ff", 
                        fillOpacity = 0.5, 
                        weight = 1,
                        stroke = TRUE) %>%
            addPolylines(data = myward(),
                        fillOpacity = 0,
                        color = colors,
                        weight = 4,
                        stroke = TRUE) %>%
            addPolygons(data = myward(),
                        color = "#0066ff",
                        stroke = TRUE,
                        weight = 1,
                        fillOpacity = 0)

        #plot_ly( myward() ) %>% config(displayModeBar = F)
    }

})

# https://gis.stackexchange.com/questions/282750/identify-polygon-containing-point-with-r-sf-package
findshape = function( sf, lat, lon ){

    # transformation to palnar is required, since sf library assumes planar projection 
    sf <- st_transform( sf, 2163 )

    pnt_sf = pnt_sf <- st_transform( st_sfc( st_point( c( lat, lon ) ),crs = 4326), 2163 )

    return( sf[which(st_intersects(pnt_sf, sf, sparse = FALSE)), ] )

}

myward = reactive({
    if( is.null(latlon()) ) return(NULL)    
    findshape( wards, lat = latlon()[1,1], lon = latlon()[1,2] ) %>% st_transform( "+init=epsg:4326" )
})

output[[ 'wardlabel' ]] = renderUI({ 
    if( !is.null( myward() ) ) h3( cc( 'Ward ', myward()$WARD ) ) 
})