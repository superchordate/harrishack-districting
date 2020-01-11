require(easyr)
begin()

source( 'processing.R' )

congress <- read_congress()
senate <- read_senate()

save(
    congress, senate, 
    blue, red, ind, codes,
    congress_parliament_plot,
    file = 'source.RData'
)
