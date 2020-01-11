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

gm = read.any( 'data/local_gerry.csv')
names(gm) = cc( names(gm), '_local' )
wards %<>% left_join( gm, by = c( 'WARD' = 'ward_local') ) 

gm = read.any( 'data/real_gerry.csv' )
names(gm) = cc( names(gm), '_actual' )
wards %<>% left_join( gm, by = c( 'WARD' ='ward_actual' ) ) 

ci = read.any( 'data/ward_contact_info.csv' )
wards %<>% left_join( ci , by = c( 'WARD' = 'ward'  ) )

wards %<>% left_join( idrw, by = 'WARD' ) %>% inner_join( rdrw, by = 'WARD' )

save(
    wards,
    file = 'rshiny/hh-app/source.RData'
)
