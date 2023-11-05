*-----------------------------------------*
/*Problem 1 - Export Dataset             */
*-----------------------------------------*
*Part 1*;
LIBNAME  Week2 '/home/u63559709/sasuser.v94/Week 2';

*Part 2*;
DATA death_count;
    INFILE '/home/u63559709/sasuser.v94/Week 2/2010-2015-Age65above Final Death Count.csv' DSD FIRSTOBS=2;
    INPUT year month gender $ age ICD10 $ death;
RUN;

PROC PRINT DATA=death_count(OBS=10);
RUN;

*Part 3*;
LIBNAME Week2 '/home/u63559709/sasuser.v94/Week 2';
DATA death_2015; 
    SET Week2.death_count; 
    WHERE year=2015; 
RUN;

PROC PRINT DATA=death_2015(OBS=10);
RUN;

*Part 4*;
PROC EXPORT DATA = death_2015  
OUTFILE ='/home/u63559709/sasuser.v94/Week 2/death_2015.csv'
    dbms=csv
    replace;
RUN;

*-----------------------------------------*
/*Problem 2 - PROC MEANS                 */
*-----------------------------------------*
*Part 1*;
DATA death_count; 
    INFILE '/home/u63559709/sasuser.v94/Week 2/2010-2015-Age65above Final Death Count.csv' DSD FIRSTOBS=2;
    INPUT year month gender $ age ICD10 $ death;
RUN;

*Part 2*;
PROC MEANS DATA=death_count SUM;
    CLASS year;
    VAR death;
    OUTPUT OUT=yearly_death_sum SUM(death)=total_deaths;
    TITLE "Death by Year";
RUN;

*Part 3*;
PROC MEANS DATA=death_count MEAN STD;
    CLASS month;
    VAR death;
    OUTPUT OUT=death_by_month MEAN(death)=avg_deaths STD(death)=std_deaths;
    TITLE "Mean and STD by Month";
RUN;

*Part 4*;
PROC SORT DATA=death_count;
    BY gender;
RUN;

PROC MEANS DATA=death_count SUM;
    BY gender;
    VAR death;
    OUTPUT OUT=gender_death_sum SUM=total_deaths;
RUN;

*-----------------------------------------*
/*Problem 3 - PROC FREQ                  */
*-----------------------------------------*
*Part 1*;
PROC FREQ DATA=death_count;
    TABLES year;
RUN;

PROC FREQ DATA=death_count;
    TABLES gender;
RUN;

*Part 2*;
PROC FREQ DATA=death_count;
    TABLES gender*month;
RUN;

*-----------------------------------------*
/*Problem 4 - PROC TABULAT               */
*-----------------------------------------*
*Part 1*;
PROC TABULATE DATA=death_count;
    CLASS year gender month;
    VAR death;
    TABLE year, 
          gender ALL, 
          (month ALL)*death*(mean sum) / BOX='Death';
RUN;

*Part 2*;
PROC TABULATE DATA=death_count;
    CLASS year gender month;
    VAR death;
    TABLE year*gender, 
          (month)*death*(mean sum) / BOX='Death';
RUN;

*-----------------------------------------*
/*Problem 5 - PROC REPORT                */
*-----------------------------------------*
*Part 1*;
PROC REPORT DATA = death_count NOWINDOWS;
    COLUMN gender month death avg_death;
    DEFINE gender / GROUP;
    DEFINE month / GROUP;
    DEFINE death / SUM 'Total Deaths';
    DEFINE avg_death / COMPUTED 'Average Deaths';
    COMPUTE avg_death;
        avg_death = death.sum / 6;
    ENDCOMP;
    TITLE 'PROC REPORT';
RUN;


