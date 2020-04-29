Data Hospitals_M Hospitals_F;
Set work.hospitals;
if gender = "M" then output Hospitals_M;
if gender = "F" then output Hospitals_F;
/*this creates two datasets and divides the data between them using ifs*/
run;