***************************************************************
*Example-PROC CORR;
**************************************************************;
*Read data;
PROC IMPORT out=auto DATAFILE='/folders/myfolders/Week8/auto.xlsx'
            DBMS=xlsx REPLACE;
            SHEET='auto';
            GETNAMES=YES;
RUN;
PROC PRINT data=auto (OBS=5);
    TITLE 'Auto data (first five observations)'; 
RUN;

*Part I;
PROC CORR DATA = auto  PLOTS = scatter;
    VAR weight acceleration;
    WITH mpg;
    TITLE 'Correlations of Weight and Acceleration with mpg';
RUN;

*Part II;
PROC CORR DATA = auto  PLOTS = matrix;
    WITH mpg;
    TITLE 'Correlations with mpg';
RUN;
***************************************************************
*Example- Simple Linear Regression Model of Auto Data;
**************************************************************;
ods graphics off;
PROC REG DATA=auto;
    MODEL mpg=weight;
    title 'Simple Linear Regression';
RUN;




***************************************************************
*Example- Multiple Linear Regression Model of Auto Data;
**************************************************************;
*Part I Multiple Linear Regression Model 1; 
ods graphics off;
PROC REG DATA=auto;
    MODEL mpg=cylinders displacement horsepower weight;
    title 'Multiple Linear Regression Model 1';
RUN;



*Part II Multiple Linear Regression Model 2; 
ods graphics off;
PROC REG DATA=auto;
    MODEL mpg=weight horsepower displacement cylinders acceleration model;
    title 'Multiple Linear Regression Model 2';
RUN;

*Part III Multiple Linear Regression Model 3; 
ods graphics off;
PROC REG DATA=auto;
    MODEL mpg=weight model;
    title 'Multiple Linear Regression Model 3';
RUN;


***************************************************************
*Example-Prediction;
**************************************************************;
ods graphics off;
PROC REG DATA=auto outtest=regout noprint;
    MODEL mpg= weight model;
RUN;

DATA newobservation;
   INPUT weight model;
   datalines;
3000 90
4000 99
3500 95
;
RUN;

PROC SCORE DATA=newobservation SCORE=regout OUT=NewPred type=parms nostd predict;
   VAR weight model;
RUN;
PROC PRINT data=NewPred;
   title1 'Predicted MPG for Three Cars';
RUN;

***************************************************************
*Example- PROC LOGISTIC;
***************************************************************;
*Read and display data;
DATA admission;
   INFILE '/folders/myfolders/Week8/binary.csv' DSD FIRSTOBS = 2;
   INPUT admit gre gpa rank ;
RUN;
PROC PRINT data=admission (OBS=5);
RUN;

*Logistic regression model;
title 'Logistic Regression Model';
Proc Logistic Data = admission descending;
    class rank / param=ref ;
    Model admit = gre gpa rank;    
RUN;

***************************************************************
*Example-Prediction Using a Logistic Regression Model;
***************************************************************;
DATA newobservation;
   INPUT gre gpa rank;
   datalines;
700 3.4 2
780 3.3 3
750 3.8 1
680 3.6 4
;
RUN;

*Prediction;
Proc Logistic Data = admission descending noprint;
    class rank / param=ref ;
    Model admit = gre gpa rank; 
    Score clm data=newobservation out=pred;
RUN;
proc print data = pred;
run;