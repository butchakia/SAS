*******************************************************************
*Example Use Keyword LIBNAME to Create a Permanent SAS Dataset*****
*******************************************************************;
LIBNAME  Practice '/folders/myfolders/Week2';
*the directory '/folders/myfolders/Week2' is assigned a library reference name of Practice; 

DATA Practice.score; 
*Tells SAS to create a dataset called score in the directory referenced by Practice
 which is '/folders/myfolders/Week2';

*below is to read the data from Week1 folder and assign the data to score;
INFILE '/folders/myfolders/Week1/test_score.csv' DSD FIRSTOBS = 2;
   INPUT first_name $ last_name $ age pre_score post_score;
RUN;

*a permanent file called score.sas7bdat is created in the folder '/folders/myfolders/Week2' ;

PROC PRINT DATA = Practice.score;
TITLE 'Save Permanent DataSet';
RUN;

*******************************************************************
*Example Use set keyword to read a permanent dataset from a library;
*******************************************************************;
LIBNAME  Practice '/folders/myfolders/Week2';
DATA score_new; 
    SET Practice.score; *read permanent data set score;
    difference = post_score-pre_score; *create a new variable;
    WHERE post_score >50; *score_new only picks the rows with post_score >50;
RUN;

PROC PRINT DATA = score_new;
TITLE 'Read Permanent Dataset';
RUN;

*Note that score_new is a temperary data set because we do not have first level library name;

*******************************************************************
***********    Example of PROC EXPORT  ***************************
******************************************************************;
* Example- Use PROC EXPORT to Save a SAS dataset into a CSV file
Save a SAS dataset into a CSV file;

PROC EXPORT DATA = score_new  
OUTFILE ='/folders/myfolders/Week2/ExampleCSV.csv' 
    dbms=csv
    replace;
RUN;

*******************************************************************
***************  Example of PROC SORT *****************************
*******************************************************************;
DATA account;
   input Company $ 1-22 Debt 25-30 AccountNumber 33-36
         Town $ 39-51;
   datalines;
Paul's Pizza             83.00  1019  Apex
World Wide Electronics  119.95  1122  Garner
Strickland Industries   657.22  1675  Morrisville
Ice Cream Delight       299.98  2310  Holly Springs
Watson Tabor Travel      37.95  3131  Apex
Boyd & Sons Accounting  312.49  4762  Garner
Bob's Beds              119.95  4998  Morrisville
Tina's Pet Shop          37.95  5108  Apex
Elway Piano and Organ    65.79  5217  Garner
;

PROC SORT data=account out=bytown;
   by town descending company;
RUN;

PROC PRINT data=bytown;
   VAR town company debt accountnumber;
   TITLE  'Customers with Past-Due Accounts';
run;

*******************************************************************
*********  Example of PROC PRINT **********************************
*******************************************************************;
* Example of PROC PRINT using more optional statements
*displays from the 3rd observation to the 8th observation;
PROC PRINT data=account (FIRSTOBS=3 OBS=8);
    VAR accountNumber Debt;
    FORMAT Debt dollar8.2;
    TITLE 'PROC PRINT using more optional statements';
RUN;

*******************************************************************
***************** Example of PROC CONTENTS  ***********************
*******************************************************************;
PROC IMPORT  
DATAFILE='/folders/myfolders/Week1/test_score.xlsx' 
    OUT = score  DBMS = xlsx
    REPLACE ;
    GETNAMES = yes;
RUN;

*Use PROC CONTENTS to get the summary of the data;
PROC CONTENTS data=score;
    TITLE 'DATA CONTENTS';
RUN;

*******************************************************************
************ Examples of PROC MEANS  ******************************
*******************************************************************;
*Read in Data from a data file;
DATA weight;
 
 INFILE '/folders/myfolders/Week2/patient.dat';
 INPUT @1 ptid $10. 
     @12 clinic $1. 
     @30 sex $1. 
     @58 height 4.1 
     @85 weight 5.1; 
 * Create new variables here;
 bmi = (weight*703.0768)/(height*height);
 * BMI is calculated in kg/m2;
RUN;

*Print first three observations to check the data briefly;
PROC PRINT data=weight (obs=3);
    TITLE '';
RUN;
*******************************************************************;
*Example 1: Simplest PROCE MEAN;
PROC MEANS DATA = weight;
     VAR  height weight bmi;
     TITLE 'Proc Means- Example 1 (using default output)';
RUN;
*******************************************************************;
*Example 2- Use MAXDEC option in PROC MEANS; 
PROC MEANS DATA = weight MEAN MEDIAN STD MAXDEC=2;
     VAR  height bmi;
     TITLE 'Proc Means Example- 2 (using specifying options)';
RUN;

*******************************************************************;
*Example 3- Use CLASS statement in PROC MEANS;
PROC MEANS DATA = weight N MEAN STD MAXDEC=2 ;
     CLASS clinic;
     VAR  height weight bmi;
     TITLE 'Proc Means- Example 3 (using a CLASS statement)';
RUN;

*******************************************************************
*Example 4- Using BY statment in PROC MEANS ***********************;
PROC SORT DATA = weight; 
    BY clinic;
RUN;

PROC MEANS DATA = weight N MEAN STD MAXDEC=2 ;
     VAR  height weight bmi;
     BY clinic;
     TITLE 'Proc Means Example 4 (using BY statement)';
RUN;
*******************************************************************
*Example 5- Using OUTPUT statement in PROC MEANS*******************;
PROC MEANS DATA = weight NOPRINT;
     VAR  height weight;
     BY clinic;
     OUTPUT OUT = Average MEAN(weight height) = Mean_Weight Mean_Height
     STD(weight height) = STD_Weight STD_Height;
     TITLE 'Proc Means Example 5 (using OUTPUT statement)';
RUN;

*use print proc to display the new data set Average;
PROC PRINT DATA=Average;
    TITLE 'Proc Means Example 5 (using OUTPUT statement)';
RUN;
*******************************************************************
************** Examples of PROC FREQ  *****************************
*******************************************************************;
*Example 1- One-way frequency table;
PROC FREQ DATA=weight;
    TABLES clinic sex ;
    TITLE 'One-way Frequency Table';
RUN;
*******************************************************************
*Example 2- Two-way frequency table ********************************;
PROC FREQ DATA=weight;
     TABLES sex*clinic ;
     TITLE 'Two-way Frequency Table of Sex by Clinical Center';
RUN;
*******************************************************************
*Example 3- Add NOPERCENT NOROW and NOCOL options to the TABLES statement;
PROC FREQ DATA=weight noprint;
     TABLES sex*clinic /nopercent norow nocol out=Counts_Sex_Clininal;
     TITLE 'Two-way Frequency Table of Sex by Clinical Center';
     TITLE2 'Only Counts-NOPERCENT NOROW and NOCOL';
RUN;
*Use print proc to check the dataset Counts_Sex_Clininal;
PROC PRINT data=Counts_Sex_Clininal;
RUN;

******************************************************************
************ Examples of PROC TABULATE  ***************************
*******************************************************************;
* Read data from a data file; 
DATA boats; 
    INFILE '/folders/myfolders/Week2/Boats.dat' ;
    INPUT Name $ 1-12 Port $ 14-20 Locomotion $ 22-26 Type $ 28-30 Price 32-37 Length 39-41;
RUN;

PROC PRINT DATA = boats;
    title 'boats';
RUN;

******************************************************************
*Exasmpe 1- Creating a simple two-dimension table in PROC TABULATE;
PROC TABULATE DATA = boats;
    CLASS Port Locomotion Type;
    TABLE Locomotion, Type;
    TITLE 'Number of Boats by Locomotion and Type';
RUN;
******************************************************************
* Example 2- Creating a simple three-dimension table in PROC TABULATE;
PROC TABULATE DATA = boats;
    CLASS Port Locomotion Type;
    TABLE Port, Locomotion, Type;
    TITLE 'Number of Boats by Port, Locomotion, and Type';
RUN;
******************************************************************
* Example 3- Adding Statistics to PROC TABULATE Output************;
PROC TABULATE DATA = boats;
    CLASS Locomotion Type;
    VAR Price Length;
    TABLE Locomotion ALL, Mean*(Price*FORMAT=dollar8.2 Length*FORMAT=4.0)*(Type ALL);
    TITLE 'Means of Price and Length by Locomotion and Type';
RUN;
******************************************************************
************ Examples of PROC REPORT  ****************************
*******************************************************************;
* Read data from a data file;
DATA natparks;
    INFILE '/folders/myfolders/Week2/Parks.dat';
    INPUT Name $ 1-21 Type $ Region $ Museums Camping;
RUN;

PROC PRINT DATA = natparks;
    title 'parks';
RUN;
******************************************************************
*******************************************************************;
*Example 1- Use Column Statement in PROC REPORT;
PROC REPORT DATA = natparks NOWINDOWS;
    COLUMN Museums Camping;
    TITLE 'Using COLUMN Statement in PROC REPORT';
RUN;
******************************************************************
*******************************************************************;
* Example 2- Using DEFINE Statements in PROC REPORT;
PROC REPORT DATA = natparks NOWINDOWS MISSING;
    COLUMN Region Type Museums Camping;
    DEFINE Region / GROUP;
    DEFINE Type / GROUP;
    TITLE 'Using DEFINE Statements in PROC REPORT';
RUN;
******************************************************************
*******************************************************************;
*Example 3- Adding Statistics to PROC REPORT Output;
PROC REPORT DATA = natparks NOWINDOWS;
    COLUMN Region Type, (Museums Camping),(SUM MEAN);
    DEFINE Region / GROUP;
    DEFINE Type / ACROSS;
    DEFINE Museums / DISPLAY format=2.;
    DEFINE Camping / DISPLAY format=2.;
    TITLE 'Adding Statistics to PROC REPORT Output';
RUN;
******************************************************************
*******************************************************************;
PROC TABULATE DATA =natparks FORMAT=Comma2.0;
    CLASS Region Type;
    VAR Museums Camping;
    TABLE Region, Type ALL *(Museums Camping)*(SUM MEAN) ;
    TITLE ;
RUN;    

******************************************************************
*******************************************************************;