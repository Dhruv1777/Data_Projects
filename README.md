

# Spotify Top Songs Analysis

## Project Overview:

This analysis explores what attributes contribute to a song's popularity on Spotify, focusing on specific characteristics like 'danceability', 'energy', and more. Additionally, the analysis delves into genre and release time impacts on popularity.



## Broad Insights:

### Popularity by Genre:

Observation: Pop, hip-hop, dance, and indie-pop genres show varying levels of popularity, with pop leading but showing significant variance among songs within the genre as indicated by the smooth ess of its slope in the ridge plot.

![popularity_by_genre-1.png](./images/popularity_by_genre-1.png)

## Year of Release Impact
Finding: A clear trend shows newer songs tend to be more popular, correlating with Spotify's growing user base. 

![Screenshot_2023-08-28_at_21-21-00.jpg](./images/Screenshot_2023-08-28_at_21-21-00.jpg)


## Regression Models and Predictions

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












