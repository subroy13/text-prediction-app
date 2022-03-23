library(stringi)
library(ngram)
library(parallel)

# Read blogs data
con <- file('./final/en_US/en_US.blogs.txt')
blogdata <- readLines(con); close(con)

# Read news data
con <- file('./final/en_US/en_US.news.txt')
newsdata <- readLines(con); close(con)

# Read twitter data
con <- file('./final/en_US/en_US.twitter.txt'); 
twitterdata <- readLines(con); close(con)

con <- file('./bad-words.txt')
badwords <- readLines(con); close(con)

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
    #message(paste(i, "out of 451 badwords are cleaned!!!"))
    #if (i%%100==0) {
    #  message(paste(i, "out of 451 badwords are cleaned!!!")) 
    #}
  }
  
  corpus <- gsub("([a-z]\\.){2,}","", corpus) #remove any abbreviations
  corpus <- gsub("mr\\.","mister", corpus)
  corpus <- gsub("mrs\\.","mistress", corpus)
  corpus <- gsub("ms\\.","miss", corpus)
  corpus <- gsub("[[:digit:]]","", corpus)  #remove any digits
  corpus <- gsub("(\\w+\\s)\\1+","\\1", corpus)  #remove the repeated word
  corpus <- gsub("[[:punct:]]", "", corpus) #remove any punctuation marks
  
  #nwords <- stri_count_words(corpus)
  #corpus <- corpus[nwords > 1]  #drop all sentences with one or no words
  
  return(corpus)
}

batch_size <- 1000

textfilter_parallel <- function(i, corpus, batch_size = 500) {
  #data[(i*batch_size):((i+1)*batch_size)] = 
  message(paste("batch", i, "is being cleaned..."))
  return(cleantext(corpus[(i*batch_size):((i+1)*batch_size)]))
}

###############################################################

cleanblog <- mclapply(0:1798, textfilter_parallel, corpus = blogdata)
cleanblog <- unlist(cleanblog)
nwords <- stri_count_words(cleanblog)
cleanblog <- cleanblog[nwords >= 1]
con = file('./cleaned_corpus/en-US-blog.txt')
writeLines(cleanblog, con); close(con)


cleannews <- mclapply(0:2019, textfilter_parallel, corpus = newsdata)
cleannews <- unlist(cleannews)
nwords <- stri_count_words(cleannews)
cleannews <- cleannews[nwords >= 1]
con = file('./cleaned_corpus/en-US-news.txt')
writeLines(cleannews, con); close(con)


cleantweet <- mclapply(0:4719, textfilter_parallel, corpus = twitterdata)
cleantweet <- unlist(cleantweet)
nwords <- stri_count_words(cleantweet)
cleantweet <- cleantweet[nwords >= 1]
con = file('./cleaned_corpus/en-US-tweets.txt')
writeLines(cleantweet, con); close(con)


##################################################################



make_ngrams <- function(corpus, threshold = 3) {
  nwords <- stri_count_words(corpus)
  corpus <- corpus[nwords > 3]  #drop all sentences with one or no words
  
  ng <- ngram(corpus, n=1)
  one_words <- get.phrasetable(ng)
  one_words <- one_words[one_words$freq > threshold, ] 
  #select only those words that appear atleast threshold many times
  
  ng <- ngram(corpus, n=2)
  two_words <- get.phrasetable(ng)
  #two_words <- two_words[,c(1,2)]
  
  ng <- ngram(corpus, n=3)
  three_words <- get.phrasetable(ng)
  #three_words <- three_words[,c(1,2)]
  
  ng <- ngram(corpus, n=4)
  four_words <- get.phrasetable(ng)
  #four_words <- four_words[,c(1,2)]
  
  #to reduce memory and enable data retrival faster, we store these dfs in named int type vector
  monogram <- one_words$freq; names(monogram) <- one_words$ngram; rm(one_words)
  bigram <- two_words$freq; names(bigram) <- two_words$ngram; rm(two_words)
  trigram <- three_words$freq; names(trigram) <- three_words$ngram; rm(three_words)
  quadgram <- four_words$freq; names(quadgram) <- four_words$ngram; rm(four_words)
  
  grams <- list(monogram, bigram, trigram, quadgram)
  saveRDS(gram, file = "./grams.Rds")  #save the object for later use
  
  return(grams)
}



predict_nextwords <- function(s, ng) {
  # here s is the objective string and ng is the model.
  s = unlist(strsplit(s, " ")) #split the given sentence 
  laststr <- tail(s, n=3)  #gets the last 3 words in that sentence
  
  trigram <- paste(laststr[1], laststr[2], laststr[3])
  bigram <- paste(laststr[2],laststr[3])
  monogram <- laststr[3]
  
  #firstly try predicting with trigram
  gramdf <- ng[[4]]
  gramdf <- gramdf[grepl(paste0("^",trigram))]  #get only those quadgram which starts with the given trigram
  len <- nrow(gramdf)
  if (len>0) {
    s <- sample(1:(ifelse(len>5, 5, len)), size = 1)
    pred = names(gramdf)[s]
    pred = tail(unlist(stri_split(prediction, " ")), n = 1)
    return(pred)
  }
  
  else {
    gramdf <- ng[[3]]
    gramdf <- gramdf[grepl(paste0("^",bigram))]  #get only those trigram which starts with the given bigram
    len <- nrow(gramdf)
    if (len>0) {
      s <- sample(1:(ifelse(len>5, 5, len)), size = 1)
      pred = names(gramdf)[s]
      pred = tail(unlist(stri_split(prediction, " ")), n = 1)
      return(pred)
    }
    else {
      gramdf <- ng[[2]]
      gramdf <- gramdf[grepl(paste0("^",monogram))]  #get only those bigram which starts with the given monogram
      len <- nrow(gramdf)
      if (len>0) {
        s <- sample(1:(ifelse(len>5, 5, len)), size = 1)
        pred = names(gramdf)[s]
        pred = tail(unlist(stri_split(prediction, " ")), n = 1)
        return(pred)
      }
      
      else {
        gramdf <- ng[[1]]
        s <- sample(1:10, size = 1)
        pred = names(gramdf)[s]
        return(pred)
      }
      
      
    }
    
  }

  
}
















