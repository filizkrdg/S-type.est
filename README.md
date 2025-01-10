# stype_estimator:An R package for Stype robust estimator
This R package provides an implementation of the **S-type estimator**, a robust estimation method designed for general linear regression models. The S-type estimator was introduced by Sazak and Mutlu (2025) in their study, "Comparison of the Robust Methods in the General Linear Regression Model."

## Features
- Perform robust linear regression using the S-type estimator.
- Minimize the influence of outliers and leverage points.
- Diagnostic tools for model performance assessment.
- Enhanced efficiency and adaptability for datasets with challenging characteristics.

## Installation
To install the package from GitHub, use the following command:


# Installing stype_estimator from CRAN
```
install.packages("stype_estimator")
```
# Installing stype_estimator development version
Please make sure that you installed devtools package first:
```
install.packages("devtools")
```

# Install the package
```
devtools::install_github("filizkrgd/stype_estimator")
```
##Installing stype_estimator from CRAN
```
install.packages("stype_estimator")
```
Installing stype_estimator development version
Please make sure that you installed devtools package.


#Example usage of the package.
You can use datasets package to have example data to test stype_estimator package. 
datasets package is being installed, while you are installing stype_estimator package, so you don't have to install the package again.

Prepare the dataset
```
library(datasets)
data(airquality)
str(airquality)
cleanairquality=na.omit(airquality)
Y1=cleanairquality$Ozone
X1=cleanairquality$Temp
X2=cleanairquality$Wind
X3=cleanairquality$Solar.R
X=data.frame("X1"=X1,"X2"=X2,"X3"=X3)
Y=data.frame("Y"=Y1)
regsx=regstype(Y,X,1.548)
```

## References
Sazak, M., & Mutlu, B. (2025). Comparison of the Robust Methods in the General Linear Regression Model.

## Contact
For any questions please contact:

Hakan Savas Sazak, hakan.savas.sazak@ege.edu.tr
Filiz Karadag, filiz.karadag@ege.edu.tr
Olgun Aydin, olgun.aydin@pg.edu.pl
