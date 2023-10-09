*-----------------------------------------*
/*Problem 1 - Read in Data from DATALINES*/
*-----------------------------------------*

*Part 1*
DATA course;
    INFILE DATALINES;
    INPUT Course_name $ Course_number $ days $ Credits;
    DATALINES;
DSCI 200 . 3
DSCI 307 TT 3
MATH 371 MW .
MATH 372 MW 3
;
RUN;

PROC PRINT DATA=course;
    TITLE 'Reading in Data from DATALINES - Space Delimiter';
RUN;

*Part 2*
DATA course;
   INFILE DATALINES ;
   INPUT Course_name $ 1-5 Course_number $ 6-8  Days $ 10-11 Credits 13-14;
   DATALINES;
DSCI 200    3
DSCI 307 TT 3
MATH 371 MW  
MATH 372 MW 3
;
RUN;

PROC PRINT DATA=course;
	TITLE 'Reading in Data from DATALINES - Column Input'
RUN;

*-----------------------------------------*
/*Problem 2 - Read in Date from DATALINES*/
*-----------------------------------------*

*Part 1*
DATA schedule;
   INFILE DATALINES ;
   INPUT @1 Course $9.
         @10 Days  $3.
         @13 BeginDate mmddyy10.
         @23 EndDate mmddyy10.; 
        
   DATALINES;
DSCI 200    8/26/2019 10/29/2019
DSCI 307 TT 8/26/2019 12/12/2019
MATH 371 MW 8/26/2019 12/11/2019
Math 372 MW 8/26/2019 
;
RUN;

PROC PRINT DATA=schedule;
    TITLE 'Reading in Data using Pointers/Informats';
    FORMAT BeginDate mmddyy10. EndDate mmddyy10.;
RUN;

*Part 2*
DATA schedule;
   INFILE DATALINES ;
   INPUT Course : & $9.
         Days : $3.
         BeginDate : mmddyy10.
         EndDate : mmddyy10.; 
        
   DATALINES;
DSCI 200    .   8/26/2019   10/29/2019
DSCI 307   TT   8/26/2019   12/12/2019
MATH 371   MW   8/26/2019   12/11/2019
Math 372   MW   8/26/2019    .
;
RUN;

PROC PRINT DATA=schedule;
    TITLE 'Reading in Data using Modifiers';
    FORMAT BeginDate mmddyy10. EndDate mmddyy10.;
RUN;

*Part 3*
DATA schedule;
	INFILE DATALINES;
	INFORMAT Course $9. Days $3. BeginDate mmddyy10. EndDate mmddyy10.;
	INPUT Course & $ Days $ BeginDate EndDate ;
	DATALINES;
DSCI 200    .   8/26/2019   10/29/2019
DSCI 307   TT   8/26/2019   12/12/2019
MATH 371   MW   8/26/2019   12/11/2019
Math 372   MW   8/26/2019    .
;
RUN;

PROC PRINT DATA=schedule;
    TITLE 'Reading in Data using Modifiers';
    FORMAT BeginDate mmddyy10. EndDate mmddyy10.;
RUN;

*----------------------------------------------*
/*Problem 3 - Read in Data from Externam Files*/
*----------------------------------------------*
*Part 1*
DATA semester;
   INFILE '/home/u63559709/sasuser.v94/Week 1/class_schedule.csv' DSD FIRSTOBS = 2;
   INPUT CourseName $ CourseNumber $ Days $ BeginDate EndDate Credits Tuition : dollar4.;
   INFORMAT BeginDate mmddyy10. EndDate mmddyy10.;
RUN;

PROC PRINT DATA=semester;
    TITLE 'Reading in Data from a CSV File using DATA step';
    FORMAT BeginDate mmddyy10. EndDate mmddyy10. Tuition dollar8.;
RUN;

*Part 2*
PROC IMPORT  
DATAFILE='/home/u63559709/sasuser.v94/Week 1/class_schedule.xlsx' 
    OUT = semester  DBMS = xlsx
    REPLACE ;
    GETNAMES = yes;
RUN;

PROC PRINT DATA=semester;
    TITLE 'Reading in Data from excel';
RUN;