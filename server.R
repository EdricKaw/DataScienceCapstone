#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

source("prediction.R")

#list.files()

library(shiny)
library(dplyr)
library(DT)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    
    # Reactive statement for prediction function when user input changes ####
    prediction =  reactive( {
        
        # Get input
        inputText = input$text
        input1 =  fun.input(inputText)[1, ]
        input2 =  fun.input(inputText)[2, ]
        nSuggestion = input$slider
        
        # Predict
        prediction = fun.predict(input1, input2, n = nSuggestion)
        print(prediction)
    })
    
    # Output predict words
    output$predict <- renderText({
        # paste0(1:input$n,".",prediction(),"\n")
        # paste0(prediction()["NextWord"])
        paste0(1:input$slider,".",prediction()["NextWord"][[1]],"\n")
    })
    
    #output$table = renderTable(data.frame(prediction())
                                   #option = list(pageLength = 5,
                                   #             lengthMenu = list(c(5, 10, 100), c('5', '10', '100')),
                                   #            columnDefs = list(list(visible = F, targets = 1))
                                   #           #searching = F
                                   #)
    #)
    
    output$table = DT::renderDataTable({
        prediction()[,'NextWord']
    })
    
    # Output word cloud ####
    wordcloud_rep = repeatable(wordcloud)
    output$wordcloud = renderPlot(
        wordcloud_rep(
            prediction()$NextWord,
            prediction()$freq,
            colors = brewer.pal(8, 'Dark2'),
            scale=c(4, 0.5),
            max.words = 300
        )
    )
    
    
})
