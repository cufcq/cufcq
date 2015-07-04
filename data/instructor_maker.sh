#!/bin/bash

#csv_maker.sh: This is used to convert the XCEL documents we get from the FCQ website to the CSVs we need for our DB

# echo "Enter input file XCEL (include location): "
# read input
input=$1
# echo "Enter output file (include location): "
# read output
output=$2

echo $input
echo $output

#converts the xcel to a temporary csv with ssconvert (see gnumeric)
ssconvert -S $input temp.csv

#Split the instructor field, to insturctor first and last.
tr -d '"' < *.csv.1 | sed 's/Instructor,/Instructor_last,Instructor_first,/g' > $output

#Cleanup any cruft files
rm -r *.csv.?

#moves all lines after the first 2 to work.csv
tail -n +2 "$output" > work.csv

#our new header field we use for our DB, put on top of work.csv and move that to our final temp.csv
echo 'yearterm,subject,crse,sec,onlineFCQ,bdcontinedcrse,instructor_last,instructor_first,forms_requested,forms_returned,percentage_passed,course_overall,course_overall_SD,instructoroverall,instructoroverall_SD,total_hours,prior_interest,effectiveness,availability,challenge,amount_learned,respect,course_title,courseOverall_old,courseOverall_SD_old,instrOverall_old,instrOverall_SD_old,r_Fair,r_Access,workload,r_Divstu,r_Diviss,r_Presnt,r_Explan,r_Assign,r_Motiv,r_Learn,r_Complx,campus,college,aSdiv,level,fcqdept,instructor_group,i_Num' | cat - work.csv > temp.csv

#modify the header line in temp.csv and move it to the final output file to be used by rake
awk -F, '/,/{gsub(/ /, "", $0); print}' temp.csv > $output

#remove the temps
rm temp.csv
rm work.csv
