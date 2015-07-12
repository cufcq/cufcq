require_relative '../minitest_helper'
  # rake db:test:prepare

describe Course do
  before do
    @data = {
      'course_title' => 'Intro to test courses',
      'subject' => 'TEST',
      'crse' => 1000
    }
    @course = Course.new(@data)
  end

  describe 'name, slug' do
    it 'should correctly display the name' do
      assert_equal "#{@data['subject'].downcase}-#{@data['crse']}", @course.name
    end
    it 'should correctly display the slug as the name' do
      @course.generate_slug
      assert_equal @course.name.parameterize, @course.slug
      assert_equal @course.slug, @course.to_param
    end
  end

  # describe 'ld?, ud?, grad?, rank_string, rank_string_abridged' do
  #   it 'should return true for the appropriate level, and false for others' do
  #     ld = %w(1000 1020 1099 2000 2131 2344 2999)
  #     ud = %w(3000 3020 3099 4000 4131 4344 4999)
  #     gd = %w(5000 5020 5099 6000 6131 6344 6999)
  #     ld.each do |x|
  #       puts x
  #       @course.update_attribute(:crse, x)
  #       @course.save
  #       assert_equal true, @course.ld?
  #       assert_equal false, @course.ud?
  #       assert_equal false, @course.grad?
  #       assert_equal 'Lower Division', @course.rank_string
  #       assert_equal 'ld', @course.rank_string_abridged
  #     end
  #     ud.each do |x|
  #       @course.update_attribute(:crse, x)
  #       @course.save
  #       assert_equal false, @course.ld?
  #       assert_equal true, @course.ud?
  #       assert_equal false, @course.grad?
  #       assert_equal 'Upper Division', @course.rank_string
  #       assert_equal 'ud', @course.rank_string_abridged
  #     end
  #     gd.each do |x|
  #       @course.update_attribute(:crse, x)
  #       @course.save
  #       assert_equal false, @course.ld?
  #       assert_equal false, @course.ud?
  #       assert_equal true, @course.grad?
  #       assert_equal 'Graduate Level', @course.rank_string
  #       assert_equal 'gd', @course.rank_string_abridged
  #     end
  #   end
  # end


end
