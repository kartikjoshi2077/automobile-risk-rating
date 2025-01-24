# Automobile Dataset Analysis and Modeling

## Overview
This project analyzes the **Automobile Dataset** to explore the relationship between key vehicle attributes and their risk ratings (`symboling`). The project involves data preprocessing, visualization, principal component analysis (PCA), and building a predictive model using **Random Forest**. The analysis also includes identifying outliers and evaluating feature importance.

## Goals
- **Data Exploration:** Visualize and understand the distribution and relationships of key variables in the dataset.
- **Dimensionality Reduction:** Use PCA to reduce the dataset's complexity while retaining significant information.
- **Predictive Modeling:** Develop a Random Forest model to predict `symboling` (a measure of risk factor).
- **Insights:** Identify the most important features influencing vehicle risk.

---

## Project Workflow

### 1. Data Preprocessing
- Replaced missing values (`?`) with `NA` and removed rows with `NA` values.
- Converted categorical variables (e.g., `num.of.doors`, `num.of.cylinders`) into numerical values using mapping techniques.
- Ensured numeric columns were correctly formatted and ready for analysis.
- Removed outliers based on the **Interquartile Range (IQR)** method, resulting in 36 outliers being excluded from the dataset.

### 2. Data Visualization
- Created histograms to analyze the distribution of key variables such as `price` and `symboling`.
- Visualized relationships between variables such as `price vs horsepower` and `price vs engine size`.
- Generated a correlation heatmap to explore multicollinearity among numerical features.

### 3. Principal Component Analysis (PCA)
- Performed PCA on the standardized dataset to reduce dimensionality while preserving variance.
- Selected the top principal components that explain 85% of the variance.
- Visualized the cumulative variance explained by principal components to determine the optimal number.

### 4. Predictive Modeling with Random Forest
- Split the dataset into training (70%) and testing (30%) subsets.
- Built a **Random Forest model** to predict the `symboling` score based on the selected principal components.
- Evaluated the model using the following metrics:
  - **Mean Squared Error (MSE):** 0.1501
  - **Mean Absolute Error (MAE):** 0.2640
  - **Root Mean Squared Error (RMSE):** 0.3874
  - **R-squared (R²):** 0.8104
- Visualized feature importance to identify key predictors contributing to the model.

---

## Key Findings
1. **Correlation Analysis:** Strong relationships were observed between variables such as `price`, `horsepower`, and `engine size`.
2. **Outlier Removal:** Eliminating outliers improved the reliability of the analysis and model performance.
3. **PCA Results:** The first few principal components explained the majority of variance, allowing dimensionality reduction without significant information loss.
4. **Model Performance:** The Random Forest model achieved an **R² score of 0.81**, indicating a strong predictive ability.
5. **Feature Importance:** Engine-related features, such as `engine size` and `horsepower`, were among the most important predictors for vehicle risk (`symboling`).

---

## Repository Contents
- **`Code.R`:** R script implementing the analysis, visualization, PCA, and Random Forest modeling.
- **Dataset:** The automobile dataset used in the project.
