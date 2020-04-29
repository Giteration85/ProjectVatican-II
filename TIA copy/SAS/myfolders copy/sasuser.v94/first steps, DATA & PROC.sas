data Hospitals;
	/*data manipulation is in the DATA step*/
	INPUT PatientID $ HospitalBill Age Diagnosis $ Gender $ State $;

	/*the $ follows a column field that is a character type*/
	Datalines;
	1 500 5 SoreThroat M NY
	2 1500 68 Fall F ME
	3 2000 94 Parkinsons M NY
	4 250 15 Checkup F NY
	5 25000 9 Cancer F HI
	6 900 64 Diabetes M ME
	;
Run;

/*Proc Print;*/
	/*Proc is what we DO with the data ... procedural things*/
/*Run*/

Data Hospitals_M Hospitals_F;
Set work.hospitals;
if gender = "M" then output Hospitals_M;
if gender = "F" then output Hospitals_F;
/*this creates two datasets and divides the data between them using ifs*/
run;

Data LargeBills;
Set work.hospitals;
if HospitalBill >= 1000;
/*could also do if HospitalBill < 1000 then Delete*/;
run;

%let COINS = 0.8; /*this creates a variable*/
Data health;
Set work.hospitals;

netinsamt = HospitalBill * &COINS; /*this also creates a new column using the &variable*/
pred_hosp_bill = -99.65600*Age + 9260.38017;



run;


Data Hosp_Concat;
set work.hospitals;
/*concatenation*/

Genstate = Gender || "_" || State;
Run;

*alternative way to comment;


PROC SORT Data = work.health;
by Gender Descending HospitalBill;
run;

Proc print data = work.health (OBS = 3); /*this keeps first three observations*/
var gender age hospitalbill;
*where hospitalbill >= 1000;
run;


*contents can be thought of as information describing data. fast.;

proc contents; *this is like summary for R;
proc freq data = health; *this looks at how many times your data repeats;
tables Gender;
run;

*now for regressions;

proc reg data = health;
model HospitalBill = Age; *first var is what you're trying to predict;
run;


*go back up to line 38 and create a new variable that runs on the regression parameter estimates;
*model sucks, just looking at R-squared and p-values ... but looking at the actual predictions you can really see how far off it is;

proc report data = hospitals;
column state gender hospital_bill;
define state / group; *groups rows of same states together;
define gender / group;
define hospitalbill / sum; *sums the hospital bills of genders within each state;
*can do mean "mean HB" which would rename the column in the report and use avg instead of sum;
run;


proc report data = hospitals;
column state gender hospitalbill, (sum mean median);
define state / group; *groups rows of same states together;
define gender / group;
run;

proc report data = hospitals;
*where state = "NY"; *use quotes bc NY is a character type;
column state gender hospitalbill;
define state / group;
define gender / group;
break after state / summarize ol skip; *this puts on a summary line for each state-gender group;
rbreak after / summarize ol skip; *this puts on a final line to tally the overall sum;
title 'summary of hospital bills';
run;


proc sort data = work.hospitals; *(KEEP = age gender hospitalbill) will keep only these columns;
by state gender; *we could use DROP instead of KEEP to drop variables;
run;
proc means data = work.hospitals mean n sum; *not choosing stats lets it do its own four;
by state gender;
run;

data hospitals (rename = (hospitalbill = hospital_bill));
retain patientid state gender age diagnosis hospitalbill; *retain will order columns according to this order;
set work.hospitals;
run;

*let's create a new dataset and merge it with our old one;
data occupation;
	input patientid $ jobtype $;
	datalines;
	1 Kinder
	2 Actuary
	3 Retired
	4 HS
	5 ELEM
	;
run;
*now we have to sort our datasets so they start w the same key variable we merge on;

proc sort data = hospitals;
by patientid;
run;
proc sort data = occupation;
by patientid;
run;

data combine;
merge hospitals (in = a) occupation (in = b);
by patientid;
if a and b;*notice we only have five entries ... this is bc of an inner join ... left join is "if a" and right join is "if b";
run;


*how to use SQL in SAS;

proc sql; *(this invokes SQL when you put a run at the end);
create table sql_combine as
select hospitals.patientid, hospitals.age, occupation.jobtype
from hospitals left join occupation
on hospitals.patientid = occupation.patientid;
run;


proc corr data = hospitals; * can do proc corr data = hospitals spearman for different correlation coefficients;
var age;
with hospital_bill;
run;

*let's chart;
ods graphics on; 
proc corr data = hospitals plots = (scatter);
var age;
with hospital_bill;
run;