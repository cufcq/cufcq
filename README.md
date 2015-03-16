#Offficial CUFCQ Project
#####Project by: Samuel Volin, Alex Tsankov

####FCQ: A survery maintained by CU and collected at the end of every course with the intent of rating instructor proficiency.

###To Run:

- Make sure all of the gems are updated (bundle update)
- Initialize the DB with total_reload.sh
- Run launcher.sh
- Go to /instructors to see if the site was populated properly. 

####Imports: 

You can create csv files from the excel documents from the FCQ website using csv_make/csv_maker.sh, this requires ssconvert which is a gnumeric application. Put the final csv files into to the csv_make/output directory. 

All files that end in .csv in csv_make/output are imported using the import script. This script is found in lib/tasks/import.rake. 

For testing purposes, we only have FCQs of the Math department by default in the output folder. 

We have 2 different import scripts that should be run when you want to make changes to the DB. Use total_reload.sh on the first run and fast_reload for smaller changes. 


####Courses: 
Look at the past FCQ data for differnet courses. 

Example: Find out pass rates for a different courses over time. 

####Departments: 
Analyze department wide data to find information about different teachers and courses. 

Example: Find out the most popular course in a department. 

####FCQs: 
Look at raw FCQ data for a unique course. 

Example: Find out the ratings students gave to a teacher during a specific course 

####Instructors: 
Analyze FCQs to determine teacher averages for different criteria over the duration of multiple courses. 

Example: Find out the overall average respect rating for a teacher based on all of their courses.

###Controllers:

####instructors_controller.rb

We can use this controller to get specific data about each instructor from the DB.

####fcq_controller.rb

This controller is used to access info about each individual fcq from the DB. 

####courses_controller.rb

The courses controller pull by individual course. 

####departments_controller.rb

This combines all of our data and allows to work with different indivudal departments. 

###Models:

####course.rb 

This has the methods to work with each course. 

####department.rb 

This has the methods to analyze department-wide data. 

####fcq.rb 

This has the methods to work with each individual FCQ. 

####instructor.rb 

We can use this model to parse individual instructor data.  

