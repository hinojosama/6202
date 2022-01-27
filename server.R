#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    print("starting shiny server...")
   
   output$distPlot <- renderPlot({
   print("starting render plot...")
      
     # draw the plot with the specified number of bins
     ggplot(data = faithful) +
       geom_dotplot(mapping = aes(x = waiting), binwidth = input$bins, fill = "orange") +
       labs(title = "Waiting Times Frequency")
     
    })

})
