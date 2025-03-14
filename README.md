# S-type.est: An R package for the S-type estimators
This R package provides an implementation of the **S-type.est**, a robust estimation method designed for the general linear regression models. The S-type estimators were introduced by Sazak and Mutlu (2023) in their study, "Comparison of the Robust Methods in the General Linear Regression Model."

## Features
- Performs robust linear regression using the S-type estimators.
- Minimizes the MSE of the model.
- Minimizes the influence of outliers and leverage points.
- Diagnostic tools for model performance assessment.
- Enhanced efficiency and adaptability for data sets with challenging characteristics.

# Installation
To install the package from GitHub, use the following command:

# Installing S-type.est development version
Please make sure that you installed `devtools` package first:
```
install.packages("devtools")
```

# Install the package
```
devtools::install_github("filizkrgd/S-type.est")
```
# Installing `S-type.est` from CRAN
```
install.packages("S-type.est")
```
Installing `S-type.est` development version

# Example usage of the package.
You can use `datasets` package to have example data to test `S-type.est` package. 
datasets package is being installed, while you are installing `S-type.est` package, so you don't have to install the package again.

- Prepare the dataset
```
library(datasets)
data(airquality)
str(airquality)
cleanairquality=na.omit(airquality)
Y1=cleanairquality$Ozone
X1=cleanairquality$Temp
X2=cleanairquality$Wind
X3=cleanairquality$Solar.R
x=data.frame("X1"=X1,"X2"=X2,"X3"=X3)
y=data.frame("Y"=Y1)
```
- Run `regstype`  function to get regression results using the S-type estimators.

```
regsx=regstype(y,x,1.548)
```

## References
- Sazak, M., & Mutlu, B. (2023). Comparison of the Robust Methods in the General Linear Regression Model.

## Contact
For any questions please contact:

- Hakan Savas Sazak, hakan.savas.sazak@ege.edu.tr
- Filiz Karadag, filiz.karadag@ege.edu.tr
- Olgun Aydin, olgun.aydin@pg.edu.pl
