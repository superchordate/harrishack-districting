if(F) output[[ 'congressmap' ]] = renderLeaflet({
    
    popup <- paste(sep = "<br/>",
        paste0("<b>Representative: </b>", congress$full_name),
        paste0("<b>State: </b>", congress$state),
        paste0("<b>District: </b>", congress$district))

    pal <- colorFactor(c(blue, ind, red), congress$party)

    congress %>% select( geom, party ) %>% leaflet() %>%
        setView(
            lat = 37.8283, lng = -98.5795, zoom = 4
        ) %>%
        addPolygons(
            fillColor = ~pal(party), 
            color = "black", 
            fillOpacity = 0.5, 
            weight = 2,
            popup = popup
        )


})