require_relative '../minitest_helper'
# rake db:test:prepare

describe Instructor do
  before do
    @data = {
      'instructor_first' => 'Alejandro',
      'instructor_last' => 'Spina'
    }
    @instructor = Instructor.where(@data).first
    @department = @instructor.department
    @fcqs = @instructor.fcqs
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

  describe 'department_string' do
    it 'should return the department name if it is set' do
      assert_equal @instructor.department_string, @department.name
    end
    it 'should return the department name if it is set' do
      @instructor.department = nil
      assert_equal @instructor.department_string, '--'
    end
  end

  describe 'accessors to data methods' do
    before do
      instructor_group = @fcqs.pluck(:instr_group).mode
      @solutions = {
        'instr_group' => instructor_group,
        'ta?' => (instructor_group == 'TA') ? true : false,
        'instructor_type_string' => (instructor_group == 'TA') ? 'Teaching Assistant' : 'Instructor',
        'started_teaching' =>  @fcqs.minimum(:yearterm).to_i,
        'latest_teaching' =>  @fcqs.maximum(:yearterm).to_i,
        'average_instructoroverall' => @fcqs.average(:instructoroverall).to_f.round(1),
        'average_instreffective' => @fcqs.average(:instreffective).to_f.round(1),
        'average_instrrespect' => @fcqs.average(:instrrespect).to_f.round(1),
        'average_availability' => @fcqs.average(:availability).to_f.round(1),
        'total_requested' => @fcqs.sum(:formsrequested),
        'total_returned' => @fcqs.sum(:formsreturned),
      }
    end
    it 'instr_group' do
      assert_equal @instructor.instr_group, @solutions['instr_group']
    end
    it 'ta?' do
      assert_equal @instructor.ta?, @solutions['ta?']
    end
    it 'instructor_type_string' do
      assert_equal @instructor.instructor_type_string, @solutions['instructor_type_string']
    end
    it 'instructor_type_string' do
      assert_equal @instructor.instructor_type_string, @solutions['instructor_type_string']
    end
    it 'started_teaching' do
      assert_equal @instructor.started_teaching, @solutions['started_teaching']
    end
    it 'latest_teaching' do
      assert_equal @instructor.latest_teaching, @solutions['latest_teaching']
    end
    it 'average_instructoroverall' do
      assert_equal @instructor.average_instructoroverall, @solutions['average_instructoroverall']
    end
    it 'average_availability' do
      assert_equal @instructor.average_availability, @solutions['average_availability']
    end
    it 'average_instrrespect' do
      assert_equal @instructor.average_instrrespect, @solutions['average_instrrespect']
    end
    it 'average_instreffective' do
      assert_equal @instructor.average_instreffective, @solutions['average_instreffective']
    end
    it 'total_requested' do
      assert_equal @instructor.total_requested, @solutions['total_requested']
    end
    it 'total_returned' do
      assert_equal @instructor.total_returned, @solutions['total_returned']
    end

    describe 'failsafes' do
      before do
        @instructor.data['average_instructor_overall'] = nil
        @instructor.data['average_instructor_effectiveness'] = nil
        @instructor.data['average_instructor_respect'] = nil
        @instructor.data['average_instructor_availability'] = nil
      end

      it 'should return 0.0 for null values' do
        assert_equal @instructor.average_instructoroverall, 0.0
        assert_equal @instructor.average_availability, 0.0
        assert_equal @instructor.average_instrrespect, 0.0
        assert_equal @instructor.average_instreffective, 0.0
      end
    end
  end
end
