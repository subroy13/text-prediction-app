library(shiny)

shinyUI(
  fluidPage(theme = "bootstrap.css",
            fluidRow(titlePanel("Text Prediction System using N-Gram Model"),
                     h4(em(paste(Sys.Date(), "Subhrajyoty Roy", sep=",\t"))),
                     br(),
                     p("This application is created as a part of Data Science 
Capstone Project for the Data Science Specialization course provided by John Hopkins
Bloomberg School of Public Health, using the raw data Provided by Swiftkey."),
                     tags$style(type="text/css","p { width: 75%;}"),
                     br(),
                     hr(),
                     br(),
                     h3(em(strong("ENTER YOUR TEXT BELOW"))),
                     align="center"),
            
            fluidRow(
              column(8, align="center", offset = 2,
                     textInput("string", label="",value = "", width = "100%", 
                               placeholder = "Enter your text here"),
                     tags$style(type="text/css", "#string { 
                                height: 50px; width: 100%; 
                                text-align:center; font-size: 30px; 
                                display: block;}")
              )
            ),
            fluidRow(
              column(10, align="center", offset = 1,
                     h4("The  suggestions for next word are..."),
                     actionButton("button1",label = textOutput("prediction1")),
                     actionButton("button2",label = textOutput("prediction2")),
                     actionButton("button3",label = textOutput("prediction3")),
                     tags$style(type='text/css', "#button2 { 
                                vertical-align: middle; height: 50px; 
                                width: 33%; font-size: 30px; float:left;}"),
                     tags$style(type='text/css', "#button1 { 
                                vertical-align: middle; height: 50px; 
                                width: 33%; font-size: 30px; float:center;}"),
                     tags$style(type='text/css', "#button3 { 
                                vertical-align: middle; height: 50px; 
                                width: 33%; font-size: 30px; float:right;}")
                    )
                    )
          
  
))












