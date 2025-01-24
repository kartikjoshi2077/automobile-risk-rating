####################### Automobile Dataset ##########################
####################### Final Project - MGSC 661 ###################
############### Kartik Joshi ################ 261208148 ############


#### Loading dataset
automobile_data = read.csv("C:/Users/Dell/Desktop/Dataset 5 — Automobile data.csv")

# Replace '?' with NA
automobile_data[automobile_data == "?"] = NA
automobile_data = na.omit(automobile_data)
cat("Number of missing values:", sum(is.na(automobile_data)), "\n")

#### Visualizations ####
# Visualizing the distribution of the 'symboling' variable
hist(automobile_data$symboling, 
     main = "Distribution of Symboling", 
     xlab = "Symboling (Risk Factor)", 
     col = "lightblue", 
     breaks = 10, 
     border = "black")

# Adding grid lines for better readability
grid(nx = NULL, ny = NULL, lty = 2, col = "gray")

# Distribution of price variable
hist(as.numeric(as.character(automobile_data$price)), 
     main = "Distribution of Price", 
     xlab = "Price", 
     col = "lightblue", 
     breaks = 20)

# Pair plots for key variables
plot(as.numeric(as.character(automobile_data$price)) ~ as.numeric(as.character(automobile_data$horsepower)), 
     main = "Price vs Horsepower", 
     xlab = "Horsepower", 
     ylab = "Price", 
     col = "blue")

plot(as.numeric(as.character(automobile_data$price)) ~ as.numeric(as.character(automobile_data$engine.size)), 
     main = "Price vs Engine Size", 
     xlab = "Engine Size", 
     ylab = "Price", 
     col = "red")

#### Handling Categorical Variables ####
categorical_columns = sapply(automobile_data, is.character)
automobile_data[categorical_columns] = lapply(automobile_data[categorical_columns], as.factor)

# Replace '?' in specific columns
automobile_data$num.of.doors[automobile_data$num.of.doors == "?"] = NA
automobile_data$num.of.cylinders[automobile_data$num.of.cylinders == "?"] = NA

# Map categorical variables to numeric
door_mapping = c("two" = 2, "four" = 4)
automobile_data$num.of.doors = as.numeric(door_mapping[as.character(automobile_data$num.of.doors)])

cylinder_mapping = c(
  "two" = 2, "three" = 3, "four" = 4, "five" = 5,
  "six" = 6, "eight" = 8, "twelve" = 12
)
automobile_data$num.of.cylinders = as.numeric(cylinder_mapping[as.character(automobile_data$num.of.cylinders)])

#### Ensure numeric columns are correctly formatted ####
numeric_columns_df = c("normalized.losses", "price", "bore", "stroke", 
                       "horsepower", "peak.rpm", "symboling", "num.of.doors", "num.of.cylinders")

for (col in numeric_columns_df) {
  automobile_data[[col]] = as.numeric(as.character(automobile_data[[col]]))
}

#### Visualize Multicollinearity ####
library(corrplot)
numeric_columns = sapply(automobile_data, is.numeric)
numeric_data = automobile_data[, numeric_columns]
cor_matrix = cor(numeric_data, use = "pairwise.complete.obs")
corrplot(cor_matrix, method = "color", type = "lower", 
         tl.cex = 0.8, tl.col = "black", title = "Heatmap of Correlation Matrix")

#normalized.losses      num.of.doors        wheel.base            length             width 
#1.811085          1.852450          6.611232          9.028608          6.239374 
#height       curb.weight  num.of.cylinders       engine.size              bore 
#2.721778         19.352501          7.519388         24.775645          4.697527 
#stroke compression.ratio        horsepower          peak.rpm          city.mpg 
#2.157821          2.611608          7.508538          1.978073         26.338672 
#highway.mpg             price 
#24.800992          6.745875 

#### Principle Component Analysis (PCA) ####
pca_result = prcomp(numeric_data, scale. = TRUE)
summary(pca_result)

#Importance of components:
#  PC1    PC2     PC3     PC4     PC5    PC6     PC7    PC8     PC9    PC10   PC11
#Standard deviation     2.8814 1.7323 1.31106 1.02665 0.88809 0.8496 0.74085 0.6748 0.60783 0.51328 0.4686
#Proportion of Variance 0.4612 0.1667 0.09549 0.05856 0.04382 0.0401 0.03049 0.0253 0.02053 0.01464 0.0122
#Cumulative Proportion  0.4612 0.6280 0.72345 0.78201 0.82582 0.8659 0.89642 0.9217 0.94224 0.95688 0.9691
#PC12    PC13    PC14    PC15    PC16    PC17    PC18
#Standard deviation     0.39008 0.36044 0.30903 0.26886 0.24818 0.16367 0.13552
#Proportion of Variance 0.00845 0.00722 0.00531 0.00402 0.00342 0.00149 0.00102
#Cumulative Proportion  0.97753 0.98475 0.99005 0.99407 0.99749 0.99898 1.00000


# Plot explained variance
explained_variance = cumsum(pca_result$sdev^2 / sum(pca_result$sdev^2))
plot(explained_variance, type = "b", xlab = "Principal Components", 
     ylab = "Cumulative Proportion of Variance Explained", 
     main = "Variance Explained by PCA", col = "blue")
abline(h = 0.85, col = "red", lty = 2)

selected_pcs = which(explained_variance >= 0.85)[1]
pca_data = as.data.frame(pca_result$x[, 1:selected_pcs])
pca_data$symboling = numeric_data$symboling

#### Outlier Removal ####
detect_outliers = function(x) {
  Q1 = quantile(x, 0.25, na.rm = TRUE)
  Q3 = quantile(x, 0.75, na.rm = TRUE)
  IQR = Q3 - Q1
  outliers = (x < (Q1 - 1.5 * IQR)) | (x > (Q3 + 1.5 * IQR))
  return(outliers)
}

outlier_flags = sapply(pca_data[, -ncol(pca_data)], detect_outliers)
outlier_indices = which(rowSums(outlier_flags) > 0)
pca_data_cleaned = pca_data[-outlier_indices, ]
cat("Number of outliers removed:", length(outlier_indices), "\n")

#Number of outliers removed: 36 

#### Random Forest Model ####
library(randomForest)
set.seed(123)
train_indices = sample(1:nrow(pca_data_cleaned), 0.7 * nrow(pca_data_cleaned))
train_data = pca_data_cleaned[train_indices, ]
test_data = pca_data_cleaned[-train_indices, ]

rf_model = randomForest(symboling ~ ., data = train_data, importance = TRUE)
print(rf_model)

# Predictions and Evaluation
predictions = predict(rf_model, newdata = test_data)
mse = mean((test_data$symboling - predictions)^2)
mae = mean(abs(test_data$symboling - predictions))
rmse = sqrt(mse)
r_squared = 1 - sum((test_data$symboling - predictions)^2) / 
  sum((test_data$symboling - mean(test_data$symboling))^2)

cat("Performance Metrics:\n")
cat("Mean Squared Error (MSE):", mse, "\n")
cat("Mean Absolute Error (MAE):", mae, "\n")
cat("Root Mean Squared Error (RMSE):", rmse, "\n")
cat("R-squared (R²):", r_squared, "\n")


#Mean Squared Error (MSE): 0.1501138 
#Mean Absolute Error (MAE): 0.2640099 
#Root Mean Squared Error (RMSE): 0.3874452 
#R-squared (R²): 0.810419 



# Feature Importance
importance = importance(rf_model)
varImpPlot(rf_model, main = "Feature Importance (Random Forest)")
