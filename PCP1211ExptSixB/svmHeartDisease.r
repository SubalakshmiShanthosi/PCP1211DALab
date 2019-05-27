# Use library TeachingDemos to save output and commands
library(TeachingDemos)

txtStart("svmOutput.txt")

# SVM Classification using Linear Kernel

# Importing SVM library caret

library(caret)

# Loading CSV file to data frame

heart_df <- read.csv("/home/subalakshmi/PCP1211DALab/PCP1211ExptSevenB/heart_tidy.csv", sep = ',', header = FALSE)

# Showing the dataset description

# str(heart_df)

# head(heart_df)

# Split dataset for training and testing

set.seed(3033)
intrain <- createDataPartition(y = heart_df$V14, p= 0.7, list = FALSE)
training <- heart_df[intrain,]
testing <- heart_df[-intrain,]

# Printing the dimension
dim(training)
dim(testing)

# Preprocessing dataset - checking missing values
anyNA(heart_df)

# Summary Stats

summary(heart_df)

# Converting target to factor variable 

training[["V14"]] = factor(training[["V14"]])

# Training SVM model

trctrl <- trainControl(method = "repeatedcv", number = 10, repeats = 3)
set.seed(3233)

svm_Linear <- train(V14 ~., data = training, method = "svmLinear",
                    trControl=trctrl,
                    preProcess = c("center", "scale"),
                    tuneLength = 10)

# Printing trained SVM model

# svm_Linear

# Predicting the model

test_pred <- predict(svm_Linear, newdata = testing)

# Printing the prediction 

#str(test_pred)

# Confusion Matrix

confusionMatrix(factor(test_pred, levels = 1:148),
  factor(testing$V14, levels = 1:148))
# Parameter Tuning

grid <- expand.grid(C = c(0,0.01, 0.05, 0.1, 0.25, 0.5, 0.75, 1, 1.25, 1.5, 1.75, 2,5))
set.seed(3233)
svm_Linear_Grid <- train(V14 ~., data = training, method = "svmLinear",
                           trControl=trctrl,
                           preProcess = c("center", "scale"),
                           tuneGrid = grid,
                           tuneLength = 10)
plot(svm_Linear_Grid,main = "SVM Linear Grid")
#Prediction - with tuning exprementation

test_pred_grid <- predict(svm_Linear_Grid, newdata = testing)
#test_pred_grid

#Confusion matrix

confusionMatrix(factor(test_pred_grid, levels = 1:148),
  factor(testing$V14, levels = 1:148))

# SVM Classification for Non Linear Kernal - RBF 
set.seed(3233)
svm_Radial <- train(V14 ~., data = training, method = "svmRadial",
                      trControl=trctrl,
                      preProcess = c("center", "scale"),
                      tuneLength = 10)

# Visualisation SVM -RBF Kernal
plot(svm_Radial, main= "SVM with RBF Kernal")

# Prediction of RBF trained model
test_pred_Radial <- predict(svm_Radial, newdata = testing)
confusionMatrix(factor(test_pred_Radial, levels = 1:148),
                factor(testing$V14, levels = 1:148))

# Tuning parameters of SVM - RBF

grid_radial <- expand.grid(sigma = c(0,0.01, 0.02, 0.025, 0.03, 0.04,
                                     0.05, 0.06, 0.07,0.08, 0.09, 0.1, 0.25, 0.5, 0.75,0.9),
                           C = c(0,0.01, 0.05, 0.1, 0.25, 0.5, 0.75,
                                 1, 1.5, 2,5))
set.seed(3233)
svm_Radial_Grid <- train(V14 ~., data = training, method = "svmRadial",
                           trControl=trctrl,
                           preProcess = c("center", "scale"),
                           tuneGrid = grid_radial,
                           tuneLength = 10)

#svm_Radial_Grid

# Visualisation
plot(svm_Radial_Grid, main="SVM RBF after tuning")
# Prediction with tuning
test_pred_Radial_Grid <- predict(svm_Radial_Grid, newdata = testing)

# Confusion Matrix
confusionMatrix(
  factor(test_pred_Radial_Grid, levels = 1:148),
  factor(testing$V14, levels = 1:148) )

txtStop()
