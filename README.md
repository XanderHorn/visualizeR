# visualizeR - Automated exploratory data analysis for classification problems

`visualizeR` is a library for R to attempt to make exploratory data analysis for classification problems in the field of machine learning automatic.

~~~~~~~~~~~~~~~~~ PLEASE NOTE THAT visualizeR IS IN BETA PHASE ~~~~~~~~~~~~~~~~~ 

#Description

It supports two-class and multi-class classification problems. Some data cleaning needs to be performed prior to runnng visualizeR, it is also recommended that all ID and Date features are removed from the dataset. 

`visualizeR` automatically identifies categorical and numerical features in your data. It just requires your data.frame name and the outcome/target feature you are trying to predict as a character format e.g. "TARGET"

`visualizeR` has some "simplistic" data cleaning built into it, for example, if a feature is encoded as a factor feature but has more than 20 levels, visualizeR will not plot that feature, as it will be un-readable. If a feature is encoded as a numeric but has 20 or less unique values, visualizeR automatically changes that feature to a factor(categorical) feature.

`visualizeR` can also impute and encode missing values for both numeric (continuous) and factor (categorical) features, by using a median replacement approach for numeric features and uses the replacement value of "Missing" for categorical features.

`visualizeR` can also output all the plots to a .PDF file, when using the parameter 'outputPath' be sure to check the slashes ("/","\") that your system uses to ensure an error free experience.

For full parameter details please run the following command after you have installed and loaded `visualizeR`. '?visualizeR'

#Package Dependencies:

`visualizeR` utilizes the package `pacman`, which manages all packages in R. Install `pacman` with the installation of `visualizeR` and everything package wise will be sorted.

#Installation:

To install `visualizeR` simply use the code below:

`install.packages('devtools')`

`library(devtools)`

`devtools::install_github("XanderHorn/visualizeR")`

`library(visualizeR)`

#Parameters:

`df`: A data.frame object containing plotting features and target/outcome feature. Cannot be left blank.

`Outcome`: The feature name of the outcome as character format, e.g. 'Target'. Cannot be left blank.

`nrBins`: The number of bins to use in histogram plots of numerical features should 'stackedHist' be used as the chart type in the parameter: 'NumChartType'.

`sample`: Should a random sample be taken in order to speed the plotting process up.

`clipOutliers`: Should outliers be fixed in the data using a median approach. Possible values: 'Y','N'

`handleMissing`: Should missing values be corrected with 'Missing' value for categorical variables and median imputation for conitnuous variables. Possible values: 'Y','N', Should this be left as 'N' then missing observations will be removed from the plots.

`CatChartType`: Indicates the type of chart to use when plotting categorical/factor features. Possible values: 'stackedHist', 'Confusion'

`NumChartType`: Indicates the type of chart to use when plotting numerical/continuous features. Possible values: 'stackedHist', 'densityLine', 'densityFill', 'boxPlot'

`summaryStats`: Should summary statistics be printed for predictors in the dataset, summary stats for continuous and frequency tables for categorical variables. Possible values: 'Y','N'

`seed`: Used only for the sampling of the data and to reproduce the plots.

`maxLevels`: The maximum allowed levels for factor features. If this threshold is exceeded the feature will not be plotted. Recommended to limit this as it will make plots hard to read.

`nrUniques`: The number of allowed unique values for a feature before it is automatically changed to a categorical feature. If a feature has less than this threshold, the feature will be changed to a categorical feature.

`ouputPath`: A file path where the plots should be saved in a PDF document. If left blank all plots will be displayed in R.

`outputFileName`: The name of the file containing all the plots.

