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

      return(div( style = 'width: 100%; ', 

          div(
            h3( 'Compactness Score' ),
            plotlyOutput( 'scores' )
          )
          ,

          # Income dist.
          div(
            h3( 'Demographics' ),
            plotlyOutput( 'chincome' )
          )

      ))

    }

})
