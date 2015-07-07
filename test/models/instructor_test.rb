require_relative '../minitest_helper'
  # rake db:test:prepare

describe Instructor do
  before do
    @data = {
      'instructor_first' => 'Alejandro',
      'instructor_last' => 'Spina'
    }
    @instructor = Instructor.new(@data)
  end

  describe 'name, slug' do
    it 'should correctly display the name' do
      assert_equal "#{@data['instructor_last']}, #{@data['instructor_first']}", @instructor.name
    end
    it 'should correctly display the slug as the name' do
      @instructor.generate_slug
      assert_equal @instructor.name.parameterize, @instructor.slug
      assert_equal @instructor.slug, @instructor.to_param
    end
  end
end
