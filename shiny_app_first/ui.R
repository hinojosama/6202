library(shiny)
library(shinythemes)
library(colourpicker)
library(shinyBS)
library(plotly)

#create a shiny user interface code block.  The UI is an HTML document.  The R
#code assembles the html.
shinyUI(fluidPage(titlePanel("Shiny COVID19 Dashboard"),
      #selected tabsetPanel layout, various options available
      tabsetPanel(

#tab1 Covid Plots----
      tabPanel("Covid data plots",
        #sidebarLayout selected other options available
        sidebarLayout(
          sidebarPanel(
            #in sidebarPanel we have object created by the selectInput function
            #allowing selections from the dat1 columns except cols 1 to 3
            selectInput('variables', "Select plot(s)", colnames(dat1)[-(1:3)],
                      multiple = TRUE,
                      selectize = TRUE,
                      selected = colnames(dat1)[4]),
          # preloads/matches choices on typing
          # input selector populated with column names from dat1 dataframe, specifically
          # the selectInput definition: function (inputId, label, choices, selected = NULL, multiple = FALSE,
          # selectize = TRUE, width = NULL, size = NULL)

          uiOutput("ycol")),
          # outputs the "ycol" content generated in server in the sidebar

        #in the main panel section the column width is 10
        mainPanel(fluidRow(column(10,
          #the main panel will plot output variable distPlot called from server
          plotlyOutput("distPlot"))))
        )),

#tab2 GT Extras----
      #next tab panel, its label, and calling the gTable_test output variable
      #again called from server
      tabPanel(title = "GT table", gt_output("gTable_test")),

      #next tab panel, layout specification, and an input select section using
      #selectInput functions to generate the gt_var and gt_col the server will call
      tabPanel(title = "GT Extras ~ sparklines",
              sidebarLayout(
                sidebarPanel(
                  selectInput('gt_var', "Select Variable", dat2_pvt$name,
                              multiple = TRUE,
                              selectize = TRUE,
                              selected = dat2_pvt$name),
                  selectInput('gt_col', "Select Statistic", setdiff(colnames(dat2_pvt), hide_spark),
                              multiple = TRUE,
                              selectize = TRUE,
                              selected = setdiff(colnames(dat2_pvt), hide_spark))),
                  #in the main panel using gt_ouput function plot distPlot_test called
                #from server
                mainPanel(fluidRow(column(10,
                                            gt_output("distPlot_test"))))
                )),
#tab3 Debug----
      tabPanel(title = "debug",
               actionButton("debug", "DEBUG")),
#tab4 Flashlight----
      tabPanel(title = "Flashlight Panel",
               sidebarLayout(
                 sidebarPanel(
                   selectInput('variables', "Select variable", colnames(dat1)[-(1:3)],
                              multiple = F,
                              selectize = TRUE,
                              selected = colnames(dat1)[4]),
                   selectInput('model_sel', "Select model", model_vec,
                               multiple = F,
                               selectize = TRUE,
                               selected = model_vec[1])),
                 #in the main panel will have two rows, one with model_plot output
                 #and one with flash_out output called from server
                 mainPanel(fluidRow(column(10,
                                           plotlyOutput("model_plot"))),
                 fluidRow(column(5, "flash_out"))))
)#closes tabPanel4
)#closes tabsetPanel function
)#closes fluidpage function
)#closes shinyUI function
