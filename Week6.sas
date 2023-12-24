************************************************************************
*Example-Substituting Text with Macro Variables;
************************************************************************;
*Part I: Read  and Print ;
DATA flowersales;
    INFILE '/folders/myfolders/Week6/TropicalFlowers.dat';
    INPUT CustomerID $4. @6 SaleDate MMDDYY10. @17 Variety $9.
        SaleQuantity SaleAmount;
RUN;
PROC PRINT DATA = flowersales;
    FORMAT SaleDate WORDDATE18. SaleAmount DOLLAR7.;
    TITLE "Sales of Flower";
RUN;

*Part II: Creating a global macro variable with %LET;

%LET flowertype = Ginger;
* You may change Ginger to other flower types such as Protea, Heliconia;

* Read the data and subset with a macro variable;
DATA flowersales;
    INFILE '/folders/myfolders/Week6/TropicalFlowers.dat';
    INPUT CustomerID $4. @6 SaleDate MMDDYY10. @17 Variety $9.
        SaleQuantity SaleAmount;
    IF Variety = "&flowertype";
RUN;

* Print the report using a macro variable;
PROC PRINT DATA = flowersales;
    FORMAT SaleDate WORDDATE18. SaleAmount DOLLAR7.;
    TITLE "Sales of &flowertype";
RUN;


************************************************************************
*Example- Concatenating Macro Variables with Other Text;
************************************************************************;
%LET SumVar = Quantity;

DATA flowersales;
    INFILE '/folders/myfolders/Week6/TropicalFlowers.dat';
    INPUT CustomerID $4. @6 SaleDate MMDDYY10. @17 Variety $9.
        SaleQuantity SaleAmount;
RUN;

* Summarize the sales for the selected variable;
PROC MEANS DATA = flowersales SUM MIN MAX MAXDEC=0;
    VAR Sale&SumVar;
    CLASS Variety;
    TITLE "Summary of Sales &SumVar by Variety";
RUN;


************************************************************************
* Example-Creating Modular Code with Macros;
************************************************************************;
* Create a macro called sample to print 5 largest sales;
%MACRO sample;
    PROC SORT DATA = flowersales;
        BY DESCENDING SaleQuantity;
    RUN;
    PROC PRINT DATA = flowersales (OBS = 5);
        FORMAT SaleDate WORDDATE18. SaleAmount DOLLAR7.;
        TITLE 'Five Largest Sales by Quantity';
    RUN;
%MEND sample;

* Read the flower sales data;
DATA flowersales;
    INFILE '/folders/myfolders/Week6/TropicalFlowers.dat';
    INPUT CustomerID $4. @6 SaleDate MMDDYY10. @17 Variety $9.
        SaleQuantity SaleAmount;
RUN;

*Invoke the macro;
%sample

************************************************************************
*Example-Adding Parameters to Macros;
************************************************************************;
%MACRO select(customer=, sortvar=);
    PROC SORT DATA = flowersales OUT = salesout;
        BY &sortvar;
        WHERE CustomerID = "&customer";
    RUN;
    PROC PRINT DATA = salesout;
        FORMAT SaleDate WORDDATE18. SaleAmount DOLLAR7.;
        TITLE1 "Orders for Customer Number &customer";
        TITLE2 "Sorted by &sortvar";
    RUN;
%MEND select;

* Read all the flower sales data;
DATA flowersales;
    INFILE '/folders/myfolders/Week6/TropicalFlowers.dat';
    INPUT CustomerID $4. @6 SaleDate MMDDYY10. @17 Variety $9.
        SaleQuantity SaleAmount;
RUN;

*Invoke the macro;
%select(customer = 356W, sortvar = SaleQuantity)
%select(customer = 240W, sortvar = SaleAmount)

************************************************************************
*Example-Writing Macros with Conditional Logic and DO LOOP;
************************************************************************;
%MACRO dailyreports;
    %IF &SYSDAY = Monday %THEN %DO;
        PROC PRINT DATA = flowersales;
            FORMAT SaleDate WORDDATE18. SaleAmount DOLLAR7.;
            TITLE "&SYSDAY &SYSDATE Report: Current Flower Sales";
        RUN;
    %END;
    %ELSE %IF &SYSDAY = Saturday %THEN %DO;
        PROC MEANS DATA = flowersales MEAN MIN MAX MAXDEC=0;
            CLASS Variety;
            VAR SaleQuantity;
            TITLE "&SYSDAY &SYSDATE Report: Summary of Flower Sales";
        RUN;
    %END;
%MEND dailyreports;

DATA flowersales;
    INFILE '/folders/myfolders/Week6/TropicalFlowers.dat';
    INPUT CustomerID $4. @6 SaleDate MMDDYY10. @17 Variety $9.
        SaleQuantity SaleAmount;
RUN;

%dailyreports

************************************************************************
*Example- Bar Charts;
************************************************************************;
*Read in data;
DATA chocolate;
    INFILE '/folders/myfolders/Week6/Choc.dat';
    INPUT AgeGroup $ FavoriteFlavor $ @@;
RUN;

PROC FORMAT;
    VALUE $AgeGp 'A' = 'Adult' 'C' = 'Child';
RUN;

* Bar chart for favorite flavor;
PROC SGPLOT DATA = chocolate;
    VBAR FavoriteFlavor / GROUP=AgeGroup BARWIDTH=0.5;
    FORMAT AgeGroup $AgeGp.;
    LABEL FavoriteFlavor = 'Flavor of Chocolate';
    TITLE1 'Favorite Chocolate Flavors by Age';
    TITLE2 'stacked bar charts';
RUN;

************************************************************************
*Example- Histograms;
************************************************************************;
DATA contest;
    INFILE '/folders/myfolders/Week6/Reading.dat';
    INPUT Name $ NumberBooks @@;
RUN;
* Create histogram and density curves;
PROC SGPLOT DATA = contest;
    HISTOGRAM NumberBooks /  BINWIDTH = 2 SHOWBINS SCALE = PERCENT;
    TITLE 'Reading Contest';
RUN;

************************************************************************
* Example- Box Plots;
************************************************************************;
DATA bikerace;
    INFILE '/folders/myfolders/Week6/Criterium.dat';
    INPUT Division $ NumberLaps @@;
RUN;
* Create box plot;
PROC SGPLOT DATA = bikerace;
    VBOX NumberLaps/ CATEGORY = Division;
    TITLE 'Bicycle Criterium Results by Division';
RUN;
************************************************************************
*Example- Scatter Plots;
************************************************************************;
DATA wings;
    INFILE '/folders/myfolders/Week6/Birds.dat';
    INPUT Name $12. Type $ Length Wingspan @@;
RUN;

* Plot Wingspan by Length;
PROC FORMAT;
    VALUE $birdtype
    'S' = 'Songbirds'
    'R' = 'Raptors';
RUN;
PROC SGPLOT DATA = wings;
    SCATTER X = Length Y =Wingspan  /  GROUP = Type  DATALABEL=Name;
    FORMAT Type $birdtype.;
    TITLE 'Comparison of Wingspan vs. Length';
RUN;
************************************************************************
*Example- Series Plots; 
************************************************************************;
* Part I one series;
proc sgplot data=sashelp.stocks (where=(date >= "01jan2003"d and stock = "IBM"));
     series x=date y=close;
     title "Stock Trend for IBM";
run;

* Part II three series;
proc sgplot data=sashelp.stocks (where=(date >= "01jan2003"d and stock = "IBM"));
  title "Stock Trend";
  series x=date y=close;
  series x=date y=low;
  series x=date y=high;
run;

************************************************************************
*Example- Specifying Image Properties and Saving Graphics Output;
************************************************************************;
ODS LISTING GPATH ='/folders/myfolders/Week6/';
ODS GRAPHICS / RESET
    IMAGENAME = 'IBM Stock Price'
    OUTPUTFMT = PNG
    HEIGHT = 3IN WIDTH = 6IN;
    
proc sgplot data=sashelp.stocks (where=(date >= "01jan2003"d and stock = "IBM"));
    title "Stock Trend ";
    series x=date y=close;
    series x=date y=low;
    series x=date y=high;
run;


************************************************************************
*Example- Controlling Axes,  Reference Lines, and Legend;
************************************************************************;
ODS LISTING GPATH ='/folders/myfolders/Week6/';
ODS GRAPHICS / RESET
    IMAGENAME = 'IBM Stock Price'
    OUTPUTFMT = PNG
    HEIGHT = 3IN WIDTH = 6IN;
    
PROC SGPLOT data=sashelp.stocks (where=(date >= "01jan2004"d and stock = "IBM"));
    title "Stock Trend ";
    series x=date y=close;
    series x=date y=low;
    series x=date y=high;
    REFLINE 75 95 / LABEL = ('$75' '$95') TRANSPARENCY = 0.2;
    XAXIS LABEL= '2004-2005';
    YAXIS LABEL = 'IBM Stock Price';
    KEYLEGEND / LOCATION = INSIDE POSITION = BOTTOMLEFT  across=2;
RUN;  
