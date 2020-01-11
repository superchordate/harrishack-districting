output[[ 'chincome' ]] = renderPlotly({
   
    dt = wdata()
    dt = dt[ grep( '_.+K$', rownames(dt), value = T ), ]
    dt$val = as.numeric( dt$val )
    dt$val = dt$val / sum( dt$val )
    dt %<>% 
      mutate( 
        sort = as.numeric( gsub( 'K', '', gsub( '^.+_', '', dt$name )) ) 
      ) 

    plot_ly(x = dt$val, y = ordered( dt$name, levels = rev( dt$name ) ), type = 'bar', orientation = 'h') %>%
     config(displayModeBar = F)

  })

output[[ 'scores' ]] = renderPlotly({
   
    dt = wdata()

    scores = c( "polsby_popper", "schwartzberg", "convex_hull", "reock" )
    scores = c( cc( scores, '_local' ), cc( scores, '_actual' ) )
    dt = dt[ scores, ]

    dt$val = as.numeric( dt$val )

    dt$type = ifelse( grepl( '_local', dt$name ), 'Compact', 'Actual' )
    dt$name = gsub( '_(local|actual)', '', dt$name )

    dt %<>% split( dt$type )
    #browser()

    #browser()
    plot_ly(
        x = dt[['Compact']]$val, y = dt[['Compact']]$name, name = 'Compact',
        type = 'bar', orientation = 'h'
    ) %>% add_trace( x = dt[['Actual']]$val, y = dt[['Actual']]$name, name = 'Actual' ) %>% config(displayModeBar = F)
})

output[[ 'gerrymanderscore' ]] = renderLeaflet({
   
    dt = wdata()

    scores = c( "polsby_popper", "schwartzberg", "convex_hull", "reock" )
    scores = c( cc( scores, '_local' ), cc( scores, '_actual' ) )
    dt = dt[ scores, ]

    dt$val = as.numeric( dt$val )

    ov = wards[ , scores ]
    
    for( scoretype in grep( '_actual', scores, value = T ) ){
        dtrow = which( dt$name == scoretype )
        dt = bind_rows(dt,
        data.frame( 
          name = cc( scoretype, '_rank' ), 
          val = which( 
            round( ov %>% pluck( scoretype ) %>% sort(), 4 ) == round( dt[ dtrow, 'val' ], 4 )
          )[1]
        ))
    }

})