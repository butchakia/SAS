/*PROBLEM 1*/;
*Import school 1 midterm data*;
DATA s1m;
    INFILE '/home/u63559709/sasuser.v94/Week 3/school 1 midterm.csv' DSD firstobs=2;
    INPUT ClassID ChildID Gender $ ClassAge $ Language $ m1 m2 m3 m4;
RUN;

*Import school 2 midterm data*;
DATA s2m;
    INFILE '/home/u63559709/sasuser.v94/Week 3/school 2 midterm.csv' DSD firstobs=2;
    INPUT ClassID ChildID Gender $ ClassAge $ m1 m2 m3 m4;
RUN;

*Import school 1 final data*;
DATA s1f;
    INFILE '/home/u63559709/sasuser.v94/Week 3/school 1 final.csv' DSD firstobs=2;
    INPUT ClassID ChildID Gender $ ClassAge $ Language $ f1 f2 f3 f4;
RUN;

*Import school 2 final data*;
DATA s2f;
    INFILE '/home/u63559709/sasuser.v94/Week 3/school 2 final.csv' DSD firstobs=2;
    INPUT ClassID ChildID Gender $ ClassAge $ f1 f2 f3 f4;
RUN;

/*PROBLEM 2*/;
*Sort some of the data to run properly*;
PROC SORT DATA=s1m; 
    BY ChildID; 
RUN;

PROC SORT DATA=s2m; 
    BY ChildID; 
RUN;

*Interleave s1m and s2m by ChildID*;
DATA midterm;
    SET s1m s2m;
    BY ChildID;
    DROP Language;
RUN;

*Print the dataset*;
PROC PRINT DATA=midterm;
	TITLE "Interleaved Table M";
RUN;

/*PROBLEM 3*/;
*Sort some of the data to run properly*;
PROC SORT DATA=s1f; 
    BY ChildID; 
RUN;

PROC SORT DATA=s2f; 
    BY ChildID; 
RUN;

*Interleave s1f and s2f by ChildID*;
DATA final;
	SET s1f s2f;
	BY ChildID;
RUN;

*Print the dataset*;
PROC PRINT DATA=final;
	TITLE "Interleaved Table F";
RUN;

/*PROBLEM 4*/;
*Merge the data sets midterm and final by ChildID. Name the new data set as assess and print it.*;
DATA assess;
    MERGE midterm (IN=a) final (IN=b);
    BY ChildID;
    IF a AND b;
RUN;

*Print the merged dataset*;
PROC PRINT DATA=assess;
	TITLE "Merged Table #4";
RUN;

/*PROBLEM 5*/
*Find the mean of each numerical variables in the data set assess*;
PROC MEANS DATA=assess MEAN;
    VAR m1 m2 m3 m4 f1 f2 f3 f4;
RUN;

/*PROBLEM 6*/
*Update the data sets midterm with the data set final by ChildID. Print the updated data set*;
DATA updated_midterm;
    MERGE midterm (IN=a) final (IN=b);
    BY ChildID;
    IF a;
RUN;

*Print the updated dataset*;
PROC PRINT DATA=updated_midterm;
	TITLE "Merged Table #6";
RUN;

/*PROBLEM 7*/
*Use OUTPUT statement and IF statement to regroup the data set assess 
into 4 data sets PREK4, PREK3, Female, and Male. Print the 4 data sets*;
DATA PREK4 PREK3 Female Male;
    SET assess;
    IF ClassAge = 'Pre-K 4' THEN OUTPUT PREK4;
    IF ClassAge = 'Pre-K 3' THEN OUTPUT PREK3;
    IF Gender = 'Female' THEN OUTPUT Female;
    IF Gender = 'Male' THEN OUTPUT Male;
RUN;

*Print the datasets*;
PROC PRINT DATA=PREK4; TITLE "PREK4 Dataset"; RUN;
PROC PRINT DATA=PREK3; TITLE "PREK3 Dataset"; RUN;
PROC PRINT DATA=Female; TITLE "Female Dataset"; RUN;
PROC PRINT DATA=Male; TITLE "Male Dataset"; RUN;

/*PROBLEM 8*/
*Use KEEP or DROP data step statements to select the two variables m2 and f2 from the data set assess. 
Name the selected data set as select_m2_f2. Print the first five observations.*;
DATA select_m2_f2;
    SET assess;
    KEEP m2 f2;
RUN;

*Print the first five observations*;
PROC PRINT DATA=select_m2_f2 (OBS=5);
	TITLE "First 5 _m2_f2";
RUN;

/*PROBLEM 9*/
*Use KEEP or DROP data set options to select the two variables m3 and f3 from the data set assess. 
Name the selected data set as select_m3_f3. Print the observations from 
the 50th row to the 100th row.*;
DATA select_m3_f3;
    SET assess (KEEP=m3 f3);
RUN;

*Print observations from the 50th row to the 100th row*;
PROC PRINT DATA=select_m3_f3 (FIRSTOBS=50 OBS=100);
	TITLE "Table _m3_f3";
RUN;

/*Problem 10*/
*Add new variables and filter observations*;
DATA improvement;
    SET assess;
    d1 = f1 - m1;
    d2 = f2 - m2;
    IF d1 > 0 AND d2 > 0;
RUN;

*Print the dataset*
PROC PRINT DATA=improvement;
	TITLE "Improvement";
RUN;


/*PROBLEM 11*/
*Merge midterm and final by ChildID with IN options to get the common part.*;
DATA both;
    MERGE midterm (IN=a) final (IN=b);
    BY ChildID;
    IF a AND b;
RUN;

*Print the merged dataset*;
PROC PRINT DATA=both;
	TITLE "Merged In";
RUN;

/*PROBLEM 12*/
*Merge midterm and final by ChildID with IN options to get the data that are in midterm but not in final.*;
DATA right_merge;
    MERGE midterm (IN=a) final (IN=b);
    BY ChildID;
    IF a AND NOT b;
RUN;

*Print the merged dataset*;
PROC PRINT DATA=right_merge;
	TITLE "Right Merge";
RUN;

/*PROBLEM 13*/
*Merge midterm and final by ChildID with IN options to get the data that 
are in final but not in midterm. Name the merged data set as left_merge and print it.*;
DATA left_merge;
    MERGE midterm (IN=a) final (IN=b);
    BY ChildID;
    IF b AND NOT a;
RUN;

*Print the merged dataset*;
PROC PRINT DATA=left_merge;
	TITLE "Left Merge";
RUN;