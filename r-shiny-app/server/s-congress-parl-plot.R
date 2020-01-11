congresspeople = reactive({

  congress %>%
    filter(!is.na(district)) %>%
    select(party, full_name, state, district) %>%
    arrange(party)

})

politicians = reactive({
  
    dt = data.frame( table( congresspeople()$party ) )
    names(dt) = c( 'party', 'seats' )
    dt %<>%
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
      
      dt %<>%
        parliament_data(type = "semicircle",
                      parl_rows = 10,
                      party_seats = .$seats) %>%
      mutate(full_name = congresspeople()$full_name,
            state = congresspeople()$state,
            district = congresspeople()$district,
            Politician = paste0(full_name,
                                " (", substr(party, 1, 1), "-", state, " ",
                                district, "th District)"))

  return(dt)

})

output[[ 'congress_parliament_plot' ]] = renderPlotly({ 

  interaction = TRUE
  
  parliament <- ggplot(politicians()) +
    aes(x, y, color = party_short, text = Politician) +
    geom_parliament_seats() + 
    geom_highlight_government(government == 0) +
    draw_majoritythreshold(n = 218, label = TRUE, type = 'semicircle') +
    theme_ggparliament() +
    labs(color = NULL, 
         title = "United States House of Representatives",
         subtitle = "Party that controls the House highlighted.") +
    scale_colour_manual(values = politicians()$color, 
                        limits = politicians()$party_short)

  parliament$layers[[1]] <- NULL

  if (interaction) {
    ggplotly(parliament, tooltip = "text")
  } else {
    parliament
  }
  
})

