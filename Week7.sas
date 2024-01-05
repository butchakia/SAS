************************************************************************
* Display the first five observations of the shoes dataset;
************************************************************************;
proc print data=sashelp.shoes(obs=5) noobs;
run;

************************************************************************
* Example-Using PROC UNIVARIATE to Analyze One Variable;
************************************************************************;
proc univariate data = sashelp.shoes;
    var sales;
run;
************************************************************************
*Example-Using ODS SELECT to Generateg Specified Outputs;
************************************************************************;
ods select Moments TestsForLocation;
proc univariate data = sashelp.shoes;
    var sales;
run;

************************************************************************
*Example- Analyzing One Variable with Class Statement;
************************************************************************;
ods select BasicMeasures;
proc univariate data = sashelp.shoes;
    var sales;
    class region;
run;

************************************************************************
*Example- Using ODS OUTPUT to Write Outputs in SAS Dataset;
************************************************************************;
title '';
ods output Quantiles = temp;
proc univariate data = sashelp.shoes;
    var sales;
run;
ods output close;

proc print data=temp;
run;
proc export data=temp
    dbms=xlsx 
     outfile='/folders/myfolders/Week7/shoes_quantiles.xlsx' 
     replace;
run;

************************************************************************
*Example-Using PROC UNIVARIATE to Check Normality;
************************************************************************;
*Part 1-Histogram;

proc univariate data=sashelp.shoes NOPRINT;
    var sales;
    HISTOGRAM / NORMAL (COLOR=BLUE);
run;

/* Note: Histogram shows visually whether data is normally distributed.
Note that the histogram of the data sample is not a symmetric bell-shaped curve,
so the data sample is not from a normal distibution*/

*Part 2-Skewness;

ods select Moments;
proc univariate data = sashelp.shoes;
    var sales;
run;

/*Note: Since Skewness is greater than 1, it means that data is highly skewed and non-normal*/

*Part 3-Normality Tests;

ods select TestsforNormality;
proc univariate data = sashelp.shoes normal;
    var sales;
run;

/* Note: Since all the four p-values < 0.05, the variable sales is not normal. */

************************************************************************
*Example-Using PROC UNIVARIATE to Generate Plots;
************************************************************************;
ODS SELECT PLOTS;
proc univariate data=sashelp.shoes PLOT;
    var sales;
run;

/* Note: The histogram, Box-plot, Q-Q plot all show that the variable sales is not normal.*/

************************************************************************
*Example- Using PROC UNIVARIATE to Test Location;
************************************************************************;
*part II- use the default null hypothesis mu=0;
ods select TestsForLocation;
proc univariate data=sashelp.shoes mu0=90000;
    var sales;
run;

************************************************************************
*Example- T-test for One sample;
************************************************************************;
* Read data;
data time;
    input time @@;
    datalines;
43 90 84 87 116 95 86 99 93 92
121 71 66 98 79 102 60 112 105 98
;
* Test H0= 80 against Ha>80 with ALPHA=0.1;
proc ttest h0=80 sides=u alpha=0.1;
    var time;
run;

************************************************************************
*Example-T-test for Two Independent Samples;
************************************************************************;
*Read data;
data scores;
    input Gender $ Score @@;
    datalines;
f 75 f 76 f 80 f 77 f 80 f 77 f 73
m 82 m 80 m 85 m 85 m 78 m 87 m 82
;

*Test H0= 0 against Ha not 0 with default ALPHA=0.05;
proc ttest;
    class Gender;
    var Score;
run;
************************************************************************
*Example- T-test for Two Paired Samples;
************************************************************************;
*Read data;
data pressure;
    input SBPbefore SBPafter @@;
    datalines;
120 128 124 131 130 131 118 127
140 132 128 125 140 141 135 137
126 118 130 132 126 129 127 135
;
*Test H0= 0 against Ha not 0 with default ALPHA=0.05;
proc ttest;
    paired SBPbefore*SBPafter;
run;

************************************************************************
*Example- Using PROC FREQ to Take Chi-square Test for a Two-way Count Data; 
************************************************************************;
*Read data ;
DATA bus;
    INFILE '/folders/myfolders/Week7/Bus.dat';
    INPUT BusType $ OnTimeOrLate $ @@;
RUN;
PROC PRINT DATA=bus (OBS=5);
    title 'first five observation of bus'
RUN;

*Chi-square tests of homogeneity;
PROC FREQ DATA = bus;
TABLES BusType * OnTimeOrLate /CHISQ;
    TITLE 'CHI-SQUARE ANALYSIS FOR A 2X2 TABLE';
RUN;

************************************************************************;
*Example- Using PROC FREQ to Take Chi-square Test for a Aggregated Two-way Count Data ;
************************************************************************;
*Read data;
DATA Goal_Grade;
    INPUT Goal $ Grade $ Count;
    DATALINES;
Grades fourth 49
Grades fifth 50
Grades sixth 69
Popular fourth 24
Popular fifth 36
Popular sixth 38
Sports fourth 19
Sports fifth 22
Sports sixth 28
;
RUN; 

*Chi-square tests of homogeneity ;
PROC FREQ DATA=Goal_Grade;
    TABLE Goal * Grade/ CHISQ  EXPECT NOCOL NOROW NOPERCENT;
    WEIGHT Count;
RUN;

