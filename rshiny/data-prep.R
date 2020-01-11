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
    ) %>% 
    inner_join(
        read.any( 'data/chicago_income.csv' ) %>% select( -NA ),
        by = c( 'WARD' = 'ward' )
    )

idrw = read.any( 'data/Race-ineq-statistics-Export/Ideal-Race_Percentage_by_Ward.csv')
colnames(idrw) = cc( colnames(idrw), '_local' )
names(idrw)[1] = c( 'WARD' )

rdrw = read.any( 'data/Race-ineq-statistics-Export/Real-Race_Percentage_by_Ward.csv')
colnames(rdrw) = cc( colnames(rdrw), '_actual' )
names(rdrw)[1] = c( 'WARD' )

wards %<>% inner_join( idrw, by = 'WARD' ) %>% inner_join( rdrw, by = 'WARD' )

save(
    congress, senate, wards,
    blue, red, ind, codes,
    file = 'rshiny/hh-app/source.RData'
)
