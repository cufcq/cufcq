#! /bin/bash

#First, conver to multiple csvs 
ssconvert -S fcq.1.xls fcq.1.csv

# tr -d '"' < fcq.1.csv.1 | sed 's/Instructor,/instructor_last,instructor_first,/g' > fcq.1.csv.1

ssconvert -S fcq.2.xls fcq.2.csv

# tr -d '"' < fcq.2.csv.1 | sed 's/Instructor,/instructor_last,instructor_first,/g' > fcq.2.csv.1

# #Import csvs: .2 is the total grades, .4 is the grades for the upper and lower division classes, .7 is the different dep. codes
rm *.csv.{0,2}

# #this is the file with the first 9 lines cut out 
# tail -n +9 grades.csv.2 > big_grades.csv


 
