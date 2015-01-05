require 'spec_helper'

describe "Static pages" do

  subject { page }

  describe "Home page" do
    before { visit root_path }

    it { should have_content('Faculty-Course Questionaires made easy') }
    it { should have_content('Search by class') }
    it { should have_content('Search by Instructor') }
    it { should_not have_title('| Home') }
  end

  describe "Help page" do
    before { visit help_path }

    it { should have_content('Help') }
    it { should have_content('This is a website designed to help you find everything about CU teachers and courses, and their past track records.')}
  end

  describe "About page" do
    before { visit about_path }

    it { should have_content('About') }
    it { should have_content('Alex Tsankov-Sophomore at CU Boulder-Computer Science Major-Philosophy Minor') }
    it { should have_content('Sam Volin-Sophomore at CU Boulder-Computer Science Major-Math Minor') }
    it { should have_content('Cris Salazar-Sophomore at CU Boulder-Computer Science Major-Economics Minor') }
  end
end