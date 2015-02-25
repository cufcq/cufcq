Feature: See raw FCQ data
	As the Department Head
	I want to see raw FCQ data

Scenario: Viewing FCQ data
	Given I am on the CSCI Department Page
	Given I am on the Instructors page
	When I click on an FCQ
	Then I will see raw FCQ data