
setwd("/Users/dhruvnair/Desktop/Projects Q3 2023/(4) Kaggle Datasets/Spotify!")
data <- read.csv("spotify_data.csv")
library(tidyverse)
colnames(data)
view(unique(data$genre))

view(head(data,1000))


str(data) #check the column Types

colSums(is.na(data)) #no NAs


#checking number of genres
genre_count <- data %>% group_by(genre) %>% summarise(count = n())
view(genre_count)
genre_count_sorted <- genre_count[rev(order(genre_count$count)),]
view(genre_count_sorted)

##############################################################################################################

#viz
library(ggridges)

#(1) genre and popularity:
#get the most popular genres:
top_genres <- data %>%
  group_by(genre) %>%
  summarise(avg_popularity = mean(popularity, na.rm = TRUE)) %>%
  arrange(-avg_popularity) %>%
  head(10)  # Choose the top 10 most popular genres, you can change this number

top_genre_names <- top_genres$genre

filtered_data_frame <- data %>% filter(genre %in% top_genre_names)

ggplot(filtered_data_frame, aes(x = popularity, y = genre, fill = genre)) +
  geom_density_ridges() +
  ggtitle("Popularity by Top Genres") +
  xlab("Popularity") +
  ylab("Genre") +
  theme_ridges() +
  theme(legend.position = "none")


#(2)popularity vs year:
ggplot(data, aes(x = year, y = popularity)) +
  geom_point() +
  geom_smooth(method = 'lm') +
  ggtitle("Popularity vs. Year") +
  xlab("Year") +
  ylab("Popularity")

#####################################################################################################################################
#popularity and song attributes:
library(reshape2)
library(corrplot)



#correlation matrix viz
cor_matrix <- cor(data[, c('popularity', 'danceability', 'energy', 'loudness', 'speechiness', 'acousticness', 'instrumentalness', 'liveness', 'valence', 'tempo', 'duration_ms')], use = "complete.obs")  # use complete.obs to remove NA values
cor_matrix['popularity',]

# Create the correlation plot
corrplot(cor_matrix, method="circle",
         number.cex = 0,  # Set font size of numbers to 0 to hide them
         tl.cex = 0.9,    # Font size for tick labels
         tl.col = "black",  # Color of tick labels
         cl.cex = 0.8,    # Font size for color legend
         mar = c(0.1, 0.1, 0.1, 0.1),  # Margins
         tl.srt = 45)  # Rotate tick labels for better visibility)


#check for multicolinearlity:
# Function to calculate VIF
calculate_vif <- function(data_frame) {
  variables <- names(data_frame)
  vif_values <- numeric(length(variables))
  
  for (i in seq_along(variables)) {
    temp_var <- variables[i]
    temp_formula <- as.formula(paste(temp_var, "~ ."))
    temp_data <- data_frame[, c(temp_var, setdiff(variables, temp_var))]
    temp_lm <- lm(temp_formula, data = temp_data)
    vif_values[i] <- 1 / (1 - summary(temp_lm)$r.squared)
  }
  
  return(data.frame(Variable = variables, VIF = vif_values))
}

# Sample usage:
vif_result <- calculate_vif(data[, c('danceability', 'energy', 'loudness', 'speechiness', 'acousticness', 'instrumentalness', 'liveness', 'valence', 'tempo', 'duration_ms')])
print(vif_result)
view(vif_result)

#Variable      VIF
#1      danceability 1.565057
#2            energy 4.491122
#3               key 1.030594
#4          loudness 3.431012
#5              mode 1.043719
#6       speechiness 1.185160
#7      acousticness 2.606992
#8  instrumentalness 1.432808
#9          liveness 1.185146
#10          valence 1.636655
#11            tempo 1.098224
#12      duration_ms 1.049545

#not a high degree (under 5)
#############################################################################################################################################################
#Regressions

#regular multivariate:
set.seed(123)
multivariate_fit <- lm(popularity ~ danceability + energy + loudness + speechiness + acousticness + instrumentalness + liveness + valence + tempo + duration_ms, 
          data = data)
summary(multivariate_fit)



#Call:
#  lm(formula = popularity ~ danceability + energy + loudness + 
 #      speechiness + acousticness + instrumentalness + liveness + 
  #     valence + tempo + duration_ms, data = data)

#Residuals:
 # Min      1Q  Median      3Q     Max 
#-31.420 -12.484  -2.654  10.210  88.768 

#Coefficients:
 # Estimate Std. Error t value Pr(>|t|)    
#(Intercept)       3.068e+01  1.389e-01  220.87  < 2e-16 ***
 # danceability      1.064e+01  9.643e-02  110.30  < 2e-16 ***
  #energy           -7.407e+00  1.115e-01  -66.41  < 2e-16 ***
  #loudness          3.105e-01  4.643e-03   66.87  < 2e-16 ***
  #speechiness      -3.913e+00  1.222e-01  -32.02  < 2e-16 ***
  #acousticness     -3.226e+00  6.477e-02  -49.81  < 2e-16 ***
  #instrumentalness -6.182e+00  4.665e-02 -132.50  < 2e-16 ***
  #liveness         -3.154e+00  7.710e-02  -40.90  < 2e-16 ***
  #valence          -8.835e+00  6.781e-02 -130.30  < 2e-16 ***
  #tempo             1.393e-03  5.013e-04    2.78  0.00544 ** 
  #duration_ms      -1.188e-05  9.764e-08 -121.68  < 2e-16 ***
  #---
  #Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

#Residual standard error: 15.34 on 1159753 degrees of freedom
#Multiple R-squared:  0.06752,	Adjusted R-squared:  0.06752      IMPORTANT!!
#F-statistic:  8398 on 10 and 1159753 DF,  p-value: < 2.2e-16




#high significance of predictors but low R squared value. Checking for multicolinear:
library(usdm)

vif_values <- vif(data[, c('danceability', 'energy', 'loudness', 'speechiness', 'acousticness', 'instrumentalness', 'liveness', 'valence', 'tempo', 'duration_ms')])
print(vif_values)

#Variables      VIF
#1      danceability 1.540890
#2            energy 4.469492 pretty high
#3          loudness 3.450754 moderatley high
#4       speechiness 1.156944
#5      acousticness 2.566676
#6  instrumentalness 1.444809
#7          liveness 1.163976
#8           valence 1.622056
#9             tempo 1.107918
#10      duration_ms 1.049335


##############################################################################################################################################

#visulize impact of predictors

# Load required library
library(ggplot2)

# Create a data frame with coefficients and variable names
coefficients_df <- data.frame(
  Variable = c("danceability", "energy", "loudness", "speechiness", "acousticness", "instrumentalness", "liveness", "valence", "tempo", "duration_ms"),
  Coefficient = c(10.64, -7.41, 0.3105, -3.91, -3.23, -6.18, -3.15, -8.83, 0.001393, -0.00001188)
)

# Create a coefficient plot
coeff_plot <- ggplot(coefficients_df, aes(x = Variable, y = Coefficient)) +
  geom_bar(stat = "identity", fill = "skyblue") +
  geom_hline(yintercept = 0, linetype = "dashed", color = "red") +
  coord_flip() +  # Flip the axis for horizontal bars
  labs(
    title = "Impact of Predictors on Popularity (Coefficients of the predictors)",
    x = "Variable",
    y = "Coefficient Change in Popularity"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 2)  # Adjust title alignment to the left
  )

# Print the coefficient plot
print(coeff_plot)




###################################################################################################################]
#Random Forest + Viz:
library(ranger)

# Fit a Random Forest model
# Assuming 'data' is your original data frame
subset_data <- data[, c("popularity", "danceability", "energy", "loudness", "speechiness", "acousticness", "instrumentalness", "liveness", "valence", "tempo", "duration_ms")]
view(head(subset_data,1000))
# Fit the Random Forest model using the subsetted data
set.seed(234)
rf_model <- ranger(popularity ~ ., 
                   data = subset_data, 
                   num.trees = 100, 
                   importance = 'permutation')

print(rf_model)
#Ranger result

#Call:
#  ranger(popularity ~ ., data = subset_data, num.trees = 100, importance = "permutation") 

#Type:                             Regression 
#Number of trees:                  100 
#Sample size:                      1159764 
#Number of independent variables:  10 
#Mtry:                             3 
#Target node size:                 5 
#Variable importance mode:         permutation 
#Splitrule:                        variance 
#OOB prediction error (MSE):       201.0056 Important!
#R squared (OOB):                  0.2034667 Important!


#since OOB prediction error looks high at 201, let me check the range of 'popularity'

min_value <- min(data$popularity, na.rm = TRUE)
max_value <- max(data$popularity, na.rm = TRUE)

range_value <- max_value - min_value

print(paste("Minimum Value: ", min_value))
print(paste("Maximum Value: ", max_value))
print(paste("Range: ", range_value))





summary(rf_model)
#Length  Class         Mode     
#predictions               1159764 -none-        numeric  
#num.trees                       1 -none-        numeric  
#num.independent.variables       1 -none-        numeric  
#mtry                            1 -none-        numeric  
#min.node.size                   1 -none-        numeric  
#variable.importance            10 -none-        numeric  
#prediction.error                1 -none-        numeric  
#forest                          7 ranger.forest list     
#splitrule                       1 -none-        character
#treetype                        1 -none-        character
#r.squared                       1 -none-        numeric  
#call                            5 -none-        call     
#importance.mode                 1 -none-        character
#num.samples                     1 -none-        numeric  
#replace                         1 -none-        logical  





# Assuming 'rf_model' is your Random Forest model
importance_scores <- importance(rf_model)
importance_scores

# Extract variable names and importance scores
variable_names <- names(importance_scores)
importance_values <- unlist(importance_scores)

# Create a data frame for plotting
importance_df <- data.frame(
  Variable = variable_names,
  Importance = importance_values
)

# Create a bar plot with rotated x-axis labels using ggplot2
ggplot(importance_df, aes(x = Variable, y = Importance)) +
  geom_bar(stat = "identity", fill = "darkgreen") +
  labs(
    title = "Variable Importance in Random Forest Model",
    x = "",  # Remove x-axis label
    y = "Importance Score"
  ) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))  # Rotate x-axis labels to 45 degrees

#############################################################################################################

#Charting direction of the predictor variables:

library(pdp)
# 'danceability' is the predictor of interest
partial_plot <- partial(rf_model, pred.var = "danceability")
plot(partial_plot)



####################################################################################################################






