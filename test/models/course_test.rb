require_relative '../minitest_helper'
# rake db:test:prepare

describe Course do
  before do
    @data = {
      'course_title' => 'Intro to Test Courses',
      'subject' => 'TEST',
      'crse' => 1000
    }
    @course = Course.new(@data)
  end

  describe 'name' do
    it 'should correctly display the name' do
      assert_equal "#{@data.subject.downcase}-#{@data.crse}", @course.name
  end
end
