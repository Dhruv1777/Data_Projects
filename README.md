

# Spotify Top Songs Analysis & Predictive Modelling

All Code is available in "R_Code_Spotify_Top_Songs" in this repository.

## Project Overview:

This analysis explores what attributes contribute to a song's popularity on Spotify, focusing on specific characteristics like 'danceability', 'energy', and more. Additionally, the analysis delves into genre and release time impacts on popularity.

The dataset is from 



## Broad Insights:

### Popularity by Genre:

Observation: Pop, hip-hop, dance, and indie-pop genres show varying levels of popularity, with pop leading but showing significant variance among songs within the genre as indicated by the smooth ess of its slope in the ridge plot.

![popularity_by_genre-1.png](./images/popularity_by_genre-1.png)

## Year of Release Impact
Finding: A clear trend shows newer songs tend to be more popular, correlating with Spotify's growing user base. 

![Screenshot_2023-08-28_at_21-21-00.jpg](./images/Screenshot_2023-08-28_at_21-21-00.jpg)


## Regression Models and Predictions

## Initial Insights from VIF:

Tested predictor variables for multicollinearity; 'energy' and 'loudness' show positive correlation, while both negatively correlated with 'acousticness'. However, the value is not so high as to take immediate action. I will instead keep an eye on these variables due to their potential overlapping influence on the model's accuracy.


![VIF_values.jpg](./images/VIF_values.jpg)


![Correlation_matrix_popularity_and_song_attributes-1.png](./images/Correlation_matrix_popularity_and_song_attributes-1.png)


## Multivariate Model:

Results: While all predictor variables showed statistical significance, the Adjusted R-squared value was only 0.06752, indicating a limited explanation of popularity variance.

![Multivariate_summary.jpg](./images/Multivariate_summary.jpg)

![Impact_of_Predictors_on_Popularity_(Coefficients_of_the_predictors)-1.png](./images/Impact_of_Predictors_on_Popularity_(Coefficients_of_the_predictors)-1.png)

While the R squared value is low, this is expected behavior given that so many outside factors influence the popularity of the song that are not in this dataset (such as how the song was promoted, how it relates to the trends of the time, etc). The fact that predictor variables show statistical significance is an encouraging result. I do want to see if other models can improved on the R square value.



## Random Forest Model:

Employed a random forest regression with 100 trees, aiming to capture non-linear relationships and better handle multicollinearity

Results:
The model improved to explain 20.35% of the variance in popularity but showed a high prediction error, indicating challenges with accuracy on unseen data.

![Random_Forest_Summary.jpg](./images/Random_Forest_Summary.jpg)

Also of note is the variable importance graph derived from the random forest model:
![Variable_Importance_in_Random_Forest_Model-1.png](./images/Variable_Importance_in_Random_Forest_Model-1.png)


## Conclusion

Given the nature of the dependent variable (and of course, the performance of the models) and the potential for it to be widely influenced by outside factors, I think the more simple multivariate model gave the best results. While the Adjusted R square value was low, the p values and F-statistic did indicate a high degree of statistical significance. While the model can only predict the dependent variable to a limited degree, it performs strongly within this area. 

Applying that to our data in context, it looks like for any budding songwriter, what makes a song popular goes much further beyond the internal attributes of the song itself. 

Though these do have a good degree of statistical significance, their ultimate impact is limited. Thus, while it is best to focus on having your song score high/low on the following metrics, there are a multitude of external factors to consider.


### Dataset Attribution and Usage:

This project analyzes the "Spotify_1Million_Tracks" dataset to explore attributes contributing to song popularity on Spotify. The dataset is licensed under the Open Data Commons Open Database License (ODbL) v1.0.

Dataset Source: https://www.kaggle.com/datasets/amitanshjoshi/spotify-1million-tracks
License: Open Data Commons Open Database License (ODbL) v1.0. The original source of data is attributed in the link above.

