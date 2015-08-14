require_relative '../minitest_helper'
# rake db:test:prepare

describe Course do
  before do
    @data = {
      'course_title' => 'Intro to test courses',
      'subject' => 'TEST',
      'crse' => 1000
    }
    @course = Course.where(@data).first
    @department = @course.department
    @fcqs = @course.fcqs
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

  describe 'ld?, ud?, grad?, rank_string, rank_string_abridged' do
    it 'should return true for the appropriate level, and false for others' do
      ld = %w(1000 1020 1099 2000 2131 2344 2999)
      ud = %w(3000 3020 3099 4000 4131 4344 4999)
      gd = %w(5000 5020 5099 6000 6131 6344 6999)
      ld.each do |x|
        @course.attributes = { crse: x }
        assert_equal true, @course.ld?
        assert_equal false, @course.ud?
        assert_equal false, @course.grad?
        assert_equal 'Lower Division', @course.rank_string
        assert_equal 'ld', @course.rank_string_abridged
      end
      ud.each do |x|
        @course.attributes = { crse: x }
        assert_equal false, @course.ld?
        assert_equal true, @course.ud?
        assert_equal false, @course.grad?
        assert_equal 'Upper Division', @course.rank_string
        assert_equal 'ud', @course.rank_string_abridged
      end
      gd.each do |x|
        @course.attributes = { crse: x }
        assert_equal false, @course.ld?
        assert_equal false, @course.ud?
        assert_equal true, @course.grad?
        assert_equal 'Graduate Level', @course.rank_string
        assert_equal 'gd', @course.rank_string_abridged
      end
    end
  end

  describe 'accessors to data methods' do
    before do
      instructor_group = @fcqs.pluck(:instr_group).mode
      @solutions = {
        'total_students_enrolled' => @fcqs.sum(:formsrequested),
        'average_class_size' => @fcqs.average(:formsrequested),
        'total_sections_offered' => @fcqs.count,
        'average_prior_interest' =>  @fcqs.average(:priorinterest).to_f.round(1),
        'average_howmuchlearned' =>  @fcqs.average(:howmuchlearned).to_f.round(1),
        'average_challenge' =>  @fcqs.average(:challenge).to_f.round(1),
        'average_courseoverall' =>  @fcqs.average(:courseoverall).to_f.round(1),
        'hoursperwkinclclass_string' =>  @fcqs.pluck(:hoursperwkinclclass).mode,
      }
    end
    it 'total_students_enrolled' do
      assert_equal @course.total_students_enrolled, @solutions['total_students_enrolled']
    end
    it 'average_class_size' do
      assert_equal @course.average_class_size, @solutions['average_class_size']
    end
    it 'total_sections_offered' do
      assert_equal @course.total_sections_offered, @solutions['total_sections_offered']
    end
    it 'average_prior_interest' do
      assert_equal @course.average_prior_interest, @solutions['average_prior_interest']
    end
    it 'average_howmuchlearned' do
      assert_equal @course.average_howmuchlearned, @solutions['average_howmuchlearned']
    end
    it 'average_challenge' do
      assert_equal @course.average_challenge, @solutions['average_challenge']
    end
    it 'average_courseoverall' do
      assert_equal @course.average_courseoverall, @solutions['average_courseoverall']
    end
    it 'hoursperwkinclclass_string' do
      assert_equal @course.hoursperwkinclclass_string, @solutions['hoursperwkinclclass_string']
    end
  end

  describe 'failsafes' do
    before do
      @course.data['average_prior_interest'] = nil
      @course.data['average_challenge'] = nil
      @course.data['average_course_overall'] = nil
      @course.data['average_how_much_learned'] = nil
      @course.data['hoursperwkinclclass'] = nil
    end

    it 'should return 0.0 for null values' do
      assert_equal @course.average_prior_interest, 0.0
      assert_equal @course.average_howmuchlearned, 0.0
      assert_equal @course.average_challenge, 0.0
      assert_equal @course.average_courseoverall, 0.0
      assert_equal @course.hoursperwkinclclass_string, '--'
    end
  end
end
