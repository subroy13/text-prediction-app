# Text Prediction Application

This text prediction application is built as a part of the capstone project for the Data Science specialization provided by **John Hopkins Bloomberg School of Public Health** in collaboration with **Swiftkey**.  This application intends to provide the user with the next probable word when the user types. The prediction algorithm used to build the application is extremely simple, an **ngram** model. To predict the next words, the algorithm takes the input string and the parses the last three words (if available). Then it tries to find out those quadgrams which has those three words appearing first, and from them, a sample quadgram is chosen according to the probability proportional to its frequency. This reduces the probability of entering a loophole using the common words. Also, if the last three words are not available, then we use last two or less words, using trigrams or bigrams model if required.  


## Dataset

  The dataset corpus is available in the following url: https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip
  We use R to download and unzip the corpus text files for us.


