*///*PROJECT 4*///*;
libname Week4 '/home/u63559709/sasuser.v94/Week 4';

/*PROBLEM 1*/;
*Order cities by high temperature converted to Celsius*;
PROC SQL OUTOBS=20;
	TITLE "World Temps";
	SELECT City, (AvgHigh - 32) * 5/9 AS HighTempC format=4.1
	FROM Week4.worldtemps
	ORDER BY HighTempC DESC;
QUIT;

/*PROBLEM 2*/;
*Create table with new labeling columns*;
PROC SQL;
	TITLE "Postal Codes";
	SELECT "In United States", "Postal code for", "of", Name, "is", Code
	FROM Week4.postalcodes
	WHERE Name = 'Illinois' OR Name = 'Ohio' OR Name = 'North Carolina';
QUIT; 

/*PROBLEM 3*/;
*Cities with selected temperature ranges*;
PROC SQL;
	TITLE "Selected Cities Temperatures";
	SELECT City, (AvgHigh - 32) * 5/9 AS AvgH, (AvgLow - 32) * 5/9 AS AvgL, ((AvgHigh - 32) * 5/9) - ((AvgLow - 32) * 5/9) AS RangeC 
	FROM Week4.worldtemps
	WHERE 40 GE ((AvgHigh - 32) * 5/9) - ((AvgLow - 32) * 5/9) GE 38;	 
QUIT;

/*Problem 4*/
*Setting Climate Zones and applying them to cities*;
PROC SQL;
	TITLE "Climate Zones";
	SELECT City, Country, Latitude, 
        case 
            when Latitude gt 67 then 'North Frigid' 
            when 67 ge Latitude ge 23 then 'North Temperate' 
            when 23 gt Latitude gt -23 then 'Torrid' 
            when -23 ge Latitude ge -67 then 'South Temperate' 
            else 'South Frigid' 
        end as ClimateZone 
	FROM Week4.worldcitycoords
	WHERE City = 'Santiago' OR City ='Beijing' OR City = 'Havana' 
	OR City = 'Oslo' OR City = 'Montevideo' OR City = 'Ottawa';
QUIT;