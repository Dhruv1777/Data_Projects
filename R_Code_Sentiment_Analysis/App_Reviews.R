setwd("/Users/dhruvnair/Desktop/Projects Q3 2023/(3) Sentiment analysis/Threads app reviews")
library(tidyverse)
library(tidytext)
library(textdata)

data <- read.csv("threads_reviews.csv")
view(data)
unique(data$source)
unique(data$rating)

view(filter(data, data$rating == "3"))
2585/32910

view(filter(data, data$source == "App Store"))
2640/32910

summary(data)


#distribution of ratings

ggplot(data, aes(x = rating)) + 
  geom_bar(aes(fill = source)) +
  facet_wrap(~ source)


##################################################################################################################

#(i) Lexicon-Based Sentiment Analysis (Absolute Method)
reviews_data_tokens <- data %>%
  unnest_tokens(word, review_description)

sentiments <- reviews_data_tokens %>%
  inner_join(get_sentiments("afinn")) %>%
  group_by(source, rating) %>%
  summarise(sentiment_score = sum(value)) %>%
  arrange(desc(sentiment_score))


view(sentiments)

#######
#sentiments not rating wise:
sentiments_no_rating <- reviews_data_tokens %>%
  inner_join(get_sentiments("afinn")) %>%
  group_by(source) %>%
  summarise(sentiment_score = sum(value)) %>%
  arrange(desc(sentiment_score))

view(sentiments_no_rating)


#VIZ:
#1
ggplot(sentiments, aes(x=rating, y=sentiment_score, fill=source)) +
  geom_bar(stat='identity') +
  facet_wrap(~ source) +
  labs(title="Absolute Sentiment Scores by Rating and Source")

#2
ggplot(sentiments_no_rating, aes(x=source, y=sentiment_score, fill=source)) +
  geom_bar(stat='identity') +
  labs(title="Absolute Sentiment Scores by Source")

  

#(ii) Lexicon-Based Sentiment Analysis (Normalised by count method)

# Compute the number of reviews per combination of source and rating
review_count <- reviews_data_tokens %>%
  group_by(source, rating) %>%
  summarise(n = n())

# Compute average sentiment scores
sentiments_normalized <- sentiments %>%
  inner_join(review_count, by = c("source", "rating")) %>%
  mutate(average_sentiment = sentiment_score / n)

view(sentiments_normalized)

####
#average sentiment scores without rating
review_count_no_rating <- reviews_data_tokens %>%
  group_by(source) %>%
  summarise(n = n())


sentiments_normalized_no_rating <- sentiments_no_rating %>%
  inner_join(review_count_no_rating, by = ("source")) %>%
  mutate(average_sentiment = sentiment_score / n)

view(sentiments_normalized_no_rating)
#####


#VIZ:
#1
ggplot(sentiments_normalized, aes(x=rating, y=average_sentiment, fill=source)) +
  geom_bar(stat='identity') +
  facet_wrap(~ source) +
  labs(title="Average Sentiment Scores by Rating and Source")

#2
ggplot(sentiments_normalized_no_rating, aes(x=source, y=average_sentiment, fill=source)) +
  geom_bar(stat='identity') +
  labs(title="Average Sentiment Scores by Source")


################################################################################################################
#(iii) Lexicon-Based Sentiment Analysis (Proportional Sentiment Score method)
# Compute the number of tokens per combination of source and rating
token_count <- reviews_data_tokens %>%
  group_by(source, rating) %>%
  summarise(token_n = n())

# Compute sentiment scores per token
sentiments_token_normalized <- sentiments %>%
  inner_join(token_count, by = c("source", "rating")) %>%
  mutate(sentiment_per_token = sentiment_score / token_n)


#Viz:
# Plotting the sentiment score per token
ggplot(sentiments_token_normalized, aes(x=rating, y=sentiment_per_token, fill=source)) +
  geom_bar(stat='identity') +
  facet_wrap(~ source) +
  labs(title="Sentiment Scores per Token by Rating and Source")

#ITS IDENTICAL SO I'LL JUST USE METHOD (II) NORMALISED BY COUNT

##############################################################################################################################
#KEYWORD ANALYSIS:
library(tm)
library(wordcloud)

# Create a corpus
reviews_corpus <- Corpus(VectorSource(data$review_description))

#remove additional stop words
additional_stopwords <- c("app", "threads", "just", "account", "see", "cant", 
                          "people", "follow", "want", "post", "one", 
                          "copy", "need", "thread", "even", "also", "really", "now", "option", "delete", 
                          "much", "’s", "first", "far", "way", "get", "make", "accounts", 
                          "meta", "still", "application", "fix", "\U0001f44d", "elon", "without", "social", 
                          "think", "apps", "don’t", "know", "following", "using", "something", 
                          "insta", "lot", "mark", "download", "well", 
                          "open", "musk", "back", "another", 
                          "already", "nothing", "thing", "anything", 
                          "every","keeps", "keep", "things", "’m", 
                          "let", "start",  "thanks", "log", "going",
                          "everything", "looks", "ever", "zuck", "since", 
                          "right", "theres", "soon", "find", "seems", "can’t", "aap", 
                          "getting", "day", "full", "got", "trying", "thank", "tried", 
                          "thats", "say", "never",  
                          "yet", "actually", "everyone", "sign", "made", "ive", 
                          "used", "look", "days", "video", "stars", "feels", 
                          "didnt", "install", "feel", "switch", "sure", 
                          "though", "seeing", "times", "overall", "lets", 
                          "always", "looking", "tab", "showing", "wont", 
                          "reason", "\U0001f602", "makes", "name", 
                          "point", "literally", "care", "fine", 
                          "making", "come", "shows", "ill", "stuff", "maybe", "speech", "big", "team",
                          "etc", "however", "someone", "idea", "definitely", "multiple", 
                          "world", "lol", "whenever", "take", "reply", "hard",  
                          "\U0001f60d", "stop", "others", "little", "\U0001f60a", "dont", "will", "time", "try", "work", "hai")

# Merge with the standard stopwords
all_stopwords <- c(stopwords("en"), additional_stopwords)


words_in_top_300_that_will_be_in_list <- c("twitter", "good", "instagram", "like", "nice", "better", "use", "can", "great", 
                                           "please", "new", "best", "love", "feed", "add", "features", "posts", "bad", 
                                           "amazing", "experience", "needs", "data", "media", "hope", "many", "cool", 
                                           "feature", "working", "user", "content", "doesnt", "give", "page", "review", "easy", 
                                           "profile", "able", "facebook", "users", "phone", "screen", "super", "worst", "problem", 
                                           "awesome", "search", "login", "bugs", "platform", "crashing", "bug", "crashes", "version", 
                                           "interface", "scroll", "upload", "trending", "followers", "useless", "random", "dark", 
                                           "zuckerberg", "wow", "excellent", "update", "mode", "button", "hashtags", "create", "pretty", 
                                           "change", "glitch", "boring", "friends", "star", "glitches", "text", "issue", "videos", 
                                           "timeline", "show", "photos", "home", "deleting", "downloaded", "fun", "properly", "save", 
                                           "wish", "alternative", "different", "message", "instead", "simple", "missing", "interesting", 
                                           "photo", "waste", "edit", "privacy", "deleted", "future", "glitching", "works", "perfect", "help",
                                           "share", "paste", "android", "allow", "❤️", "algorithm", "smooth", "updates", "scrolling", "support", "personal", 
                                           "less", "installed", "wrong", "view", "error", "annoying", "pictures", "picture", "free", "information", "fixed", 
                                           "trash", "unable", "badge", "cheap", "comment", "read", "issues", "posting", "access", "clean", "interested", 
                                           "topics", "top", "useful")




# Transform the data: convert to lowercase, remove punctuation, numbers, whitespace, and stop words
reviews_corpus_clean <- tm_map(reviews_corpus, content_transformer(tolower))
reviews_corpus_clean <- tm_map(reviews_corpus_clean, removePunctuation)
reviews_corpus_clean <- tm_map(reviews_corpus_clean, removeNumbers)
reviews_corpus_clean <- tm_map(reviews_corpus_clean, removeWords, all_stopwords)
reviews_corpus_clean <- tm_map(reviews_corpus_clean, stripWhitespace)


word_freq <- TermDocumentMatrix(reviews_corpus_clean)
word_freq <- as.data.frame(as.matrix(word_freq))
word_freq_sum <- rowSums(word_freq, na.rm = TRUE)
word_freq_df <- data.frame(term = names(word_freq_sum), freq = word_freq_sum)

#viewing the df:
word_freq_df_ordered <- word_freq_df[rev(order(word_freq_df$freq)),]
view(word_freq_df_ordered)
view(head(word_freq_df_ordered, 15))


# Plotting the word cloud
wordcloud(words = word_freq_df$term, freq = word_freq_df$freq, min.freq = 50,
          max.words=100, random.order=FALSE, rot.per=0.35, 
          colors=brewer.pal(8, "Dark2"))





#word clouds by positive and negative reviews
#since the 3 star reviews are only 7-8% of the total dataset, we can ignore these:

# Defining Positive and Negative Reviews
positive_reviews <- subset(data, rating %in% c(4, 5))
negative_reviews <- subset(data, rating %in% c(1, 2))



# Create a corpus
positive_corpus <- Corpus(VectorSource(positive_reviews$review_description))

# Transform the data
positive_corpus_clean <- tm_map(positive_corpus, content_transformer(tolower))
positive_corpus_clean <- tm_map(positive_corpus_clean, removePunctuation)
positive_corpus_clean <- tm_map(positive_corpus_clean, removeNumbers)
positive_corpus_clean <- tm_map(positive_corpus_clean, removeWords, all_stopwords)
positive_corpus_clean <- tm_map(positive_corpus_clean, stripWhitespace)



# Create a corpus
negative_corpus <- Corpus(VectorSource(negative_reviews$review_description))

# Transform the data
negative_corpus_clean <- tm_map(negative_corpus, content_transformer(tolower))
negative_corpus_clean <- tm_map(negative_corpus_clean, removePunctuation)
negative_corpus_clean <- tm_map(negative_corpus_clean, removeNumbers)
negative_corpus_clean <- tm_map(negative_corpus_clean, removeWords, all_stopwords)
negative_corpus_clean <- tm_map(negative_corpus_clean, stripWhitespace)


#positive reviews word cloud
positive_freq <- TermDocumentMatrix(positive_corpus_clean)
positive_freq <- as.data.frame(as.matrix(positive_freq))
positive_freq_sum <- rowSums(positive_freq, na.rm = TRUE)
positive_freq_df <- data.frame(term = names(positive_freq_sum), freq = positive_freq_sum)

#viewing the table:
positive_freq_df_ordered <- positive_freq_df[rev(order(positive_freq_df$freq)),]
view(head(positive_freq_df_ordered, 15))

# Plotting the word cloud
wordcloud(words = positive_freq_df$term, freq = positive_freq_df$freq, min.freq = 50,
          max.words=100, random.order=FALSE, rot.per=0.35, colors=brewer.pal(8, "Dark2"))



#negative reviews word cloud
negative_freq <- TermDocumentMatrix(negative_corpus_clean)
negative_freq <- as.data.frame(as.matrix(negative_freq))
negative_freq_sum <- rowSums(negative_freq, na.rm = TRUE)
negative_freq_df <- data.frame(term = names(negative_freq_sum), freq = negative_freq_sum)

#viewing the table:
negative_freq_df_ordered <- negative_freq_df[rev(order(negative_freq_df$freq)),]
view(head(negative_freq_df_ordered, 15))


# Plotting the word cloud
wordcloud(words = negative_freq_df$term, freq = negative_freq_df$freq, min.freq = 50,
          max.words=100, random.order=FALSE, rot.per=0.35, colors=brewer.pal(8, "Dark2"))




##########################################################################################################################
#Machine learning model:
#(i) creating TF-IDF matrix
data$sentiment <- case_when(
  data$rating >= 4 ~ "positive",
  data$rating == 3 ~ "neutral",
  data$rating <= 2 ~ "negative"
)

library(tm)
library(slam)

# Create a text corpus
corpus = Corpus(VectorSource(data$review_description))

# Convert to lower-case
corpus = tm_map(corpus, content_transformer(tolower))

# Remove numbers
corpus = tm_map(corpus, removeNumbers)

# Remove special characters
corpus = tm_map(corpus, removePunctuation)

# Remove stop words
corpus = tm_map(corpus, removeWords, stopwords("en"))

# Strip white space
corpus = tm_map(corpus, stripWhitespace)




# Create a Document-Term Matrix (DTM)
dtm = DocumentTermMatrix(corpus)

# Remove sparse terms
dtm <- removeSparseTerms(dtm, 0.995)  # Adjust sparsity threshold as needed

# Compute the Term Frequency-Inverse Document Frequency (TF-IDF)
tfidf = weightTfIdf(dtm)

# If you want to convert it to a regular matrix afterward 
tfidf_matrix = as.matrix(tfidf)


###################################################################################################################
#(ii) building ML model

# Convert to data frame
tfidf_df = as.data.frame(as.matrix(tfidf))

# Combine with other variables, like 'source' and 'sentiment'
final_data = data.frame(source=data$source, sentiment=data$sentiment, tfidf_df)
view(final_data)



#splitting data into training and testing:
library(caret)
set.seed(123)
trainIndex <- createDataPartition(final_data$sentiment, p=0.8, list=FALSE)
trainData <- final_data[trainIndex,]
testData <- final_data[-trainIndex,]


#model training:
set.seed(123)
model <- train(sentiment ~ ., data=trainData, method="naive_bayes")


#evaluating model
# Make predictions
predictions <- predict(model, newdata=testData)

predictions <- as.factor(predictions)
testData$sentiment <- as.factor(testData$sentiment)


# Evaluate the model
confusionMatrix(predictions, testData$sentiment)

#


#####################################################################################################################










  