*/////*PROJECT 6*/////*;

*///*PROBLEM 1*///*;
*Part 1*;
%LET ClassAge = Pre-K 4;

*Part 2*;
DATA final;
    INFILE '/home/u63559709/sasuser.v94/Week 6/school 1 final.csv' DSD firstobs=2;
    INPUT ClassID ChildID Gender $ ClassAge $ Language $ f1 f2 f3 f4;
RUN;

PROC PRINT DATA=final;
	TITLE "School Data";
Run;

DATA ClassAge_final;
    INFILE '/home/u63559709/sasuser.v94/Week 6/school 1 final.csv' DSD firstobs=2;
    INPUT ClassID ChildID Gender $ ClassAge $ Language $ f1 f2 f3 f4;
    IF ClassAge = "&ClassAge";
RUN;

PROC PRINT Data=ClassAge_final;
	TITLE "School Info";
RUN;

*Part 3*;
%macro average(category, question, outdataset=averagescore);

PROC MEANS DATA=final NOPRINT;
	BY &category;
	VAR &question;
	OUTPUT OUT=&outdataset MEAN=;
RUN;

%mend average;

PROC SORT DATA=final; 
    BY ClassAge; 
RUN;

%average(ClassAge, f1); 

PROC PRINT DATA=averagescore;
    TITLE "Average of f1 by ClassAge";
RUN;

*Part 4*;
PROC SORT DATA=final; 
	BY Gender; 
RUN;
%average(category=Gender, question=f1, outdataset=averagescore_Gender);

*Part 5*;
PROC SORT DATA=final;
	By ClassAge;
RUN;
%average(category= ClassAge, question=f3, outdataset=averagescore_ClassAge)

*Part 6*;
%macro class(category);

%IF &category = Gender %THEN %DO;
	PROC MEANS DATA=final NOPRINT;
		BY &category;
		VAR f1;
	OUTPUT OUT=meanscore_gender MEAN=;
RUN;

PROC PRINT DATA=meanscore_gender;
	TITLE "Average of f1 by Gender";
RUN;

%END;

%ELSE %IF &category = ClassAge %THEN %DO;
	PROC MEANS DATA=final NOPRINT;
		BY &category;
		VAR f2;
		OUTPUT OUT=meanscore_classage MEAN=;
	RUN;

PROC PRINT DATA=meanscore_classage;
	TITLE "Average of f2 by ClassAge";
RUN;

%END;

%mend class;

*Part 7*;
PROC SORT DATA=final; 
    BY Gender; 
RUN;
%class(category=Gender);

*Part 8*;
PROC SORT DATA=final; 
    BY ClassAge; 
RUN;
%class(category=ClassAge);

*///*PROBLEM 2*///*;
*Part 1*;
DATA death_count;
    INFILE '/home/u63559709/sasuser.v94/Week 6/2010-2015-Age65above Final Death Count.csv' DSD firstobs=2;
    INPUT year month gender $ age ICD10 $ death;
RUN;

PROC PRINT DATA=death_count(OBS=10);
	TITLE "Death Count";
RUN;

*Part 2*;
PROC SORT DATA=death_count;
    BY year;
RUN;

PROC MEANS DATA=death_count NOPRINT;
    BY year;
    VAR death;
    OUTPUT OUT=yearly_death_sum SUM=total_death;
RUN;

PROC PRINT DATA=yearly_death_sum;
    TITLE "Death Chart";
RUN;

PROC SGPLOT DATA=yearly_death_sum;
    HBAR year / RESPONSE=total_death;
    TITLE "Total Deaths by Year";
RUN;

*Part 3*;
PROC SORT DATA=death_count;
    BY ICD10;
RUN;

PROC MEANS DATA=death_count NOPRINT;
    BY ICD10;
    VAR death;
    OUTPUT OUT=ICD10_death_sum SUM=total_death;
RUN;

ODS LISTING GPATH ='/home/u63559709/sasuser.v94/Week 6';
ODS GRAPHICS / RESET
    IMAGENAME = 'Total Death by Death Code'
    OUTPUTFMT = PNG
    HEIGHT = 4IN WIDTH = 6IN;
    
PROC SGPLOT DATA=ICD10_death_sum;
    SCATTER X=ICD10 Y=total_death / DATALABEL=ICD10;
    XAXIS LABEL='Death Code';
    YAXIS LABEL='Total Death';
    TITLE "Total Death by Death Code";
RUN;

*Part 4*;
DATA death_ICD52;
    SET death_count;
    WHERE ICD10 = '52';
RUN;

PROC SGPLOT DATA=death_ICD52;
    HISTOGRAM death;
    TITLE "Histogram of Deaths with ICD=52";
RUN;

*Part 5*;
PROC SGPLOT DATA=death_count;
    VBOX death / CATEGORY=gender;
    TITLE "Deaths by Gender";
RUN;

PROC SGPLOT DATA=death_count;
    VBOX death / CATEGORY=gender;
    TITLE "Deaths by Gender (Without Outliers)";
    YAXIS MAX=200;
RUN;

*Part 6*;
ODS LISTING GPATH ='/home/u63559709/sasuser.v94/Week 6';
ODS GRAPHICS / RESET
    IMAGENAME = 'Death by Month'
    OUTPUTFMT = PNG
    HEIGHT = 3IN WIDTH = 6IN;

proc sgplot data=death_count;
    title "Deaths by Month(Adjusted)";
    hbox death / category=month NOOUTLIERS;
    xaxis max=1000;
run;

proc sgplot data=death_count;
    title "Deaths by Month";
    hbox death / category=month;
run;