wdata = reactive({

    if( is.null(myward()) ) return(NULL)
      
      dt = myward()
      dt$geometry = NULL
      dt$SHAPE_Area = NULL
      dt$SHAPE_Leng = NULL
      dt = as.data.frame(dt)
  
      dt = data.frame(
        name = colnames( dt ),
        val = dt[ 1, ] %>% as.character()
      )
      rownames(dt) = dt$name

      return(dt)

})

output[[ 'warddata' ]] = renderUI({    

    if( !is.null(myward()) ){

        dt = wdata()

        adinfo = c( 
            "Took_Office", "Party", "Gender", "Race", "LGBTQ", "Age", "Max Degree Attained",
            "Field of Study", "Socialist_Caucus", "Black_Caucus", "Latino_Caucus",
            "LGBT_Caucus", "Disabled",
            "City Hall Office",  "City Hall Phone", "Email", "Fax", "Office", "Phone", "Ward Office"
        )

        print( rownames(dt))

      return(div(

          # Alderman.
          div(
              p( HTML( cc( 'Alderman: <strong>', dt[ 'Name', 2 ], '</strong>' ) ) ),
              div( style = 'display: inline-block; ', class = 'inline',
                  style = 'height: 200px; width: 200px; margin-top: 10px;  ',
                  img( src = dt[ 'Picture_URL', 2 ], style = 'max-width: 200px; max-height: 200px; ' )
              ),
              div( style = 'display: inline-block; ', tags$ul( lapply( adinfo, function(name) if( !is.na( dt[ name, 2 ] ) && dt[ name, 2 ] != 'NA' ) tags$li( 
                  cc( tools::toTitleCase( gsub( '_', ' ', name ) ), ": " ),
                  HTML( cc( '<strong>', dt[ name, 2 ], '</strong>' )  )
                )))
              )
          ),

         h3( 'Compactness Score' ),
          plotlyOutput( 'scores' ),

          # Income dist.
          h3( 'Demographics' ),
          plotlyOutput( 'chincome' )

      ))

    }

})
