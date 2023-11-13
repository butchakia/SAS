************************************************************************
Example-Selecting Columns(Variables) Using DROP or KEEP Data Statement
************************************************************************;
LIBNAME Week3 '/folders/myfolders/Week3';

*Part 1;
DATA payroll_1;
    SET Week3.payroll; 
    DROP IdNumber Salary;
*Drop IdNumber and Salary, read all other columns and pass them to the data set payroll_1;
RUN;

PROC PRINT DATA =payroll_1 (OBS=5);
    FORMAT  DateBirth date7. DateHired date7.;
    TITLE 'Selecting Columns(Variables) Using DROP statement';
RUN;

*Part 2;
DATA payroll_2;
    SET Week3.payroll; 
    KEEP Gender Salary DateHired;
*SAS only reads the three columns and pass them to the data set payroll_2;
RUN;

PROC PRINT DATA =payroll_2 (OBS=5);
    *FORMAT DateHired date7.;
    TITLE 'Selecting Columns(Variables) Using Keep Statement';
RUN;

************************************************************************
Example-Selecting Columns(Variables) Using DROP or KEEP Data Set Option
************************************************************************;
*part 1;
DATA payroll_3;
    SET Week3.payroll (KEEP= IdNumber Salary);
*SAS only read the two columns and pass them to the data set payroll_3
RUN;

*another way to get the same payroll_3;
DATA payroll_3 (KEEP= IdNumber Salary);
    SET Week3.payroll;
*SAS read all the columns and pass only IdNumber and Salary to the data set payroll_3;
RUN;

PROC PRINT DATA =payroll_3 (OBS=5);
    *FORMAT DateHired date7.;
    TITLE 'Selecting Columns(Variables) Using Keep Data Set Options';
RUN;

*part 2;
DATA payroll_4;
    SET Week3.payroll (DROP= IdNumber Salary);
*Drop IdNumber and Salary, read all other columns and pass them to the data set payroll_1;
RUN;

*another way to get the same payroll_3;
DATA payroll_4 (DROP= IdNumber Salary);
    SET Week3.payroll;
*SAS read all the columns,drop IdNumber and Salary, pass all other columns to the data set payroll_4;
RUN;

PROC PRINT DATA =payroll_4 (OBS=5);
    *FORMAT DateHired date7.;
    TITLE 'Selecting Columns(Variables) Using DROP Data Set Options';
RUN;

************************************************************************
Example-Seleting Rows(Observations) Using WHERE Statement
************************************************************************;
LIBNAME Week3 '/folders/myfolders/Week3';
*Part 1;
DATA payroll_5;
    SET Week3.payroll; 
    WHERE Gender='F'; 
* Note that we cannot use WHERE if Gender='F;
    KEEP Gender Salary DateHired;
RUN;

PROC PRINT DATA =payroll_5 (FIRSTOBS=58);
    FORMAT  DateHired date7.;
    TITLE 'Selecting Rows(Observations) Using WHERE Statement';
RUN;

************************************************************************
Example-Seleting Rows(Observations) Using WHERE Data Set Option
************************************************************************;
LIBNAME Week3 '/folders/myfolders/Week3';
DATA payroll_7;
    SET Week3.payroll (WHERE=(DateHired >'05APR93'd and Gender='F')); 
    KEEP Gender Salary DateHired;
RUN;
*the othe way to get the same payroll_7;
DATA payroll_7 (WHERE=(DateHired >'05APR93'd and Gender='F'));
    SET Week3.payroll ; 
    KEEP Gender Salary DateHired;
RUN;
PROC PRINT DATA =payroll_7;
    FORMAT  DateHired date7.;
    TITLE 'Selecting Rows(Observations) Using WHERE Data Set Option';
RUN;

************************************************************************
Example-Selecting Rows(Observations) Using FIRSTOBS and OBS Data Set Options
************************************************************************;
LIBNAME Week3 '/folders/myfolders/Week3';
DATA payroll_8;
    SET Week3.payroll (FIRSTOBS=120 OBS=127); 
    KEEP Gender Salary DateHired;
RUN;

*Note that this way does not work;
*DATA payroll_7(FIRSTOBS=120 OBS=127);
*FIRSTOBS and OBS cannot be used in Data statement;

PROC PRINT DATA =payroll_8;
    FORMAT  DateHired date8.;
    TITLE 'Selecting Rows(Observations) Using FIRSTOBS and OBS Data Set Option';
RUN;

************************************************************************
Example-Selecting Rows(Observations) Using Output Statement
************************************************************************;
LIBNAME Week3 '/folders/myfolders/Week3';
*Part 1;
DATA Female_Employee Male_Employee;
    SET Week3.payroll (DROP=JobCode); 
    IF Gender='F' THEN OUTPUT Female_Employee;
    ELSE OUTPUT Male_Employee;
RUN;

PROC PRINT DATA =Female_Employee (OBS=5);
    FORMAT  DateBirth date8. DateHired date8.;
    TITLE 'Selecting Female Employees Using OUTPUT Statement';
RUN;
PROC PRINT DATA =Male_Employee (OBS=5);
    FORMAT  DateBirth date8. DateHired date8.;
    TITLE 'Selecting Male Employese Using OUTPUT Statement';
RUN;

*Part 2;
DATA Female_Employee(Keep=Gender Salary) Male_Employee(DROP=JobCode);
    SET Week3.payroll ; 
    IF Gender='F' THEN OUTPUT Female_Employee;
    ELSE OUTPUT Male_Employee;
RUN;

PROC PRINT DATA =Female_Employee (OBS=5);
    TITLE 'Selecting Female Employees Using OUTPUT Statement';
RUN;
PROC PRINT DATA =Male_Employee (OBS=5);
    FORMAT  DateBirth date8. DateHired date8.;
    TITLE 'Selecting Male Employese Using OUTPUT Statement';
RUN;

*Part 3;
DATA Low_Salary Medium_Salary High_Salary;
    SET Week3.payroll; 
    IF Salary<50000 THEN OUTPUT Low_Salary;
    ELSE IF (Salary>=50000 and Salary<90000) THEN OUTPUT Medium_Salary;
    ELSE  OUTPUT High_Salary;
RUN;

PROC PRINT DATA =Low_Salary (OBS=5);
    TITLE 'Selecting Low Salary Employees Using OUTPUT Statement';
RUN;
PROC PRINT DATA =Medium_Salary (OBS=5);
    TITLE 'Selecting Medium Salary Employese Using OUTPUT Statement';
RUN;
PROC PRINT DATA =High_Salary (OBS=5);
    TITLE 'Selecting High Salary Employese Using OUTPUT Statement';
RUN;

************************************************************************
Example-Stacking Data Sets Using the SET Statement
************************************************************************;
*Part 1;
DATA southentrance;
    INFILE '/folders/myfolders/Week3/South.dat';
    INPUT Entrance $ PassNumber PartySize Age;
RUN;
PROC PRINT DATA = southentrance;
TITLE 'South Entrance Data';
RUN;

DATA northentrance;
    INFILE '/folders/myfolders/Week3/North.dat';
    INPUT Entrance $ PassNumber PartySize Age Lot;
RUN;
PROC PRINT DATA = northentrance;
    TITLE 'North Entrance Data';
RUN;

*Part 2;
* Create a data set, both, combining northentrance and southentrance;
* Create a variable, AmountPaid, based on value of variable Age;
DATA both;
    SET southentrance northentrance;
    IF Age = . THEN AmountPaid = .;
        ELSE IF Age < 3 THEN AmountPaid = 0;
        ELSE IF Age < 65 THEN AmountPaid = 35;
        ELSE AmountPaid = 27;
RUN;
PROC PRINT DATA = both;
    TITLE 'Stacking Data Sets Using the SET Statement';
RUN;

************************************************************************
Example-Interleaving Data Sets Using the SET Statement
************************************************************************;
* Remember to sort each data set first;
PROC SORT DATA = southentrance;
    BY PassNumber;
RUN;
PROC SORT DATA = northentrance;
    BY PassNumber;
RUN;

DATA interleave;
    SET northentrance southentrance;
    BY PassNumber;
RUN;

PROC PRINT DATA = interleave;
    TITLE 'Interleaving Data Sets Using the SET Statements';
RUN;

************************************************************************
Example-Combining Data Sets Using MERGE Statement(One-to-One Match Merge)
************************************************************************;
* We first created the dads and faminc data files below ; 

DATA dads; 
  INPUT famid Dadname $ faminc96; 
datalines; 
2 Art  52000 
1 Bill 60000 
3 Paul 85000 
4 Peter 80000
; 
RUN; 

DATA faminc; 
  INPUT famid faminc96 faminc97 faminc98 ; 
datalines; 
3 75000 76000 77000 
1 40000 40500 41000 
5 55000 65000 70000
6 32000 44000 48000 
;
RUN;

PROC SORT DATA=dads;
    BY famid; 
RUN; 
PROC SORT DATA=faminc; 
    BY famid; 
RUN; 
 
DATA dadfam ; 
  MERGE dads faminc; 
  BY famid; 
RUN; 

PROC PRINT DATA=dadfam; 
    TITLE 'One-to-One Match Merge';
RUN; 

************************************************************************
Example-Combining Data Sets Using MERGE Statement(One-to-Many Match Merge)
************************************************************************;
DATA dads; 
  INPUT famid Dadname $ faminc96; 
datalines; 
2 Art  52000 
1 Bill 60000 
3 Paul 75000 
4 Peter 80000
; 
RUN; 

DATA kids; 
  INPUT famid kidname $ birth age wt sex $ ; 
datalines;; 
1 Beth 1 9 60 f 
1 Bob  2 6 40 m 
1 Barb 3 3 20 f 
2 Andy 1 8 80 m 
2 Al   2 6 50 m 
2 Ann  3 2 20 f 
3 Pete 1 6 60 m 
3 Pam  2 4 40 f 
3 Phil 3 2 20 m
5 Tom  1 3 25 m
6 Lori 1 8 75 f
; 
RUN; 

PROC SORT DATA=dads;
    BY famid; 
RUN; 
PROC SORT DATA=kids; 
    BY famid; 
RUN; 
 
DATA dadkids; 
  MERGE dads kids; 
  BY famid; 
RUN; 

PROC PRINT DATA=dadkids; 
    TITLE 'One-to-Many Match Merge';
RUN; 

************************************************************************
Example-Combining Data Sets Using MERGE Statement with IN= Option
************************************************************************;
*Part 1: Review Basic one-to-one merge;
DATA dads; 
  INPUT famid Dadname $ faminc96; 
datalines; 
2 Art  52000 
1 Bill 60000 
3 Paul 85000 
4 Peter 80000
; 
DATA faminc; 
  INPUT famid faminc96 faminc97 faminc98 ; 
datalines; 
3 75000 76000 77000 
1 40000 40500 41000 
5 55000 65000 70000
6 32000 44000 48000 
;
PROC SORT DATA=dads; BY famid; RUN; 
PROC SORT DATA=faminc; BY famid; RUN; 
DATA dadfam ; 
  MERGE dads faminc; 
  BY famid; 
RUN; 
PROC PRINT DATA=dadfam; 
    TITLE 'One-to-One Match Merge';
RUN; 

*Part 2: Merge data sets with IN option;
*  a=1, b=0;
DATA dadfam_left_merge ; 
  MERGE dads(IN=a) faminc(IN=b);
  IF a=1 and b=0;
  BY famid; 
RUN; 
PROC PRINT DATA=dadfam_left_merge; 
    TITLE 'Left Merge';
RUN; 
DATA dadfam_right_merge ; 
  MERGE dads(IN=a) faminc(IN=b);
  IF a=0 and b=1;
  BY famid; 
RUN; 
PROC PRINT DATA=dadfam_right_merge; 
    TITLE 'Right Merge';
RUN; 
DATA dadfam_between_merge ; 
  MERGE dads(IN=a) faminc(IN=b);
  IF a=1 and b=1;
  BY famid; 
RUN; 
PROC PRINT DATA=dadfam_between_merge; 
    TITLE 'Between Merge';
RUN; 


************************************************************************
Example-Updating a Master Data Set Using UPDATE Statement
************************************************************************;
*Master DATA SET; 
DATA patientmaster;
    INFILE '/folders/myfolders/Week3/Admit.dat';
    INPUT Account LastName $ 8-16 Address $ 17-34
        BirthDate MMDDYY10. Sex $ InsCode $ 48-50 @52 LastUpdate MMDDYY10.;
RUN;
PROC SORT DATA = patientmaster;
    BY Account;
RUN;
PROC PRINT DATA = patientmaster;
    TITLE 'Master Data Set';
    Format BirthDate MMDDYY10.;
RUN;

*Transaction DATA SET; 
DATA transactions;
    INFILE '/folders/myfolders/Week3/NewAdmit.dat';
    INPUT Account LastName $ 8-16 Address $ 17-34 BirthDate MMDDYY10.
        Sex $ InsCode $ 48-50 @52 LastUpdate MMDDYY10.;
RUN;
PROC SORT DATA = transactions;
    BY Account;
RUN;
PROC PRINT DATA = transactions;
    TITLE 'Transactions Data Set';
    FORMAT BirthDate LastUpdate MMDDYY10.;
RUN;

* Update patient data with transactions;
DATA patientmaster;
    UPDATE patientmaster transactions;
    BY Account;
RUN;
PROC PRINT DATA = patientmaster;
    FORMAT BirthDate LastUpdate MMDDYY10.;
    TITLE 'Updated Master Data Set';
RUN;


* Compare the results from merging patient data and transactions;
DATA merged_data;
    MERGE patientmaster transactions;
    BY Account;
RUN;
PROC PRINT DATA = merged_data;
    FORMAT BirthDate LastUpdate MMDDYY10.;
    TITLE 'Merged Data';
RUN;