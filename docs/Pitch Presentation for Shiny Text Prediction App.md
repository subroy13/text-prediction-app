Pitch Presentation for Shiny Text Prediction App
========================================================
author: Subhrajyoty Roy
date: 13 Nov, 2018
autosize: true

Introduction
========================================================

  This presentation is a pitch documentation for introducing the user to the text prediction application (link given below) and its features along with necessary explanations of the prediction algorithm. The application is built as a part of the capstone project for the Data Science specialization provided by **John Hopkins Bloomberg School of Public Health** in collaboration with **Swiftkey**.
  
- Shinyapp Link :
- Github sourcecode Link :


Background
========================================================

  The original dataset used to build the application has been provided by **Swiftkey** in three separate text files, *en-UN-blogs.txt, en-UN-news.txt, en-UN-twitters.txt*, which contains a large number of english sentences from blogs, news and tweets from twitters respectively. Since, the raw corpus is huge, it has been cleaned to remove url, email, non-ASCII characters and profanity filter has also been performed using parallel programming (using *parallel* package in R). However, for building the prediction model, only a sample of 25,000 is taken from each of the three  files, which comprises of about a million sentences together. Usage of more data than this sufficiently increases the time to give a prediction and creates poor user experience with the application.
  
  
Prediction Algorithm
========================================================

  The prediction algorithm used to build the application is extremely simple, the usage of an **ngram** model (wiki link here). For this purpose, *ngram* package has been used. Ngram is the *n* consecutive words that appears in the corpus, for example, one-gram or unigram is the normal words, while bigram is the pharases of two words appearing consecutively (like *for the, I am, can not, to be* etc. ). To build the application, unigrams, bigrams, trigrams and quadgrams have been computed from the sampled and cleaned corpus. Each type of n-grams is stored in a named vector sorted according the frequency of occurence in order to redcue memory usage. 
  
  To predict the next words, the algorithm takes the input string and the parses the last three words (if available). Then it tries to find out those quadgrams which has those three words appearing first, and from them, a sample quadgram is chosen according to the probability proportional to its frequency. This reduces the probability of entering a loophole using the common words. Also, if the last three words are not available, then we use last two or less words, using trigrams or bigrams model if required.  
  
  
Future Prospects
=======================================================
  With the availablity of sufficient storage and computational power, this application can be made a lot more powerful. 
  
- Inclusion of whole corpus may be possible, which would significantly boost the accuracy of prediction.
- We may include smileys and emoticons along with prediction of the text.
- Currently, this algorithm does not take account for the punctuation marks, which is important for prediction of next words.
- Efficiently storing the ngrams so that the application becomes smaller in size and can be deployed to smartphones.
- Extending this model to different languages.

Acknowledgements
======================================================
  I would like to thank **Swiftkey** for providing this extremely valuable dataset which is the base of the application. I also thank **Coursera** for putting up this amazing specialization offered by *JHU* on an online platform. I thank my mentors for the specialization **Jeff Leek**, **Roger Peng** and **Brian Caffo** for guiding step by step thorugh this capstone project. Finally, I would like to extend my thanks and regards to my fellow classmates in this course who were a great help in clearing doubts in discussion forums. And finally, **THANK YOU** to all the users of the applications. 





  
  
  
  
  
  
  
  
  
  
