library(shiny)
library(stringi)
library(shiny)

badwords <- readLines(con = './bad-words.txt')
monogram <- readRDS('./RDS/monogram.Rds')
bigram <- readRDS('./RDS/bigram.Rds')
trigram <- readRDS('./RDS/trigram.Rds')
quadgram <- readRDS('./RDS/quadgram.Rds')


cleantext <- function(corpus) {
  corpus = iconv(corpus, "latin1", "ASCII", sub="") #remove any nonASCII character
  corpus = gsub("\\s+"," ", corpus) #remove extra spaces
  corpus = tolower(corpus)
  corpus = gsub("'ve\\s", " have ", corpus) 
  corpus = gsub("'ll\\s", " will ", corpus) 
  corpus = gsub("'re\\s", " are ", corpus) 
  corpus = gsub("n't\\s", " not ", corpus) 
  corpus = gsub("'d\\s", " would ", corpus) 
  corpus = gsub("\\b(i'm|im)\\b", "i am", corpus) 
  corpus = gsub("'\\bu\\b", "you", corpus) 
  corpus = gsub("'\\bur\\b", "your", corpus) 
  corpus = gsub("\\b(he|she|it|how|that|there|what|when|who|why|where)'s\\b", "\\1 is", corpus) 
  corpus = gsub("'d\\s", " would ", corpus) 
  corpus = gsub("http\\S*","<link>", corpus) #replace any URL
  corpus = gsub("[a-z0-9\\.]+@\\S*","<email>", corpus)
  
  for (i in c(1:451)){
    corpus = gsub(paste0("\\s",badwords[i],"\\s"), "", corpus)
  }
  
  corpus <- gsub("([a-z]\\.){2,}","", corpus) #remove any abbreviations
  corpus <- gsub("mr\\.","mister", corpus)
  corpus <- gsub("mrs\\.","mistress", corpus)
  corpus <- gsub("ms\\.","miss", corpus)
  corpus <- gsub("[[:digit:]]","", corpus)  #remove any digits
  corpus <- gsub("(\\w+\\s)\\1+","\\1", corpus)  #remove the repeated word
  corpus <- gsub("[[:punct:]]", "", corpus) #remove any punctuation marks
  
  return(corpus)
}

predict_nextword <- function(string) {
  #takes input of the string, the ngram model to use 
  # and the number of required predictions
  string <- unlist(strsplit(string, " "))
  l <- length(string)
  if (l==0) {
    ngram <- 1
  }
  else if (l==1) {
    lastword <- string[l]
    ngram = 2
  }
  else if (l==3) {
    lastword <- string[l]
    biword <- paste(string[(l-1)], string[l])
    ngram = 3
  }
  else {
    lastword <- string[l]
    biword <- paste(string[(l-1)], string[l])
    triword <- paste(string[(l-2)], biword)
    ngram <- 4  #the ngram to be used
  }
  count <- 0  #the number of predictions made until now
  preds <- c()
  
  while (count < 3) {
        if (ngram == 1) {
          preds <- stri_extract_last_words(names(monogram))
          return(preds)
        }
        else if (ngram == 2) {
          temp <- bigram
          temp1 <- lastword
        }
        else if (ngram == 3) {
          temp <- trigram
          temp1 <- biword
        }
        else {
          temp <- quadgram
          temp1 <- triword
        }
        temp <- temp[grep(pattern = paste0("^",temp1), x = names(temp))]
        l <- length(temp)
        if (l > 1) {
          size_to_take <- min((3-count), l)  #size to consider is minimum of 
          # the required number of more predictions and the size of temp
          index <- sample(1:l, size = size_to_take, prob = temp)
          preds <- c(preds, stri_extract_last_words(names(temp)[index]))
        }
        
        count = length(preds)  #we have made new predictions
        ngram = ngram-1   #we use one less gram for next predictions
    }
  
  return(preds)
}
  




#define server
shinyServer(function(input, output) {
   mystring <- reactive({input$string})
   mystring1 <- reactive({cleantext(mystring())})
   preds <- reactive({predict_nextword(mystring1())})
   output$prediction1 = renderText({preds()[1]})
   output$prediction2 = renderText({preds()[2]})
   output$prediction3 = renderText({preds()[3]})
})




















