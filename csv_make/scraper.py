import mechanize
import requests


#this is the boiler plate for the browser
br = mechanize.Browser()
br.set_handle_robots(False)   # ignore robots
br.set_handle_refresh(False)  # can sometimes hang without this
br.addheaders = [('User-agent', 'Firefox')]

#the url for the fcq site
url = 'https://fcq.colorado.edu/UCBdata.htm'

#we open the url 
response = br.open(url)

# NOTE: Use this to find all available forms on a page 
# for form in br.forms():
#     print "Form name:", form.name
#     print form

# find the proper form 
control = br.select_form("frmFCQ")


fcqdpt = 'BD : Entire Campus ## BD'
# 1 is Spring, 4 is Summer, 7 is Fall  
ftrm = '1'
fileFrmt = 'XLS'
f


#go through all of the form options so we can change them 
for control in br.form.controls:
	#this will show us all of our default value for the fields. See page options for the output of the FCQ page as of 1/3/15
    #print "DEFAULT: type=%s, name=%s value=%s" % (control.type, control.name, br[control.name])
	
	#this is our fcq department 
    if (control.name == 'fcqdpt'):
    	br[control.name] = ['AS : POLITICAL SCIENCE -- PSCI']
    	print "CHANGE fcqdpt type=%s, name=%s value=%s" % (control.type, control.name, br[control.name])

    #this is our first term
    if (control.name == 'ftrm'):
    	br[control.name] = ['1']
    	print "CHANGE first term type=%s, name=%s value=%s" % (control.type, control.name, br[control.name])

    if (control.name == 'ltrm'):
    	br[control.name] = ['1']
    	print "CHANGE last term type=%s, name=%s value=%s" % (control.type, control.name, br[control.name])

    if (control.name == 'fileFrmt'):
    	br[control.name] = ['XLS']
    	print "CHANGE fileFrmt type=%s, name=%s value=%s" % (control.type, control.name, br[control.name])

    if (control.name == 'fyr'):
    	br[control.name] = ['2008']
    	print "CHANGE first year type=%s, name=%s value=%s" % (control.type, control.name, br[control.name])

    if (control.name == 'lyr'):
    	br[control.name] = ['2009']
    	print "CHANGE first year type=%s, name=%s value=%s" % (control.type, control.name, br[control.name])

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
		proper_link = "https://fcq.colorado.edu/fcqtemp/%s.xls" % (split[1])
		print proper_link

r = requests.get(proper_link)

output = open('test.xls','wb')
output.write(r.content)
output.close()


