library(shiny)
library(colourpicker)

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
   output$gTable_test <- render_gt({
     truncate_cols <- c("count_7_day_moving_avg", "change_in_7_day_moving_avg")
     gt_preview(dat1) %>%
       cols_hide(c("globalid", "objectid")) %>%
       fmt_number(all_of(truncate_cols), decimals = 1) %>%
       fmt_missing(columns = everything(), missing_text = "Got data?")%>%
       data_color(columns = "total_case_daily_change",
                  colors = scales::col_numeric(palette = c('green', 'red'),
                                               domain = NULL)) %>%
       tab_style(style = list(
         cell_fill(color = "lightcyan"), cell_text(weight = "bold")),
         locations = cells_body(columns = c(change_in_7_day_moving_avg),
                                rows = change_in_7_day_moving_avg > 0)) %>%
       cols_label(deaths_under_investigation = html("Deaths&nbsp;Under&nbsp;Investigation"))
   })

   # distPlot ----
   output$distPlot <- renderPlotly({
   print("starting render plot...")

     geom_list <- lapply(input$variables, function(xx) geom_line(aes_string(y = xx), color = input[[paste0(xx, "_color")]], size = 1))

     plt <- ggplot(dat1, aes_string(x = "reporting_date")) +
       geom_list +
       ylab("Counts")
     ggplotly(plt)%>%
       layout(dragmode='select')

    })

   output$ycol_test <- renderUI({

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
#quick copy for tab 3 to test, doesnt plot yet
   output$distPlot_test <- renderPlotly({
     print("starting render plot...")

     geom_list <- lapply(input$variables, function(xx) geom_line(aes_string(y = xx), color = input[[paste0(xx, "_color")]], size = 1))

     plt <- ggplot(dat1, aes_string(x = "reporting_date")) +
       geom_list +
       ylab("Counts")
     ggplotly(plt)%>%
       layout(dragmode='select')

   })



})
