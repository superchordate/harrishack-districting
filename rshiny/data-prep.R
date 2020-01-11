require(easyr)
begin()

setwd('..')
source( 'processing.R' )

congress <- read_congress()
senate <- read_senate()

# download and unzip from https://data.cityofchicago.org/api/geospatial/sp34-6z76?method=export&format=Original
wards = read_sf( "data/WARDS_2015" ) %>%
    mutate( 
        WARD = as.integer( WARD ) 
    ) %>%
    inner_join(
        read.any( 'data/Aldermen - Sheet1.csv' ),
        by = c( 'WARD' = 'Ward' )
    )

save(
    congress, senate, wards,
    blue, red, ind, codes,
    file = 'rshiny/hh-app/source.RData'
)
