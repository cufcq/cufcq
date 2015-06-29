#Official CU FCQ Project
#####Project by: Samuel Volin, Alex Tsankov

### What is an FCQ?

An FCQ (Faculy Course Questionnare) is a survey maintained by CU and collected at the end of every course with the intent of rating instructor proficiency and gauging the quality of a class. It measures a variety of different criteria like:
* How effective was a teacher at generating interest in a subject?
* How many hours a week, on average, did students spend on a class?
* How available was an instructor for the class?

This is all fascinating info that we believe can inform students when it comes time to pick classes. Fortunately it's all publicly available at this [site](http://www.colorado.edu/fcq/) maintained by CU. This program takes the data, adds its to a database, draws connections between the FCQs, and formats it nicely using JS. You can see the a server running this at [cufcq.com](cufcq.com).

Last FCQs added: Fall 2014.

### To Run:
1. Install the correct dependencies. On linux this can be done with the following command:

```sudo apt-get install postgresql-common postgresql-9.3 libpq-dev rails node postgresql-contrib-9.3 openjdk-6-jdk```

2. Create the Postgres DB following the commands at ```config/installing_postgresql.txt```

3. Navigate to the cloned directory and perform a ```bundle install``` to make sure all Ruby gems are updated.

4. Initialize the DB with total_reload.sh. This will run a bunch of rake tasks that reads the csv files stored in data/output and put them into the DB.

5. Run the correct launcher (./local_launcher.sh if you just want to run it on a local machine).

6. Go to ```localhost:3000/instructors``` to see if the site is running properly.

### What's going on:

When we download FCQs off of the official website, we get large Excel files containing the scores for each class that has been taught during that semester. You can access this information using the tools in csv_make, specifically ```scraper.py```.

 What our system does on a large scale, is take the data from the individual classes and break them into their logical criteria. Each FCQ is tied to a course and teacher. We can start aggregating all of the FCQs for each instructor into an ```instructor``` page. Likewise, we can take multiple FCQs and aggregate them into ```courses```. We can then draw relations between instructors and courses and combine them into ```departments```.

We also tie in grade data, provided seperately in gradesall.xlsx to individual FCQs.

###Imports:

You can create csv files from the excel documents from the FCQ website using data/csv_maker.sh, this requires ssconvert which is a gnumeric application. Put the final csv files into to the data/output directory.

All files that end in .csv in data/output are imported using the import script. This script is found in lib/tasks/import.rake

###API Endpoints:

You can see the json returned for insturctors and courses in ```doc/```
TODO - Add in more documentation for our endpoints. 
