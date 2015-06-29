#! /bin/bash

#First, convert to multiple csvs 
ssconvert -S fcq/fcq.1.xls fcq/fcq.1.csv

# tr -d '"' < fcq/fcq.1.csv.1 | sed 's/Instructor,/instructor_last,instructor_first,/g' > fcq/fcq.1.csv.1

ssconvert -S fcq/fcq.2.xls fcq/fcq.2.csv

# tr -d '"' < fcq/fcq.2.csv.1 | sed 's/Instructor,/instructor_last,instructor_first,/g' > fcq/fcq.2.csv.1

# Import csvs: .2 is the total grades, .4 is the grades for the upper and lower division classes, .7 is the different dep. codes
rm ./fcq/*.csv.{0,2}

# #this is the file with the first 9 lines cut out 
# tail -n +9 grades.csv.2 > big_grades.csv


 
