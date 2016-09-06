# visualizeR

visualizeR is a library for R to attempt to make exploratory data analysis for classification problems in the field of machine learning automatic.

It supports two-class and multi-class classification problems. Some data cleaning needs to be performed prior to runnng visualizeR, it is also recommended that all ID and Date features are removed from the dataset. 

visualizeR automatically identifies categorical and numerical features in your data. It just requires your data.frame name and the outcome/target feature you are trying to predict as a character format e.g. "TARGET"

visualizeR has some "simplistic" data cleaning built into it, for example, if a feature is encoded as a factor feature but has more than 20 levels, visualizeR will not plot that feature, as it will be un-readable. If a feature is encoded as a numeric but has 20 or less unique values, visualizeR automatically changes that feature to a factor(categorical) feature.

visualizeR can also impute and encode missing values for both numeric (continuous) and factor (categorical) features, by using a median replacement approach for numeric features and uses the replacement value of "Missing" for categorical features.

visualizeR supports the following chart types for factor(categorical) features: 
1. Confusion - provides a confusion plot shaded with respect to the frequency in each level and the outcome feature
2. stackedHist - provides a stacked historgram with respect to the outcome feature and frequency of the levels

visualizeR supports the following chart types for numeric(continuous) features: 
1. stackedhist - provides a stacked histogram with the nr of bins equal to the nrBins parameter set and color coded according to the outcome feature
2. densityLine - provides a density line plot color coded according to the outcome feature
3. densityFill - provides a density filled plot color coded according to the outcome feature
4. boxPlot - provides a box plot color coded according to the outcome feature

visualizeR can also output all the plots to a .PDF file, when using the parameter 'outputPath' be sure to check the slashes ("/","\") that your system uses to ensure an error free experience.
