
#' visualizeR - Automated exploratory data analysis for classification problems
#'
#' visualizeR automates exploratory data analysis for classification problems in machine learning. The problem can be two-class or multi-class classification. It is recommended that all ID and Date features be removed before running this algorithm, cleaning the data before running this is also recommended. visualizeR has some data cleaning aspects built into it but cannot account for domain knowledge cleaning.
#' @param df A data.frame object containing plotting features and target/outcome feature. Cannot be left blank.
#' @param Outcome The feature name of the outcome as character format, e.g. 'Target'. Cannot be left blank.
#' @param nrBins The number of bins to use in histogram plots of numerical features should 'stackedHist' be used as the chart type in the parameter 'NumChartType'.
#' @param sample Should a random sample be taken in order to speed the plotting process up.
#' @param clipOutliers Should outliers be fixed in the data using a median approach. Possible values: 'Y','N'
#' @param handleMissing Should missing values be corrected with 'Missing' value for categorical variables and median imputation for conitnuous variables. Possible values: 'Y','N', Should this be left as 'N' then missing observations will be removed from the plots.
#' @param CatChartType Indicates the type of chart to use when plotting categorical/factor features. Possible values: 'stackedHist', 'Confusion'
#' @param NumChartType Indicates the type of chart to use when plotting numerical/continuous features. Possible values: 'stackedHist', 'densityLine', 'densityFill', 'boxPlot'
#' @param summaryStats Should summary statistics be printed for predictors in the dataset, summary stats for continuous and frequency tables for categorical variables. Possible values: 'Y','N'
#' @param seed Used only for the sampling of the data and to reproduce the plots.
#' @param maxLevels The maximum levels allowed for factor features, if a feature has levels more than the threshold it will not be plotted.
#' @param ouputPath A file path where the plots should be saved in a PDF document. If left blank all plots will be displayed in R.
#' @param outputFileName The name of the file containing all the plots.
#' @keywords visualizeR
#' @export
#' @examples
#' EXAMPLE 1:
#' library(datasets)
#' train <- data.frame(iris)
#'visualizeR(df = train,
#'           Outcome = 'Species',
#'           nrBins = 30,
#'           sample = 1,
#'           clipOutliers = 'Y',
#'           CatChartType = 'stackedHist',
#'           NumChartType = 'boxPlot')
#'           
#'EXAMPLE 2:
#'visualizeR(df = train,
#'Outcome = 'Species',
#'nrBins = 30,
#'sample = 1,
#'clipOutliers = 'Y',
#'CatChartType = 'Confusion',
#'NumChartType = 'stackedHist',
#'summaryStats = 'Y',
#'outputPath = 'C:/Users/User/Documents',
#'outputFileName = 'IrisExploratoryDataAnalysis')
#' @author 
#' Xander Horn


visualizeR <- function(df,
                       Outcome,
                       nrBins = 30,
                       sample = 0.3,
                       clipOutliers = 'Y',
                       handleMissing = 'Y',
                       CatChartType = 'stackedHist',
                       NumChartType = 'densityFill',
                       summaryStats = 'Y',
                       seed = 1234,
                       maxLevels = 25,
                       outputPath = '',
                       outputFileName = 'outputPlots'){

 
  
#**************************************************************************************************
                                    #START FUNCTION
#************************************************************************************************** 
  
  library(pacman)
  
  p_load(dplyr,ggplot2,knitr,viridis,sqldf)
  
  options(scipen=999)  
  
  cat('\014')
  print("**************************************************************************************************")
  print("                                       Partial Cleaning                                           ")
  print("**************************************************************************************************")
  
  print("MISSING VALUES ARE ENCODED AS 'Missing' FOR CATEGORICAL AND MEDIAN IMPUTATION IS USED FOR NUMERIC")
  
  #IF GRAPHS SHOULD BE OUTPUTTED TO A PDF FILE
  if(outputPath != ''){
    PDFPath = paste(outputPath,'/',outputFileName,'.pdf',sep='')
    pdf(file=PDFPath)
  }
  
  #CHANGE OUTCOME FEATURE TO FACTOR FORMAT
  df[,Outcome] <- as.factor(df[,Outcome])
  
  #SAMPLING 
  set.seed(seed)
  ind <- sample(nrow(df),sample*nrow(df),replace = F)
  df <- df[ind,]
  
  #REMOVE CATEGORICAL FEATURES WITH MORE THAN 25 LEVELS
  remove <- length(ncol(df))
  removeInd <- length(ncol(df))
  remove <- NA
  removeInd <- NA
  
  for(i in 1:ncol(df)){
    
    #CONVERT TO FACTOR FEATURES
    if(class(df[,i]) %in% c('factor','character')){
      df[,i] <- as.factor(df[,i])
    } else {
      df[,i] <- as.numeric(df[,i])
    }
    
    if(class(df[,i]) == 'factor'){
      ind <- length(levels(df[,i])) > maxLevels
      removeInd[i] <- ifelse(ind ==T,i,NA)
      remove[i] <- ifelse(ind ==T,names(df)[i],NA)
    } else if(class(df[,i]) == 'numeric' & length(unique(df[,i])) <= 20){
      print(paste("CHANGED FEATURE: ",names(df)[i]," TO A FACTOR FEATURE DUE TO LOW UNIQUE VALUES",sep=''))
      df[,i] <- as.factor(df[,i])
    }
    
  }
  
  if(sum(is.na(removeInd)) != length(removeInd)){
    remove <- remove[!is.na(remove)]
    removeInd <- removeInd[!is.na(removeInd)]
    
    for(i in 1:length(remove)){
      print(paste("REMOVED FEATURE: ",remove[i]," , HAS TOO MANY LEVELS TO PLOT",sep=''))
      
    }
    
    df <- df[,-removeInd]
  }
  
  print("**************************************************************************************************")
  print("                                       Feature Plotting                                           ")
  print("**************************************************************************************************")
  
  #CLIP OUTLIERS
  for(i in 1:ncol(df)){
    
    print(paste("Plotting Feature",names(df)[i],",",i," Of ",ncol(df),": Missing Observations = ",sum(is.na(df[,i]))))
    
    if(toupper(clipOutliers) == 'Y' & class(df[,i]) == 'numeric'){
      
      feature <- names(df)[i]
      threshold <- quantile(df[,feature],0.99,na.rm = T)
      threshold2 <- quantile(df[,feature],0.01,na.rm = T)
      
      
      outliers <- which(df[,feature] >= threshold)
      outliers2 <- which(df[,feature] <= threshold2)
      
      median <- round(median(df[c(-outliers,-outliers2),feature],na.rm=T))
      df[outliers,feature] <- median
      df[outliers2,feature] <- median
    }
    
    
    #CATEGORICAL FEATURES
    if(class(df[,i]) != 'numeric'){
      
      
      if(handleMissing == 'Y'){
      df[,i] <- as.factor(ifelse(is.na(as.character(df[,i])) == T,'Missing',as.character(df[,i])))
      }
      
      #STACKED HISTOGRAM
      if(CatChartType == 'stackedHist'){
        
        if(length(levels(df[,i])) <= 2){
          vizCat <- df %>% 
            ggplot(aes(x = df[,Outcome], fill = df[,i])) +
            geom_bar(width = 0.6, position = "fill") +
            scale_fill_viridis(name = paste(names(df)[i],": Levels",sep=''), discrete = T, begin = 0.5,end = 0.9) +
            ggtitle(paste("Outcome By ",names(df)[i],sep='')) + 
            labs(x = "Outcome", y ="Percentage Freq")
          
        } else {
          vizCat <- df %>% 
            ggplot(aes(x = df[,Outcome], fill = df[,i])) +
            geom_bar(width = 0.6, position = "fill") +
            scale_fill_viridis(name = paste(names(df)[i],": Levels",sep=''), discrete = T) +
            ggtitle(paste("Outcome By ",names(df)[i],sep='')) + 
            labs(x = "Outcome", y ="Percentage Freq")
        }
        
        #CONFUSION PLOT
      } else if(CatChartType == 'Confusion'){
        vizCat <- ggplot(data=df,aes(df[,i],df[,Outcome]))+ 
          geom_bin2d(bins=nrBins)+
          theme(axis.text.x = element_text(angle=90))+
          #scale_fill_viridis(name = "Outcome Levels", discrete = F) +
          xlab(names(df)[i])+
          ylab('Outcome')+
          ggtitle(paste("Outcome Vs ",names(df)[i],sep=''))
      }
      
      #CONTINEOUS FEATURES  
    } else {
      
      if(handleMissing == 'Y'){
      df[,i] <- ifelse(is.na(df[,i]) == T,median(df[,i],na.rm = T),df[,i])
      }
      #HISTOGRAM CHART TYPE
      if(NumChartType == 'stackedHist'){
        
        vizNum <- ggplot(data = df, aes(x = df[,i],fill = df[,Outcome], colour = df[,Outcome])) +
          geom_histogram(bins = nrBins, alpha = 0.8) + 
          ggtitle(paste("Distribution By Outcome",sep='')) +
          labs(x = names(df)[i], y ="Freq") +
          guides(fill = guide_legend(reverse = TRUE), colour = guide_legend(reverse = TRUE)) 
        
        
        #DENSITY LINE CHART TYPE
      } else if(NumChartType == 'densityLine') {
        
        vizNum <-  qplot(df[,i], data=df, geom="density", colour=df[,Outcome],size=I(1),
                         main="Density Distribution By Outcome", xlab=paste(names(df)[i]), 
                         ylab="Density") 
        
        #DENSITY FILL CHART TYPE  
      } else if(NumChartType == 'densityFill'){
        
        vizNum <- ggplot(df, aes(x = df[,i], fill = df[,Outcome])) +
          geom_density(alpha = 0.5) +
          ggtitle(paste("Density Distribution By Outcome",sep='')) +
          labs(x = names(df)[i], y ="Density") +
          guides(fill = guide_legend(reverse = TRUE), colour = guide_legend(reverse = TRUE)) 
        
        #BOX PLOTS    
      } else if(NumChartType == 'boxPlot'){
        vizNum <-  ggplot(df, aes(x=df[,Outcome], y=df[,i], color = df[,Outcome])) +
          geom_boxplot(outlier.size = 0.1,aes(ymin = min(df[,i]),
                                              lower = as.numeric(quantile(df[,i],na.rm=T)[2]),
                                              middle = median(df[,i]),
                                              upper = as.numeric(quantile(df[,i],na.rm=T)[4]),
                                              ymax = max(df[,i]))) +
          ggtitle(paste("Outcome By ",names(df)[i],sep='')) + 
          labs(x = "Outcome", y =names(df)[i])
        
      }  
    }
    
    viz <- list()
    if(names(df)[i] == Outcome){
      viz <- qplot(df[,Outcome], data = df, fill=df[,Outcome],color = df[,Outcome], main = "Outcome Distribution") + 
        labs(x = "Outcome", y ="Freq") 
    } else if(class(df[,i]) == 'factor'){
      viz <- vizCat
    } else {
      viz <- vizNum
    } 
    print(viz)
  }
  
  if(toupper(summaryStats) == 'Y'){
    print("**************************************************************************************************")
    print("                                       Summary Statistics                                         ")
    print("**************************************************************************************************")
    for(i in 1:ncol(df)){
      
      if(class(df[,i]) == 'numeric'){
        print(paste('Feature :',names(df)[i],sep=''))
        print(summary(df[,i]))
      } else {
        print(paste('Feature: ',names(df)[i],sep=''))
        print(prop.table(table(df[,i])))
      }
    }
    
  }
  
  if(outputPath != ''){
    dev.off()
  }
  invisible(gc)
}


