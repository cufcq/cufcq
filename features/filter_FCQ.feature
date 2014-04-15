Feature: Be able to filter information
	As the a prospective student
	I want to see only courses that apply to me

Scenario: View filtered information
#this is the part with the regex 
	Given I am on the CSCI Department Page
	#how we demonstrate the actual feature
	Given I am on the Instructors page
	When I filter to Undergraduate only
	Then I should see undergraduate FCQs
	Then I should not see graduate FCQs
