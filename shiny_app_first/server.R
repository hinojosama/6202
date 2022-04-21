library(shiny)
library(colourpicker)

#begin a code block for our shiny function. Note the brackets connote
#reactivity in this environment. Print to console when starts
shinyServer(function(input, output) {
    print("starting shiny server...")

   # assign output ycol and use render function to generate its content
   output$ycol <- renderUI({

     # begin making ycol content using lapply to apply a function to a list
     # in this case we are making the list with seq_along function and
     # user generated/ selected content input$variables. Then the function
     # colourInput will be applied to that list.
     lapply(seq_along(input$variables),
            function(vv)
              colourInput(
                inputId = paste0(input$variables [vv], "_color"),
                label = "specify color",
                palette = "limited",
                allowedCols = hcl.colors(12, palette = "Dark 3")
                # hcl.colors makes a vector of first argument specified length
                # using pre-selected colors from existing palette
                  ))

   })

   # gt_plot ----
   # assign output gTable_test and use render_gt function to generate its content
   output$gTable_test <- render_gt({

     #assign a variable name to the vector of the columns we will format in next step
     truncate_cols <- c("count_7_day_moving_avg", "change_in_7_day_moving_avg")

     #kept the preview function for now to decrease computational burden and lag
     gt_preview(dat1) %>%
       #continue the piped dat1 table and hide the columns specified in global
       #script variable hide
       cols_hide(hide) %>%
       #format the decimals for columns specified above
       fmt_number(all_of(truncate_cols), decimals = 1) %>%
       #fill in missing values
       fmt_missing(columns = everything(), missing_text = "Got data?") %>%
       #specified column will have a color scale applied to better illustrate
       data_color(columns = "total_case_daily_change",
                  colors = scales::col_numeric(palette = c('green', 'red'),
                                               domain = NULL)) %>%
       #specify elements of the tables style
       tab_style(style = list(
         cell_fill(color = "lightcyan"), cell_text(weight = "bold")),
         locations = cells_body(columns = c(change_in_7_day_moving_avg),
                                rows = change_in_7_day_moving_avg > 0)) %>%
       #relabel specified column using html note the `&nbsp;` spacing
       cols_label(deaths_under_investigation = html("Deaths&nbsp;Under&nbsp;Investigation"))
   })

   # distPlot ----
   # assign output distPlot and use renderPlotly function to generate its content
   output$distPlot <- renderPlotly({
   print("starting render plot...")

     #for each input$variable the user selects apply geom_line function to
     #its corresponding data
     geom_list <- lapply(input$variables, function(xx)
       geom_line(aes_string(y = xx), color = input[[paste0(xx, "_color")]], size = 1))

     #next make ggplot with reporting date on the x axis and the geom_list from above
     #goes on the y axis.  This is assigned to variable plt which is passed to the
     #ggplotly function to enable user interactivity
     plt <- ggplot(dat1, aes_string(x = "reporting_date")) +
       geom_list +
       ylab("Counts")
     ggplotly(plt)%>%
       layout(dragmode='select')

    })

   output$ycol_test <- renderUI({

     #see ycol above for explanation
     lapply(seq_along(input$variables),
            function(vv)
              colourInput(
                inputId = paste0(input$variables [vv], "_color"),
                label = "specify color",
                palette = "limited",
                allowedCols = hcl.colors(12, palette = "Dark 3")
                # hcl.colors makes a vector of first argument specified length
                # using pre-selected colors from existing palette
              ))

   })

   #distplot test ----
   # assign output distPlot_test and use render_gt function to generate its content
   output$distPlot_test <- render_gt({
     print("starting render plot...")

     #variable out is a subset of dat2_pvt the value in name colum is found in the
     #list created by user (input$gt_var) and (input$gt_col)
     out <- subset(dat2_pvt, name %in% input$gt_var)[,input$gt_col]  %>%
       #above is piped to the gt function making a gt object
       gt() %>%
       #cols_hide(hide_spark) %>%
       #use gt_sparkline function to make sparkline, histogram, density plot
       gt_sparkline (spark, same_limit = F) %>%
       gt_sparkline (hist, type = "histogram", same_limit = F) %>%
       gt_sparkline (dense, type = "density", same_limit = F) %>%
       #moving the columns and labeling in gt object
       cols_move(spark, after = name) %>%
       cols_label(name = md("**___________**"),
                  hist = html("span.style='color:red'>Histogram</span>"),
                  .list = list(med = "Median"))

    out

   })


#closes the shiny server function code block
})
