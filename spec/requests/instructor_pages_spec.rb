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
    before {visit "/instructors/1"}
    it { should have_content('Michael Eisenburg') }
  end
end