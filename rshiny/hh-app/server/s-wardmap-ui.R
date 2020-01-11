output[[ 'wardmapui' ]] = renderUI({
    div(
      div( 
        style = 'width: 600px; max-width: 100%; ', 
        textInput(
          'address', label = NULL, placeholder = 'Enter Your Street Address', width = '100%', 
          value = '540 W Madison'
        ),
        onkeyup = JS('if( (event.keyCode ? event.keyCode : event.which) == "13" ) $("#subaddress").click();')
      ),
      div( actionButton( 'subaddress', label = 'Submit' ) ),    
      #uiOutput('latlng'),
      
      #br(),
      #div( 
      #  style = 'padding: 15px; background-color: white; display: inline-block; ',
      #  plotlyOutput( 'congress_parliament_plot', height = 300, width = 600 - 30 )
      #),

      div(
        uiOutput( 'wardlabel' )
      )
    )
})