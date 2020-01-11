require(easyr)
begin()

require(rgdal)
require(sf)

sf = read_sf( "data/WARDS_2015" )

require(leaflet)

sf %>% leaflet() %>%
  addProviderTiles("CartoDB.Positron") %>%
  addTiles()

#ggplot() + 
#  geom_sf( data = shapefile, size = 3, color = "black", fill = "cyan1" ) + 
#  coord_sf()

pnts <- data.frame(
  x = -88.223653,
  y = 38.6975481
)

apply(pnts, 1, function(row) {  
  
  # transformation to palnar is required, since sf library assumes planar projection 
  tt1_pl <- st_transform(tt1, 2163)   
  coords <- as.data.frame(matrix(row, nrow = 1, 
                                 dimnames = list("", c("x", "y"))))   
  pnt_sf <- st_transform(st_sfc(st_point(row),crs = 4326), 2163)
  # st_intersects with sparse = FALSE returns a logical matrix
  # with rows corresponds to argument 1 (points) and 
  # columns to argument 2 (polygons)
  
  tt1_pl[which(st_intersects(pnt_sf, tt1_pl, sparse = FALSE)), ] 
  
})

# https://gis.stackexchange.com/questions/282750/identify-polygon-containing-point-with-r-sf-package
findshape = function( sf, lat, lon ){
  
  # transformation to palnar is required, since sf library assumes planar projection 
  tt1_pl <- st_transform( tt1, 2163 )
  
  pnt_sf = pnt_sf <- st_transform( st_sfc( st_point( c( lat, lon ) ),crs = 4326), 2163 )
  
  return( sf[which(st_intersects(pnt_sf, tt1_pl, sparse = FALSE)), ] )
          
}

plotly::plot_ly( findshape( sf = tt1, lat = -87.6399770508392, lon = 41.8909861 ) )
