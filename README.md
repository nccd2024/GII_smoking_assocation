# GII_smoking_assocation

## Overview

- Code for paper entitled "Association of regional gender equality and tobacco smoking in China and globally: analysis based on a national population cohort and the GBD data".
- It should be noted that, to enhance readability, the program has been simplified based on the provided demo data. These procedures included simplifying covariates included in the models, adjusting the coordinate axes of the plotted graphs, and only providing programs that retain the most essential result tables and charts.

## Repo Contents

- SAS: SAS code.
- R: R code.
- Demo data: demo data to test the code.

## System Requirements

- Hardware Requirements: The codes necessitate only a standard computer with sufficient RAM to support the operations defined by the user. For minimal performance, a computer with approximately 2 GB of RAM is recommended. Given large sample size of this paper, we utilized computer with the following specifications: RAM: 64GB; CPU: 2 cores, 2.60 GHz/core.
- SoSoftware Requirements: The codes were tested on Windows operating systems. R (version 4.4.1) and SAS (version 9.4) were used for the original analysis presented in the paper.

## Installation Guide

The statistical analysis software, either R or SAS, can be successfully installed by any instruction on the internet. The installation time varies depending on the individual user. However, if you already have either of these two software programs installed, the installation time is 0.

## Instructions to run on data

No special instructions need to be stated in our analysis. Simply adhere to the guidelines for basic SAS and R statistical software, such as:

- SAS: you need to specify the folder for saving the data, the folder for exporting the results, the macro program to call, etc.
- R: you need to install the necessary packages first, and load the packages when you use it.

## Codes and expected output

1. **GII distribution and compare.SAS** was used to calculate the distribution of the Gender Inequality Index (GII) across various regions, testing the regional difference, conducting correlation analyses, and generating plots.
2. **SMD** of baseline characteristics.SAS was used to describe the baseline characteristics of participants and calculated the standardized mean difference(SMD) between different sexes by calling a published SAS macro.
3. **RCS.R** was used to perform restricted cubic spline (RCS) analysis to examine the relationship between GII and smoking behaviours of concern, and plotting the resulting graphs.
4. **HGLM Model.SAS** was used to perform hierarchical generalized linear models (HGLM).
5. **SEM.R** was used to perform multiple mediation analysis based on structural equation models (SEM) in R.

Expected outputs include statistical graphs and tables. However, since the demo data is entirely simulated and the sample size is relatively small (only 300), some results may appear unusual or may not fit well (such as SEM).

## Expected run time for demo on a "normal" desktop computer

If you run the programs using demo data, it takes only a few seconds. However, in our actual analysis for the paper, which involved a sample size in the millions and included more variables, some statistical models (such as HGLM) took tens of minutes to complete.
