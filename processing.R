# Daniel Silva-Inclan (badbayesian@gmail.com)

# Libraries
require(tidyverse) # df manipulation
require(tigris) # Census shapefile API
require(leaflet) # Interactive maps
require(ProPublicaR) # US voting API
require(stringi) # String manipulation
require(ggparliament) # Plotting parliament
require(jsonlite) # read JSON
require(plotly) # Interactive plots
require(sf) # Spatial manipulation
require(lwgeom) # Shape calculation
require(HatchedPolygons) # Hatched polygon ploting

# Hatching only works with sp...
options(tigris_class = "sp")
options(tigris_use_cache = TRUE)
state_sp <- states()

# sf works closers to a df
options(tigris_class = "sf")
congress_sf <- congressional_districts()
state_sf <- states()

# Political colors
blue <- "#3333FF"
red <- "#E81B23"
ind <- "#B4B4B4"

# Data (ignore this unless you're trying to rebuild the data)
#legislators <- read_csv("data/legislators-current.csv")
#committees <- fromJSON("data/committees-current.json") %>%
#  as_tibble()
#committees$membership <- NA
#membership <- fromJSON("data/committee-membership-current.json")
#committees$membership <- sapply(seq_len(nrow(committees)),
 #                               function(i) membership[committees$thomas_id[i]])


codes <- fips_codes %>%
  select(state, state_code, state_name) %>%
  unique()

#' Compactness measures
#'
#' Calculates polsby_popper, schwartzberg, convex_hull, and reock measures for
#' a given shapefile.
#' @param district shapefile
compactness_measures <- function(district) {
  area <- st_area(district)
  perimeter <- st_length(district)
  polsby_popper <- 4 * pi * area / (perimeter**2)
  schwartzberg <- 2 * pi * sqrt(area / pi) / perimeter
  convex_hull <- area / st_area(st_convex_hull(district))
  reock <- area / st_area(st_minimum_bounding_circle(district))
  tibble(polsby_popper, schwartzberg, convex_hull, reock)
}

#' From legislators df, wrangle information about the US house
#' @param gerrymandering Defaults False
setup_congress <- function(gerrymandering=FALSE,
                           save_loc = paste0(getwd(), "/data/congress/congress.gpkg"),
                           overwrite = FALSE) {
  politicians <- legislators %>%
    filter(!is.na(district)) %>%
    left_join(codes, by = "state")
  congress <- congress_sf
  congress$district <- stri_match_first_regex(congress$NAMELSAD, "[0-9]+") %>%
    as.integer() %>%
    ifelse(is.na(.), 0, .)
  congress <- geo_join(congress, politicians,
                       by_sp = c("STATEFP", "district"),
                       by_df = c("state_code", "district"), how = "inner")
  if (gerrymandering) {
    congress <- congress %>%
      bind_cols(compactness_measures(.$geometry))
  }
  st_write(congress, save_loc, delete_dsn = overwrite)
}


congress_map <- function(congress){
  popup <- paste(sep = "<br/>",
                 paste0("<b>Representative: </b>", congress$full_name),
                 paste0("<b>State: </b>", congress$state),
                 paste0("<b>District: </b>", congress$district))
  pal <- colorFactor(c(blue, ind, red), congress$party)
  leaflet(congress) %>%
    addProviderTiles("CartoDB.Positron") %>%
    setView(lat = 37.8283, lng = -98.5795, zoom = 4) %>%
    addTiles() %>%
    addPolygons(fillColor = ~pal(party), 
                color = "black", 
                fillOpacity = 0.5, 
                weight = 2,
                popup = popup)
}

congress_parliament_plot <- function(congress, red, interaction=TRUE){

  congresspeople <- congress %>%
    filter(!is.na(district)) %>%
    select(party, full_name, state, district) %>%
    arrange(party)

  politicians = data.frame( table( congresspeople$party ) )
    names(politicians) = c( 'party', 'seats' )

  politicians %<>%
      mutate(
        year = 2018,
        country = "USA",
        house = "Representatives",
        color = case_when(party == "Republican" ~ red,
                              party == "Democrat" ~ blue,
                              TRUE ~ ind),
        party_short = case_when(party == "Republican" ~ "GOP",
                                    party == "Democrat" ~ "Dem",
                                    TRUE ~ "Ind"),
        government = case_when(party == "Republican" ~ 1,
                                    party == "Democrat" ~ 0,
                                    TRUE ~ 2)) %>%
      ungroup()
      
      politicians %<>%
        parliament_data(type = "semicircle",
                      parl_rows = 10,
                      party_seats = .$seats) %>%
      mutate(full_name = congresspeople$full_name,
            state = congresspeople$state,
            district = congresspeople$district,
            Politician = paste0(full_name,
                                " (", substr(party, 1, 1), "-", state, " ",
                                district, "th District)"))
  
  parliament <- ggplot(politicians) +
    aes(x, y, color = party_short, text = Politician) +
    geom_parliament_seats() + 
    geom_highlight_government(government == 0) +
    draw_majoritythreshold(n = 218, label = TRUE, type = 'semicircle') +
    theme_ggparliament() +
    labs(color = NULL, 
         title = "United States House of Representatives",
         subtitle = "Party that controls the House highlighted.") +
    scale_colour_manual(values = politicians$color, 
                        limits = politicians$party_short)

  parliament$layers[[1]] <- NULL
  if (interaction) {
    ggplotly(parliament, tooltip = "text")
  } else {
    parliament
  }
  
}

read_congress <- function(save_loc =
                            paste0(getwd(), "/data/congress/congress.gpkg")){
  st_read(save_loc)
}

setup_senate <- function(gerrymandering=FALSE,
                         save_loc = paste0(getwd(), "/data/senate/senate.gpkg"),
                         delete_dsn = FALSE){
  politicians <- legislators %>%
    filter(type == "sen")
  
  second_senators <- politicians %>%
    select(full_name, state, senate_class, party) %>%
    group_by(state) %>%
    arrange(senate_class) %>%
    slice(1) %>%
    ungroup() %>%
    arrange(state)
  
  first_senators <- politicians %>%
    filter(!full_name %in% second_senators$full_name) %>%
    arrange(state)
  
  senators <- politicians %>%
    select(full_name, party, state) %>%
    group_by(state) %>%
    mutate(party_merged = paste0(party, collapse = " "),
           base_color =
             case_when(party_merged == "Republican Republican" ~ red,
                       party_merged == "Democrat Republican" ~ red,
                       party_merged == "Republican Democrat" ~ blue,
                       party_merged == "Democrat Democrat" ~ blue,
                       party_merged == "Independent Democrat" ~ blue,
                       party_merged == "Republican Independent" ~ ind),
           secondary_color =
             case_when(party_merged == "Democrat Republican" ~ blue,
                       party_merged == "Republican Democrat" ~ red,
                       party_merged == "Independent Democrat" ~ ind,
                       party_merged == "Republican Independent" ~ red,
                       TRUE ~ NA_character_)) %>%
    slice(1) %>%
    ungroup() %>%
    select(state, party_merged, base_color, secondary_color) %>%
    arrange(state) %>%
    mutate(senators = paste0(first_senators$full_name,
                             " (", substr(first_senators$party, 1, 1), ") and ",
                             second_senators$full_name,
                             " (", substr(second_senators$party, 1, 1), ")"))
  
  senate <- state_sf %>%
    geo_join(senators,
             by_sp = "STUSPS",
             by_df = "state")
  if (gerrymandering) {
    senate <- senate %>%
      mutate(polsby_popper = 0.0,
             schwartzberg = 0.0,
             convex_hull = 0.0,
             reock = 0.0) %>%
      mutate_at(c("polsby_popper", "schwartzberg", "convex_hull", "reock"),
                compactness_measures(.$geometry))
  }
  st_write(senate, save_loc, delete_dsn = overwrite)
}

senate_map <- function(senate){

  names <- str_split(senate$senators, " and ", simplify = TRUE)

  popup <- paste(sep = "<br/>",
                 paste0("<b>State: </b>", senate$STUSPS),
                 paste0("<b>Senator 1: </b>", names[,1]),
                 paste0("<b>Senator 2: </b>", names[,2]))
  
  partisan_states <- filter(senate, !is.na(secondary_color))
  partisan_states_sp <- subset(state_sp, STUSPS %in% partisan_states$STUSPS)
  senate.hatch <- hatched.SpatialPolygons(partisan_states_sp,
                                          density = 2, angle = c(45, 135),
                                          fillOddEven = TRUE)
  # HOT FIX (TODO correct merging)
  colors <- partisan_states$secondary_color
  colors[2] = blue
  colors[10] = ind
  
  leaflet() %>%
    addProviderTiles("CartoDB.Positron") %>%
    setView(lat = 37.8283, lng = -98.5795, zoom = 4) %>%
    addTiles() %>%
    addPolygons(data = senate,
                fillColor = senate$base_color, 
                color = "black", 
                fillOpacity = 0.5, 
                weight = 1,
                stroke = TRUE) %>%
    addPolylines(data = senate.hatch,
                 fillOpacity = 0,
                 color = colors,
                 weight = 4,
                 stroke = TRUE) %>%
    addPolygons(data = senate,
                popup = popup,
                color = "black",
                stroke = TRUE,
                weight = 1,
                fillOpacity = 0)
                
}

senate_parliament_plot <- function(senate, interaction=TRUE){
  
  senators <- senate %>%
    #filter(type == "sen") %>%
    select(party_merged, NAME, STUSPS) %>%
    arrange(party_merged)

  politicians <- senators %>%
    select(party_merged) %>%
    group_by(party_merged) %>%
    count(name = "seats") %>%
    mutate(year = 2018,
           country = "USA",
           house = "Senate",
           color = case_when(party_merged == "Republican" ~ red,
                             party_merged == "Democrat" ~ blue,
                             TRUE ~ ind),
           party_short = case_when(party_merged == "Republican" ~ "GOP",
                                   party_merged == "Democrat" ~ "Dem",
                                   TRUE ~ "Ind"),
           government = case_when(party_merged == "Republican" ~ 0,
                                  party_merged == "Democrat" ~ 1,
                                  TRUE ~ 2)) %>%
    ungroup() %>%
    parliament_data(type = "semicircle",
                    parl_rows = 4,
                    party_seats = .$seats) %>%
    mutate(full_name = senators$NAME,
           state = senators$STUSPS,
           Politician = paste0(full_name,
                               " (", substr(party_merged, 1, 1), "-", state, ")"))
                               
  parliament <- ggplot(politicians) +
    aes(x, y, color = party_short,
        text = Politician) +
    geom_parliament_seats() +
    geom_highlight_government(government == 0) +
    draw_majoritythreshold(n = 51, label = TRUE, type = 'semicircle') +
    theme_ggparliament() +
    labs(color = NULL,
         title = "United States Senate",
         subtitle = "Party that controls the Senate highlighted.") +
    scale_colour_manual(values = politicians$color,
                        limits = politicians$party_short)
  parliament$layers[[1]] <- NULL
  if (interaction) {
    ggplotly(parliament, tooltip = "text")
  } else {
    parliament
  }
}

read_senate <- function(save_loc = paste0(getwd(), "/data/senate/senate.gpkg")){
  st_read(save_loc)
}


# setup_congress(gerrymandering = TRUE, overwrite = TRUE)
