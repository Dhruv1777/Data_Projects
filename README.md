# Data Projects
Repository for some of my data projects, all coded in R. The following file describes my analysis of the same, while the actual code can be found in their respective folders.

# (1) Spotify Top Songs Analysis

I'm sure a lot of us have thought about what it would take to make a hit song. Song attributes can enable us to get an idea of just what makes our favorite tracks stand out. The analysis here attempts to predict the popularity of a song based on attributes such as 'danceability', 'energy', etc, as well as give us some insights based on genre and time of release.



### Broad Insights:

One of the best ways to begin is to analyze the popularity of different genres (note - there are many, many more genres than just these 10, but these were selected for being the most popular to make the graph more readable: 

![popularity_by_genre-1.png](./images/popularity_by_genre-1.png)

As expected, we see pop songs have the highest popularity (it's in the name, right?), though the slope of the ridge is not very steep, indicating fair variance amongst different levels of popularity. Following a similar trend are hip-hop, dance, and indie-pop (though indie-pop has a fair distribution of songs with quite low popularity as well).


On a separate topic, the year of release also does have an impact on its popularity. This would make sense as with Spotify still growing in terms of its number of users, more and more people are likely to stream newer songs that at the time of course have a surge in popularity.

![Screenshot_2023-08-28_at_21-21-00.jpg](./images/Screenshot_2023-08-28_at_21-21-00.jpg)

We can see a clear linear relationship between year and popularity. The slope of the line is _, indicating _.


### Regression Models and Predictions

Moving on from these broader insights, I want to see if we can build a predictive model to estimate the popularity of a song based on the internal song attributes. Rather than genre or year, the predictors describe the nature of the song itself in 12 ways: 'danceability', 'energy', 'loudness', 'speechiness', 'acousticness', 'instrumentalness', 'liveness', 'valence', 'tempo', 'duration_ms'.

To begin with, it seemed to me that there could be a degree of high multicollinearity between the predictor variables. I used the Variance Inflation Factor (VIF) method to test for this. 

![VIF_values.jpg](./images/VIF_values.jpg)


The VIF values are not all that high. I was expecting to take action if they exceeded 5. Only two predictors come close to that, 'energy' and 'loudness'. Charting a correlation plot from a correlation matrix, we can see that 'energy' and 'loudness' have a fair degree of positive correlation with each other, and both have a fairly negative correlation with 'acousticness'. This could be something to keep an eye on:

![Correlation_matrix_popularity_and_song_attributes-1.png](./images/Correlation_matrix_popularity_and_song_attributes-1.png)


### Multivariate Model:

To begin with, we can go with a regular multivariate regression approach. 

![Multivariate_summary.jpg](./images/Multivariate_summary.jpg)

We can see that the p values all indicate a high degree of statistical significance for our predictor variables, a good start! The Adjusted R-squared value though is only 0.06752 though, indicating the model can only explain 6.75% of the variance in "popularity". Thus, while the overall regression model is statistically significant (as also confirmed by the F-statistic), it can only explain variance in popularity to a small degree.

Also relevant is the impact of individual predictors on popularity. This graph describes the extent and direction of this relationship:

![Impact_of_Predictors_on_Popularity_(Coefficients_of_the_predictors)-1.png](./images/Impact_of_Predictors_on_Popularity_(Coefficients_of_the_predictors)-1.png)

Now I know blindly chasing after a higher R-squared value is not always the best approach, especially with a topic such as this where there can be so many outside factors influencing the popularity of the song that are not in this dataset (such as how the song was promoted, how it relates to the trends of the time, etc), but I do want to see if we can do better.



### Random Forest Model:

Before changing anything else, I want to see how changing the nature of the model will impact the predictions. Going away from multivariate models, I am trying out a random forest regression model with 100 trees. This could help garner more insights that we would otherwise miss out on as it can handle multicollinearity much better (such as that may exist with energy, loudness, and acousticness), as well as help capture non-linear relationships.

![Random_Forest_Summary.jpg](./images/Random_Forest_Summary.jpg)

We perform much better on the R squared (OOB) value of 0.2035, which means that the model explains about 20.35% of the variance in popularity. However, on the flip side, we also have a very high OOB prediction error (MSE). This is as high as 201.0056 which is not good at all considering the range of the dependent variable, 'popularity' is only 0-100! This indicates a high deviation of the predicted values from the true values and also implies that the model would not do well on new, unseen data.


Also of note is the variable importance graph derived from the random forest model:
![Variable_Importance_in_Random_Forest_Model-1.png](./images/Variable_Importance_in_Random_Forest_Model-1.png)


### Final Thoughts

Given the nature of the dependent variable (and of course, the performance of the models) and the potential for it to be widely influenced by outside factors, I think the more simple multivariate model gave the best results. While the Adjusted R square value was low, the p values and F-statistic did indicate a high degree of statistical significance. While the model can only predict the dependent variable to a limited degree, it performs strongly within this area. 

Applying that to our data in context, it looks like for any budding songwriter, what makes a song popular goes much further beyond the internal attributes of the song itself. Though these do have a good degree of statistical significance, their ultimate impact is limited. Thus, while it is best to focus on having your song score high/low on the following metrics, there are a multitude of external factors to consider.




## (2) 'Threads' Sentiment Analysis

This is a sentiment analysis of a set of over 32k reviews on the 'Threads' app across both the App and Google Play Store.

### Broad Insights 

First off, I wanted to check the distribution of ratings (looking at this platform-wise allows an extra degree of insight)

![Platform Wise Distribution of Rating](./images/Platform-Wise_Distribution_of_Ratings-1.png)

The reviews do seem to be quite polarizing with '1' and '5' being the most frequent.

We have significantly more Google Play Store reviews than App Store reviews which could impact the overall analysis, so we will consider this one of our limitations going forward.

### Sentiment Scores

A great way to get an idea of how users feel about 'Threads' in their reviews is deriving a 'sentiment score' for them. The sentiment scores here come from predefined lists of words (as part of packages in R) that are labeled as either positive or negative. 

![Absolute_Sentiment_Scores_by_Rating_and_Source-1.png](./images/Absolute_Sentiment_Scores_by_Rating_and_Source-1.png)
![Absolute_Sentiment_Scores_by_Source.png](./images/Absolute_Sentiment_Scores_by_Source.png)


While you can see viewing the sentiment scores by their numerical ratings as too obvious to reveal anything significant, it is interesting to note how a rating of '1' corresponds to a negative sentiment score for Play Store users, but remains positive (though close to 0) for App Store users.


Of course, the difference between users of each of the two operating systems can result from the limited number of App Store reviews.
To counteract this, we can try to get a clearer picture of how users feel about 'Threads' via an 'average' sentiment score. These averages are derived from normalizing the sentiment score by the total number of reviews for each source

![Average_Sentiment_Scores_by_Rating_and_Source](./images/(Normalised_by_Count_Method)_Average_Sentiment_Scores_by_Rating_and_Source_1.png)
![Average_Sentiment_Scores_by_Source.png](./images/Average_Sentiment_Scores_by_Source.png)


### Key Word Analysis

Keyword analysis allows us to expand our analysis beyond sentiment scores and numeric ratings. I have pulled up the most commonly used words appearing in all of the reviews - both positive and negative. of course, before this, I have tried my best to remove any 'stop words' (common words such as "and", "the", etc., that do not carry significant meaning) through both in-built algorithms in R and a list I created myself manually after viewing the most commonly used words. 

Some 'stop words' unique to this analysis include:  "twitter","instagram","facebook","zuckerberg". I have chosen to exclude these as they are widely used and common to both positive and negative reviews of the app, so without more context they could impact the results of this analysis (this problem of context will also be tackeled during the building of my ML models)

##### Key Word Analysis for Positive Reviews (Reviews of rating 4 and above)

![Negative_Reviews_Word_Cloud-1.png](./images/Negative_Reviews_Word_Cloud-1.png)


##### Key Word Analysis for Negative Reviews (Reviews of rating 2 and below)

![Negative_Reviews_Word_Cloud-1.png](./images/Negative_Reviews_Word_Cloud-1.png)

Interestingly, we see words like "instagram", "twitter", etc that are common to both positive and negative reviews. These words are likely used to draw positive and negative comparisons respectively. 

### Predictive Models and Beyond

We can use this data to create machine learning models for sentiment classification that can potentially be used to predict values on other such datasets of app reviews. 

I have also taken the precaution of removing the words:  "twitter","instagram","facebook","zuckerberg". I have chosen to exclude these as they are widely used and common to both positive and negative reviews of the app, and could thus impact the predictive power of the model

I followed several steps in the creation of such a model:

(i) Similar to the above word clouds, classifying different levels of 'positive, neutral, and negative.
  
  data$rating >= 4 ~ "positive",
  data$rating == 3 ~ "neutral",
  data$rating <= 2 ~ "negative"

(ii) "Preprocessing" the data for ML analysis: This involves converting text to lowercase, eliminating punctuation, discarding stop words, removing numbers and whitespace. This is all so my model can "read" the data more effectively. 

(iii) Creation of a 'Document Term Matrix (DTM) & calculation of Term Frequency-Inverse Document Frequency (TF-IDF): The DTM is a matrix representation of the dataset where each row corresponds to a document (in this case, a review) and each column represents a unique term across all documents. The values in the matrix indicate the frequency of each term in each document.

TF-IDF is a statistical measure used to evaluate how important a word is. It increases proportionally to the number of times a word appears in the document but is offset by the frequency of the word in the corpus, which helps to adjust for the fact that some words appear more frequently in general.

(iv) Pre-paring the above data for ML modeling and splitting the data into 'training' and 'testing' sets: 80% of the total dataset is used to "train" the model while its effectivness in evaluating sentiment is tested on the other 20%.

#### Attempt 1:
Evaluating the model's performance using the test set, I can see it's performance is just above average.Accuracy (0.6074) indicates that 60.74% of all predictions were correct. The low p-value (1.673e-09) indicates that the model is much better than the 'no information rate' (the accuracy achievable by always predicting the most frequent class). However, there is definite room for improvement. A closer look reveals that the model struggles most with 'negative' and 'neutral' classes (due to their relatively low prevalence in the dataset) so I can begin there.

![1st_model.png](./images/1st_model.png)


#### Attempt 2: Adjusting for class sizes via oversampling

Here I will try to adjust for the lower number of negative and neutral reviews:

These are the sizes of each class and the overall average: 

size_negative <- 11522
size_neutral <- 2585
size_positive <- 18803
average_size <- 10970

I will ignore the negative class for now as neutral is drastically more under-represented by targeting halfway between its current size and the average:

target_size_neutral <- round((size_neutral + average_size) / 2)

The neutral class will now be oversampled:
data_neutral_oversampled <- sample_n(data_neutral, target_size_neutral, replace = TRUE)

Unfortunately, this model performs even worse at an overall level than the previous one with an overall decrease in accuracy from from 60.74% to 56.49%. Moreover, the performance on negative and neutral classes, which we were hoping to improve on, actually decreased slightly. 

![2nd_model.png](./images/2nd_model.png)



Another better way of handling class imbalance could be to just simply to two classes, positive and negative.


#### Attempt 3: Using only two classes as opposed to three:

The classes have been redefined to: 
  data$rating >= 4 ~ "positive",
  data$rating <= 3 ~ "negative"

![3rd_model.png](./images/3rd_model.png)

We immediatley see better results. This model, with an accuracy of 66.74% shows a higher overall accuracy than both previous ones (60.74% and 56.49%, respectively).
Specificity and precision are also notably high in this model, especially for identifying positive sentiments and predicting negative sentiments accurately.

However, the sensitivity for negative sentiments is lower. This could demand a more sophiticated treating of negative class in the data.

One way to achieve this could be via bi-grams or tri-grams. In these methods, 
  











