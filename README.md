# visualizeR - Automated exploratory data analysis for classification problems

#Description
visualizeR is a library for R to attempt to make exploratory data analysis for classification problems in the field of machine learning automatic.

It supports two-class and multi-class classification problems. Some data cleaning needs to be performed prior to runnng visualizeR, it is also recommended that all ID and Date features are removed from the dataset. 

visualizeR automatically identifies categorical and numerical features in your data. It just requires your data.frame name and the outcome/target feature you are trying to predict as a character format e.g. "TARGET"

visualizeR has some "simplistic" data cleaning built into it, for example, if a feature is encoded as a factor feature but has more than 20 levels, visualizeR will not plot that feature, as it will be un-readable. If a feature is encoded as a numeric but has 20 or less unique values, visualizeR automatically changes that feature to a factor(categorical) feature.

visualizeR can also impute and encode missing values for both numeric (continuous) and factor (categorical) features, by using a median replacement approach for numeric features and uses the replacement value of "Missing" for categorical features.

visualizeR can also output all the plots to a .PDF file, when using the parameter 'outputPath' be sure to check the slashes ("/","\") that your system uses to ensure an error free experience.

For full parameter details please run the following command after you have installed and loaded visualizeR. '?visualizeR'

#Package Dependencies:

visualizeR utilizes the package `pacman`, which manages all packages in R. Install `pacman` with the installation of `visualizeR` and everything package wise will be sorted.
