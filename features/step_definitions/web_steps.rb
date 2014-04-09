Then /^(?:|I )will see \/([^\/]*)\/$/ do |regexp|
  regexp = Regexp.new(regexp)

  if page.respond_to? :should
    page.should have_xpath('//*', :text => regexp)
  else
    assert page.has_xpath?('//*', :text => regexp)
  end
end

Given(/^that I am on the Department page$/) do
  visit path_to(home) # express the regexp above with the code you wish you had
end

When(/^I click on Courses$/) do
  visit path_to(Courses) # express the regexp above with the code you wish you had
end

Then(/^I will see all Courses$/) do
  pending # express the regexp above with the code you wish you had
end

When(/^I click on Instructors$/) do
  visit path_to(Instructors) # express the regexp above with the code you wish you had
end

Then(/^I will see all Instructors$/) do
  pending # express the regexp above with the code you wish you had
end

Given(/^that I am on CSCI (\d+) page$/) do |arg1|
  visit path_to(@course.index(arg1)) # express the regexp above with the code you wish you had
end

When(/^I click on a Overall Instructor$/) do
  click_button(Overall) # express the regexp above with the code you wish you had
end

Then(/^I will see the graph of the overall Instructor score for each Instructor$/) do
  pending # express the regexp above with the code you wish you had
end

Given(/^that I am on John Black page$/) do
  visit path_to(@Instructors.index("John Black")) # express the regexp above with the code you wish you had
end

When(/^I click on Grad classes$/) do
  click_button(Graduate) # express the regexp above with the code you wish you had
end

Then(/^I will see only data from Grad classes$/) do
  pending # express the regexp above with the code you wish you had
end

When(/^I click on Overall$/) do
  click_button(Overall)# express the regexp above with the code you wish you had
end

Then(/^I will see the graph of the overall course score$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^I will see the graph of the overall Instructor score$/) do
  pending # express the regexp above with the code you wish you had
end

When(/^I click on FCQ data$/) do
  click_button(FCQ) # express the regexp above with the code you wish you had
end

Then(/^I will see the raw FCQ data$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^will take me to the raw FCQ page$/) do
  pending # express the regexp above with the code you wish you had
end


