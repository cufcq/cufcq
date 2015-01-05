require 'spec_helper'

describe "FCQ Pages" do

  subject { page } 

  describe "FCQ page" do
    before { visit fcqs_path }
    it { should have_content('Listing fcqs') }
    it { should have_content('Yearterm') }
    it { should have_content('Subject') }
    it { should have_content('Crse') }
    it { should have_content('Sec') }
    it { should have_content('Instructor last') }
    it { should have_content('Instructor first') }
    it { should have_content('Forms requested') }
    it { should have_content('Forms returned') }
    it { should have_content('Percentage passed') }
    it { should have_content('Course overall') }
    it { should have_content('Course overall sd') }
    it { should have_content('Instructor overall') }
    it { should have_content('Instructor overall sd') }
    it { should have_content('Total hours') }
    it { should have_content('Prior interest') }
    it { should have_content('Effectiveness') }
    it { should have_content('Availability') }
    it { should have_content('Challenge') }
    it { should have_content('Amount learned') }
    it { should have_content('Respect') }
    it { should have_content('Course title') }
    it { should have_content('Campus') }
    it { should have_content('College') }
    it { should have_content('Instructor group') }
    it { should have_content('is recitation?') }
    it { should have_content('Corrected_Course_Title') }
  end
  describe "FCQ 148 page" do
    before {visit fcqs_path(148)}
    it { should have_content(@instructor) }
    it { should have_content(@course) }
    it { should have_content(@department) }
    it { should have_content(@yearterm) }
    it { should have_content(@crse) }
    it { should have_content(@subject) }
    it { should have_content(@sec) }
    it { should have_content(@course_title) }
    it { should have_content(@forms_requested) }
    it { should have_content(@forms_returned) }
    it { should have_content(@campus) }
    it { should have_content(@college) }
    it { should have_content(@instructor_group) }
  end
end