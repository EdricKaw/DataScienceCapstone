#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
    
    # Application title
    
    titlePanel("Predict next words"),
    
    # Sidebar with a slider input for number of bins
    sidebarLayout(
        
        sidebarPanel(
            # sidebar top description
            helpText("Key in some text, can be single or more (example 1: once; example 2: according to), then select the number of words to be predicted"),
            
            # Text input
            textInput("text", label = ('Please enter some text'), value = ''),
            
            # Number of words slider input
            sliderInput('slider',
                        'No of words to be predicted:',
                        min = 0, 
                        max = 100,  
                        value = 5
            )),
        mainPanel(
            tabsetPanel(type = "tabs",
                        tabPanel("Main",
                                 h2("Predictions:"),
                                 h4(textOutput("predict",container = pre))
                        ),
                        tabPanel("Table output",
                                 DT::dataTableOutput('table')
                        ),
                        tabPanel("Word cloud",
                        plotOutput('wordcloud')
                        )
        ) 
        
    )
))
)
