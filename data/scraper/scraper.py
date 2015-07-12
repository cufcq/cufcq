# This scraper accesses the fcq website, fills out the forms, downloads FCQ data, and then optionally converts them to CSVs for the DB 

import mechanize
import requests
import os
import argparse

# Sample for getting Spring Semester of 2015: 
# python scraper.py -c true -ft 1 -fy 2015 -lt 1 -ly 2015 


# 1 is Spring, 4 is Summer, 7 is Fall
parser = argparse.ArgumentParser()
#if we want to do conversion  
parser.add_argument('-c', '--convert', nargs='+', type=bool)
#ft is the first term, in this case spring
parser.add_argument('-ft', '--firstterm', nargs='+', type=int)
#lt is the last term, begin with spring(1)
parser.add_argument('-lt', '--lastterm', nargs='+', type=int)

#first years, are years that we will start terms with. For example:
#if fyears are 2013, 2014, and last years are 2014, 2015 we will download 2013-2014 and 2014-2015
parser.add_argument('-fy', '--firstyears', nargs='+', type=int)
parser.add_argument('-ly', '--lastyears', nargs='+', type=int)
arguments = parser.parse_args()

#this is the boiler plate for the browser
br = mechanize.Browser()
br.set_handle_robots(False)   # ignore robots
br.set_handle_refresh(False)  # can sometimes hang without this
br.addheaders = [('User-agent', 'Firefox')]

#this sets the department we want, in this case we use entire campus
fcqdpt = 'BD : Entire Campus ## BD'
# 1 is Spring, 4 is Summer, 7 is Fall
#fterm is the first term, in this case spring
#lterm is the last term, spring as well.
#ftrm = '1'
ftrm = str(arguments.firstterm[0])
#ltrm = '1'
ltrm = str(arguments.lastterm[0])

fileFrmt = 'XLS'

#years that we are interested in, from first years to last years
fyrs = map(str,arguments.firstyears)
lyrs = map(str,arguments.lastyears)
#fyrs = ['2013', '2012', '2011', '2010', '2009', '2008', '2007']
#lyrs = ['2014', '2013', '2012', '2011', '2010', '2009', '2008']
# The instructor group grp1=[*ALL, TTT, OTH, T_O, TA]
grp1 = 'ALL'

for i in range (0,len(fyrs)):

    #the url for the fcq site
    url = 'https://fcq.colorado.edu/UCBdata.htm'

    #we open the url
    response = br.open(url)

    control = br.select_form("frmFCQ")

    #go through all of the form options so we can change them
    for control in br.form.controls:
        #this will show us all of our default value for the fields. See page options for the output of the FCQ page as of 1/3/15
        #print "DEFAULT: type=%s, name=%s value=%s" % (control.type, control.name, br[control.name])

        if (control.name == 'fcqdpt'):
            br[control.name] = [fcqdpt]
            print "CHANGE fcqdpt type=%s, name=%s value=%s" % (control.type, control.name, br[control.name])

        elif (control.name == 'ftrm'):
            br[control.name] = [ftrm]
            print "CHANGE first term type=%s, name=%s value=%s" % (control.type, control.name, br[control.name])

        elif (control.name == 'ltrm'):
            br[control.name] = [ltrm]
            print "CHANGE last term type=%s, name=%s value=%s" % (control.type, control.name, br[control.name])

        elif (control.name == 'fileFrmt'):
            br[control.name] = [fileFrmt]
            print "CHANGE fileFrmt type=%s, name=%s value=%s" % (control.type, control.name, br[control.name])

        elif (control.name == 'fyr'):
            br[control.name] = [fyrs[i]]
            print "CHANGE first year type=%s, name=%s value=%s" % (control.type, control.name, br[control.name])

        elif (control.name == 'lyr'):
            br[control.name] = [lyrs[i]]
            print "CHANGE last year type=%s, name=%s value=%s" % (control.type, control.name, br[control.name])

    response = br.submit()

    if 'Currently, Excel files with FCQ results are limited to 50,000 rows.' in response.read():
        print('CAUTION REQUEST HAS MORE THAN 50,000 LINES!')

    for link in br.links():
        if (link.text == 'Click here'):
            print(link.url)
            original = link.url
            #need to split because output link is: javascript:popup('/fcqtemp/BD010395426.xls','BD010395426','750','550','yes','yes')
            split = original.replace("\'","").split(',')
            #get this BD010395426
            proper_link = "https://fcq.colorado.edu/fcqtemp/{xcel}.xls".format(xcel=split[1])
            print proper_link

    r = requests.get(proper_link)
    file_name = "{ftrm}-{fyr}_{ltrm}-{lyr}".format(ftrm=ftrm,fyr=fyrs[i],ltrm=ltrm,lyr=lyrs[i])
    xcel_path = "../raw/{file_name}.xls".format(file_name=file_name)

    output = open(xcel_path,'wb')
    output.write(r.content)
    output.close()

    csv_path = "../fcq/{file_name}.csv".format(file_name=file_name)
    convert_command = "../instructor_maker.sh {input_file} {output_file}".format(input_file=xcel_path,output_file=csv_path)
    if arguments.convert:  
    	os.system(convert_command)
	print "Converted!"
    else: 
	print "Did not convert!"

print("SUCCESS!")
