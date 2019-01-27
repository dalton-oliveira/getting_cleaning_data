# Getting and Cleaning Data
The script run_analysis.R is intended to merge all observations from the data provided by [Human Activity Recognition Using Smartphones Data Set]([http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones#), improve the variable naming and calculate the average of each variable by _activity_ and _subject_.
The script writes the result in standard output.

To run the script, it is required to have the packages _data.table_ and _dplyr_. On R environment, setup by running:
 
```R
install.packages("data.table")
install.packages("dplyr")
```

To run the script from shell: 
```bash
Rscript run_analysis.R
```