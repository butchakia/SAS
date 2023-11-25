************************************************************************
Example-Comparing PROC SQL with the SAS DATA Step;
************************************************************************;
*Part I;
libname Week4 '/folders/myfolders/Week4';
proc sql; 
title 'Population of Large Countries Grouped by Continent'; 
select Continent, sum(Population) as TotPop format=comma15. 
from Week4.countries 
where Population gt 1000000 
group by Continent 
order by TotPop;
quit;

*Part II;
title 'Large Countries Grouped by Continent';
proc summary data=Week4.countries; 
    where Population > 1000000; 
    class Continent; 
    var Population; 
    output out=sumPop sum=TotPop;
run;
proc sort data=SumPop; 
    by totPop;
run;
proc print data=SumPop noobs; 
    var Continent TotPop; 
    format TotPop comma15.; 
    where _type_=1;
run;

************************************************************************
* Example-Selecting All Columns in a Table;
************************************************************************;
libname Week4 '/folders/myfolders/Week4';
proc sql outobs=12; 
title 'U.S. Cities with Their States and Coordinates'; 
select * 
from Week4.uscitycoords;
quit;

************************************************************************
*Example-Selecting Specific Columns in a Table;
************************************************************************;
*Part I Select only one column;
libname Week4 '/folders/myfolders/Week4';
proc sql outobs=12; 
    title 'Names of U.S. Cities'; 
    select City 
    from Week4.uscitycoords;
quit;

*Part II Select two columns;
libname Week4 '/folders/myfolders/Week4';
proc sql outobs=12; 
    title 'Names of U.S. Cities'; 
    select City, State 
    from Week4.uscitycoords;
quit;

************************************************************************
*Example- Eliminating Duplicate Rows from the Query Results;
************************************************************************;
* Part I not using the DISTINCT keyword; 
libname Week4 '/folders/myfolders/Week4';
proc sql outobs=12; 
    title 'Continents of the United States'; 
    select Continent 
    from Week4.unitedstates;
Quit;

* Part II using the DISTINCT keyword; 
libname Week4 '/folders/myfolders/Week4';
proc sql outobs=12; 
    title 'Continents of the United States'; 
    select distinct Continent 
    from Week4.unitedstates;
Quit;

************************************************************************
*Example- Creating New Columns by Adding Text to Output;
************************************************************************;
* Part I Add strings as columns; 
libname Week4 '/folders/myfolders/Week4';
proc sql outobs=12; 
    title 'U.S. Postal Codes'; 
    select 'Postal code for', Name, 'is', Code 
    from Week4.postalcodes; 
Quit;

* Part II Supress columns' names; 
libname Week4 '/folders/myfolders/Week4';
proc sql outobs=12; 
    title 'U.S. Postal Codes'; 
    select 'Postal code for', Name label='#', 'is', Code label='#'
    from Week4.postalcodes; 
Quit;

************************************************************************
*Example- Creating New Columns by Calculating Values;
************************************************************************;
* Part I adding a numeric column; 
libname Week4 '/folders/myfolders/Week4';
proc sql outobs=12; 
    title 'Low Temperatures in Celsius'; 
    select City, (AvgLow - 32) * 5/9 format=4.1 
    from Week4.worldtemps;
Quit;

* Part II Assigning a Column Alias; 
libname Week4 '/folders/myfolders/Week4';
proc sql outobs=12; 
    title 'Low Temperatures in Celsius'; 
    select City, (AvgLow - 32) * 5/9 as LowCelsius format=4.1 
    from Week4.worldtemps;
Quit;

************************************************************************
*Example- Referring to a Calculated Column by Alias;
************************************************************************;
libname Week4 '/folders/myfolders/Week4';
proc sql outobs=12; 
    title 'Range of High and Low Temperatures in Celsius'; 
    select City, (AvgHigh - 32) * 5/9 as HighC format=5.1, 
    (AvgLow - 32) * 5/9 as LowC format=5.1, 
    (calculated HighC - calculated LowC) as Range format=4.1 
    from Week4.worldtemps;
Quit;

************************************************************************
*Example-Assigning Values Conditionally: Using a Simple CASE Expression;
************************************************************************;
libname Week4 '/folders/myfolders/Week4';
proc sql outobs=12; 
    title 'Climate Zones of World Cities'; 
    select City, Country, Latitude, 
        case 
            when Latitude gt 67 then 'North Frigid' 
            when 67 ge Latitude ge 23 then 'North Temperate' 
            when 23 gt Latitude gt -23 then 'Torrid' 
            when -23 ge Latitude ge -67 then 'South Temperate' 
            else 'South Frigid' 
        end as ClimateZone 
    from Week4.worldcitycoords order by City; 
quit;
************************************************************************
*Example-Replacing Missing Values;
************************************************************************;
libname Week4 '/folders/myfolders/Week4';
proc sql; 
    title 'Continental Low Points'; 
    select Name, coalesce(LowPoint, 'Not Available') as LowPoint 
    from Week4.continents; 
quit;

*use Case Expression;
libname Week4 '/folders/myfolders/Week4';
proc sql; 
    title 'Continental Low Points'; 
    select Name, 
    case 
        when LowPoint is missing then 'Not Available' 
        else Lowpoint 
        end as LowPoint 
    from Week4.continents;
quit;
************************************************************************
*Example- Sorting by Columns;
************************************************************************;
* Part I ordering by one column;
libname Week4 '/folders/myfolders/Week4';
proc sql outobs=12; 
    title 'Country Populations'; 
    select Name, Population format=comma10. 
    from Week4.countries 
    order by Population;
Quit;

* Part II ordering by two columns;
libname Week4 '/folders/myfolders/Week4';
proc sql outobs=12; 
    title 'Countries, Sorted by Continent and Name'; 
    select Name, Continent 
    from Week4.countries 
    order by Continent, Name;
Quit;

************************************************************************
*Example- Specifying a Sort Order;
************************************************************************;
libname Week4 '/folders/myfolders/Week4';
proc sql outobs=12; 
    title 'World Population Densities per Square Mile'; 
    select Name, Continent, Population format=comma12., Area format=comma8., 
    Population/Area as Density format=comma10. 
    from Week4.countries 
    order by  Continent, Density DESC;
Quit;

************************************************************************
*Example- Sorting by Calculated Column;
************************************************************************;
libname Week4 '/folders/myfolders/Week4';
proc sql outobs=12; 
    title 'World Population Densities per Square Mile'; 
    select Name, Population format=comma12., Area format=comma8., 
        Population/Area as Density format=comma10. 
    from Week4.countries 
    order by Density desc;
Quit;

************************************************************************
*Example- Sorting by Column Position;
************************************************************************;
libname Week4 '/folders/myfolders/Week4';
proc sql outobs=12; 
    title 'World Population Densities per Square Mile'; 
    select Name, Population format=comma12., Area format=comma8., 
    Population/Area format=comma10. label='Density' 
    from Week4.countries order by 4 desc;
quit;

************************************************************************
*Example- Sorting Columns That Contain Missing Values;
************************************************************************;
libname Week4 '/folders/myfolders/Week4';
proc sql; 
    title 'Continents, Sorted by Low Point'; 
    select Name, LowPoint 
    from Week4.continents 
    order by LowPoint;
quit;

************************************************************************
*Example- Using a Simple WHERE Clause;
************************************************************************;
libname Week4 '/folders/myfolders/Week4';
proc sql outobs=12; 
    title 'Countries in Europe'; 
    select Name, Population format=comma10. 
    from Week4.countries 
    where Continent = 'Europe';
Quit;

************************************************************************
*Example-Retrieving Rows Based on a Comparison;
************************************************************************;
libname Week4 '/folders/myfolders/Week4';
proc sql outobs=12; 
    title 'States with Populations over 5,000,000'; 
    select Name, Population format=comma10. 
    from Week4.unitedstates 
    where Population > 5000000 
    order by Population desc;
Quit;

************************************************************************
*Example-Retrieving Rows That Satisfy Multiple Conditions;
************************************************************************;
libname Week4 '/folders/myfolders/Week4';
proc sql outobs=12; 
    title 'Countries in Africa with Populations over 20,000,000'; 
    select Name, Population format=comma10. 
    from Week4.countries 
    where Continent = 'Africa' and Population gt 20000000 
    order by Population desc;
Quit;

************************************************************************
*Example-Using the IN Operator in Where Clause;
************************************************************************;
libname Week4 '/folders/myfolders/Week4';
proc sql outobs=12; 
    title 'Using the IN Operator in Where Clause'; 
    select Name, Continent, Population format=comma10. 
    from Week4.countries 
    where Continent in ('Africa', 'Europe') 
    order by Population;
Quit;

************************************************************************
*Example-Using the IS MISSING Operator in Where Clause;
************************************************************************;
libname Week4 '/folders/myfolders/Week4';
proc sql outobs=12; 
    title 'Using the IS MISSING Operator in Where Clause'; 
    select Name, Continent, Population format=comma10. 
    from Week4.countries 
    where Continent IS MISSING 
    order by Population;
Quit;

************************************************************************
*Example-Using the LIKE Operator in Where Clause;
************************************************************************;
libname Week4 '/folders/myfolders/Week4';
proc sql outobs=12; 
    title1 'Country Names that Begin with the Letter "Z"'; 
    title2 'or Are 5 Characters Long and End with the Letter "a"'; 
    select Name 
    from Week4.countries 
    where Name like 'Z%' or Name like '____a';
Quit;