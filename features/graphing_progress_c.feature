Feature: View graph showing progess over time
	As the Department Head
	I want to see a graph of progress over time

Scenario: Viewing FCQ data
	Given I am on the CSCI Department Page
	Given I am on the Courses page
	Then I will see the graph show Overall
	Then I will see the graph show Prior Interest
	Then I will see the graph show Challenge
	Then I will see the graph show Amount Learned