output[[ 'myward' ]] = renderPlotly({    

    if( !is.null(myward()) ) plot_ly( myward() )

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
    findshape( wards, lat = latlon()[1,1], lon = latlon()[1,2] )
})

output[[ 'wardlabel' ]] = renderUI({ 
    if( !is.null( myward() ) ) h3( cc( 'Ward ', myward()$WARD ) ) 
})