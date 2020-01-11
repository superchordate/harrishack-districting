require(easyr)
begin()

setwd('..')
source( 'processing.R' )

congress <- read_congress()
senate <- read_senate()

save(
    congress, senate, 
    blue, red, ind, codes,
    file = 'rshiny/app/source.RData'
)
