When /^(?:|I )click on (.+)$/ do |page_name|
  visit path_to(page_name)
end
Then(/^I will see a list of all instructors$/) do
  Instructor.find_each do |x|
    assert page.has_xpath?('//*', :text => x.instructor_first)
  end
end

Then(/^I will see a list of all courses$/) do
  Course.find_each do |x|
    assert page.has_xpath?('//*', :text => x.crse)
  end
end

Then(/^I will see raw FCQ data$/) do
  Course.find_each do |x|
    assert page.has_xpath?('//*', :text => x.instructor_overall_SD)
  end
end

