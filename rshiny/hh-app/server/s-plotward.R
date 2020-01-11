output[[ 'myward' ]] = renderLeaflet({    

    if( !is.null(myward()) ){

         #hatch <- hatched.SpatialPolygons(
         #   myward(),
         #   density = 2, angle = c(45, 135),
         #                                 fillOddEven = TRUE
        #)

        sf = read_sf(cc( 'shapefiles/ward-', myward()$WARD, '.geojson' ))
 
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
            addPolygons(data = sf, 
                        color = c( "#ffffff", 'transparent' ), 
                        fillOpacity = 0.8, 
                        weight = 1,
                        stroke = TRUE) %>%
            addPolylines(data = sf,
                        color = c( '#ff7f0e', '#1f77b4' ),
                        weight = 4,
                        stroke = TRUE)

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
    if( !is.null( myward() ) ) {
        div(
            div( 
                style = ' margin-bottom: 5px; ', 
                div(
                    style = 'background-color: #bfbfbf;padding: 0px; ',
                    h3( 
                        cc( 'WARD ', myward()$WARD ), 
                        style = 'padding: 10px; font-family: Oswald; font-size: 20pt; color: White; '
                    )
                ),
                p( 
                    style='font-style: italic; color: #1f77b4; margin-top: 5px;', 
                    'Blue line = Compact (Theoretical) District' 
                ),
              div( 
                  style = 'max-width: 600px; height: 500px; margin-top: 10px;  ', 
                  leafletOutput( 'myward' ),
                 br(),
                p( 
                    'When the percentage of your race is your real district is much lower than that in the default district (blue circle), and the gerrymandering score is high, resence of your race might be lowered by the shape of the current district, you could check out the available resources for help.'    
                )
              )
    ))
    }
})