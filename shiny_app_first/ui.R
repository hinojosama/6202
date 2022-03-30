library(shiny)
library(shinythemes)
library(colourpicker)
library(shinyBS)
library(plotly)

#theme = shinytheme("superhero"),
shinyUI(fluidPage(titlePanel("Shiny COVID19 Dashboard"),
      tabsetPanel(
      tabPanel("The Name",
        sidebarLayout(
          sidebarPanel(
            selectInput('variables', "Select plot(s)", colnames(dat1)[-(1:3)],
                      multiple = TRUE,
                      selectize = TRUE,
                      selected = colnames(dat1)[4]),
          # preloads/matches choices on typing
          # input selector populated with column names from dat1 dataframe, specifically
          # all column names except the first three.
          # the selectInput definition: function (inputId, label, choices, selected = NULL, multiple = FALSE,
          # selectize = TRUE, width = NULL, size = NULL)

          uiOutput("ycol")),
          # outputs the "ycol" content generated in server in the sidebar

        mainPanel(fluidRow(column(10,
          plotlyOutput("distPlot"))))
        )),
      tabPanel(title = "TESTpanel2", gt_output("gTable_test")),

      tabPanel(title = "TESTpanel3",
              sidebarLayout(
                sidebarPanel(
                  selectInput('variables', "Select plot(s)", colnames(dat1)[-(1:3)],
                              multiple = TRUE,
                              selectize = TRUE,
                              selected = colnames(dat1)[4]),
                  uiOutput("ycol_test")),
                  mainPanel(fluidRow(column(10,
                                            plotlyOutput("distPlot_test"))))
                )))
    ))
