#BETA CUFCQ Project
######Goal: THIS IS A BETA FORK OF CUFCQ! See https://github.com/untra/cufcq for actual project!
#####Project by: Samuel Volin, Cristobal Salazar, Alex Tsankov

####FCQ: A survery maintained by CU and collected at the end of every course with the intent of rating instructor proficiency.

###To Run: 

- Make sure all of the gems are updated

###Views: 

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

