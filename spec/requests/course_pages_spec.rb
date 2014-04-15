require 'spec_helper'

describe "Course Pages" do

  subject { page }
  #this is the subject that we are looking for 
  #page looks at elements on the page. 
  
  describe "Courses page" do
  #title doesn't matter 
    before { visit courses_path }
    #goes to url 
    it { should have_content('Listing courses') }
    it { should have_content('Course title') }
    #should have content just searches plain html for the string 
    it { should have_content('Crse') }
    it { should have_content('Subject') }
    #things we should check on page 
  end
  describe "Courses page" do
    before {visit "/courses/1"}
    it { should have_content('Discrete Structures') }
  end
end
