uihead = function(){

    # Start with manual portions.
    ihead = tags$head(

        # Google fonts.
        HTML('<link href="https://fonts.googleapis.com/css?family=Open+Sans|Open+Sans+Condensed:300|Roboto|Roboto+Slab|Rubik" rel="stylesheet">')

    )

    # Add CSS, Javascript files from www/

        files.www =  list.files( 'www', full.names = TRUE ) %>% str_remove( 'www/' )
        files.css = files.www[ grepl( '[.]css$', files.www, ignore.case = TRUE ) ]
        files.js = files.www[ grepl( '[.]js$', files.www, ignore.case = TRUE ) ]

        for( icss in files.css ) ihead[[ length(ihead) + 1 ]] = HTML( cc( '<link rel="stylesheet" type="text/css" href="', icss, '">') )
        for( ijs in files.js ) ihead[[ length(ihead) + 1 ]] = HTML( cc( '<script src="', ijs, '"></script>') )

        rm( files.www, files.css, files.js, icss, ijs )
    
    return( ihead )
}