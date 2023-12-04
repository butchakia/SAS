*///*PROJECT 5*///*;
libname Week5 '/home/u63559709/sasuser.v94/Week 5';

/*PROBLEM 1*/;
*PART 1*;
PROC SQL;
    TITLE "Population and Countries by Continent";
    SELECT Continent, count(Name) AS NumberOfCountries, sum(Population) AS TotalPopulation
    FROM Week5.countries
    GROUP BY Continent;
QUIT;

*Part 2*;
PROC SQL;
    TITLE "Continents with over 40 Countries";
    SELECT Continent, count(Name) AS NumberOfCountries
    FROM Week5.countries
    GROUP BY Continent
    HAVING count(Name) > 40;
QUIT;

PROC SQL;
    TITLE "Population and Countries by Continent";
    SELECT Continent, count(Name) AS NumberOfCountries, sum(Population) AS TotalPopulation
    FROM Week5.countries
    GROUP BY Continent
    HAVING count(Name) > 40;
QUIT;

/*PROBLEM 2*/;
PROC SQL;
    TITLE "US States with State Code, Capital, Latitude, and Longitude";
    SELECT u.Name AS State, p.Code AS State_code, u.Capital, c.Latitude, c.Longitude
    FROM Week5.unitedstates AS u
    LEFT JOIN Week5.postalcodes AS p ON u.Name = p.Name
    LEFT JOIN Week5.uscitycoords AS c ON u.Capital = c.City;
QUIT;

/*PROBLEM 3*/
PROC SQL;
    TITLE "US States with Population greater than Greece";
    SELECT Name AS State, Population format=comma18.
    FROM Week5.unitedstates
    WHERE Population > (SELECT Population FROM Week5.countries WHERE Name = 'Greece');
QUIT;

/*PROBLEM 4*/
PROC SQL;
    TITLE "Continent and Total Area";
    SELECT Continent, SUM(Area) AS TotalArea
    FROM Week5.countries
    WHERE Continent IS NOT MISSING
    GROUP BY Continent;
QUIT;


/*PROBLEM 5*/;
data FLDFarmers;
    input FLD_ID Farmer $;
    datalines;
    12678 Farmer_A
    12678 Farmer_A
    11857 Farmer_B
    11857 Farmer_B
    10446 Farmer_A
    10446 Farmer_C
    14789 Farmer_G
;
run;

data FLDCrops;
    input FLD_ID Crop $;
    datalines;
    12678 Corn
    12678 Soybeans
    11857 Wheat
    11857 Corn
    13229 Soybeans
    13229 Wheat
    10889 Corn
    10446 Soybeans
    15668 Wheat
;
run;

proc sort data=FLDFarmers;
    by FLD_ID;
run;

proc sort data=FLDCrops;
    by FLD_ID;
run;

data FLDCombined;
    merge FLDFarmers(in=a) FLDCrops(in=b);
    by FLD_ID;
    if a and b;
run;

PROC SQL;
	TITLE "Combined Table";
    SELECT f.FLD_ID, f.Farmer, c.Crop
    FROM FLDFarmers AS f
    INNER JOIN FLDCrops AS c ON f.FLD_ID = c.FLD_ID;
QUIT;