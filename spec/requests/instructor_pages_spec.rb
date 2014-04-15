require 'spec_helper'

describe "Instructor Pages" do

  subject { page }

  describe "Instructor page" do
    before { visit instructors_path }
    it { should have_content('Listing instructors') }
    it { should have_content('Instructor first') }
    it { should have_content('Instructor last') }
  end
  describe "Michael Eisenburg page" do
    before {visit instructors_path(1)}
    it { should have_content(@chart) }
    it { should have_content(@fcqs) }
    it { should have_content(@courses) }
    it { should have_content(@instructor_first) }
    it { should have_content(@instructor_last) }
  end
end