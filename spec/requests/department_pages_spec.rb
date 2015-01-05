require 'spec_helper'

describe "Department Pages" do

  subject { page }
  #this is the subject that we are looking for 
  #page looks at elements on the page. 
  
  describe "Departments page" do
  #title doesn't matter 
    before { visit '/departments/' }
    #goes to url 
    it { should have_content('Listing departments') }
    it { should have_content('Name') }
    #should have content just searches plain html for the string 
    it { should have_content('College') }
    it { should have_content('Campus') }
    #things we should check on page 
  end
  describe "CSCI page" do
    before {visit departments_path(1)}
    it { should have_content(@instructors) }
    it { should have_content(@courses) }
    it { should have_content(@fcqs) }
    it { should have_content(@name) }
    it { should have_content(@college) }
    it { should have_content(@campus) }
  end
end
