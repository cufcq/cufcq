Feature: View graph showing progess over time
	As the Department Head
	I want to see a graph of progress over time

Scenario: Viewing FCQ data
	Given I am on the CSCI Department Page
	Given I am on the Instructors page
	Then I will see the graph show Overall
	Then I will see the graph show Respect
	Then I will see the graph show Availibility
	Then I will see the graph show Effectiveness