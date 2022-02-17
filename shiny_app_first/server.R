library(shiny)
library(colourpicker)

shinyServer(function(input, output) {
    print("starting shiny server...")

   # assign output ycol and use render function to generate its content
   output$ycol <- renderUI({
     
     # begin making ycol content using lapply to apply a function to a list
     # in this case we are making the list with seq_along function and 
     # user generated/ selected content input$variables. Then the function
     # colourInput will be applied to that list. ??Why does it need the
     # "function(vv)"? why not just have the second argument as the function?
     lapply(seq_along(input$variables), 
            function(vv) 
              
              #the colourInput function accepts the following arguments:
              # inputId, 
              # label,
              # value = "white",
              # showColour = c("both", "text", "background"),
              # palette = c("square", "limited"),
              # allowedCols = NULL,
              # allowTransparent = FALSE,
              # returnName = FALSE,
              # closeOnClick = FALSE
      
              colourInput(
                inputId = paste0(input$variables [vv], "_color"),
                label = "specify color",
                palette = "limited", #must be set to limited for 
                # allowedCols to work
                allowedCols = hcl.colors(12, palette = "Dark 3")
                # allowedCols would not directly take = "Dark 3" probably 
                # because the length is not specified
                # hcl.colors makes a vector of first argument specified length 
                # using pre-selected colors from existing palette
                  ))
     
   })
  
   output$distPlot <- renderPlotly({
   print("starting render plot...")
     
     geom_list <- lapply(input$variables, function(xx) geom_line(aes_string(y = xx), color = input[[paste0(xx, "_color")]], size = 1))
     
     plt <- ggplot(dat1, aes_string(x = "reporting_date")) + 
       geom_list +
       ylab("Counts")
     ggplotly(plt)%>%
       layout(dragmode='select')
     
    })

})
