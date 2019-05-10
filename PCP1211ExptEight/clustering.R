#Installing and loading required R packages
#------------------------------------------
#We'll use mainly two R packages:
#cluster package: for computing clustering
#factoextra package : for elegant ggplot2-based data visualization.
#-------------------

#Install:
#---------

#install.packages("factoextra")
#install.packages("cluster")
#install.packages("magrittr")
#install.packages("NbClust")

#Load packages:
#--------------

library("cluster")
library("factoextra")
library("magrittr")

#Data preparation
#----------------
#Demo data set: the built-in R dataset named USArrest
#Remove missing data
#Scale variables to make them comparable
#------------------------------

# Load  and prepare the data
data("USArrests")

my_data <- USArrests %>%
  na.omit() %>%          # Remove missing values (NA)
  scale()                # Scale variables

# View the firt 3 rows
head(my_data, n = 3)

#Partitioning clustering
#-----------------------
#Partitioning algorithms are clustering techniques that subdivide the data sets into a set of k groups, where k is the number of groups pre-specified by the analyst.
#K-means clustering
#K-medoids clustering or PAM (Partitioning Around Medoids)
#--------------------------

fviz_nbclust(my_data, kmeans, method = "gap_stat")

#Compute and visualize k-means clustering
#-----------------------------

set.seed(123)
km.res <- kmeans(my_data, 3, nstart = 25)
# Visualize
fviz_cluster(km.res, data = my_data, ellipse.type = "convex", palette = "jco", ggtheme = theme_minimal())


#Compute and visualize k-medoids clustering
#-----------------------------

# Compute PAM
library("cluster")
pam.res <- pam(my_data, 3)
# Visualize
fviz_cluster(pam.res)

#Hierarchical clustering
#Hierarchical clustering is an alternative approach to partitioning clustering for identifying groups in the dataset. It does not require to pre-specify the number #of clusters to be #generated.
#----------
#compute and visualize hierarchical clustering:
#-----------
# Compute hierarchical clustering
res.hc <- USArrests %>%
  scale() %>%                    # Scale the data
  dist(method = "euclidean") %>% # Compute dissimilarity matrix
  hclust(method = "ward.D2")     # Compute hierachical clustering

# Visualize using factoextra
# Cut in 4 groups and color by groups
fviz_dend(res.hc, k = 4, # Cut in four groups
          cex = 0.5, # label size
          k_colors = c("#2E9FDF", "#00AFBB", "#E7B800", "#FC4E07"),
          color_labels_by_k = TRUE, # color labels by groups
          rect = TRUE # Add rectangle around groups
)

#Determining the optimal number of clusters
#---------------------


set.seed(123)

# Compute
library("NbClust")
res.nbclust <- USArrests %>%
  scale() %>%
  NbClust(distance = "euclidean",
          min.nc = 2, max.nc = 10, 
          method = "complete", index ="all") 

# Visualize
library(factoextra)
fviz_nbclust(res.nbclust, ggtheme = theme_minimal())
