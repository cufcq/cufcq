CURRENT_YEAR = 20151
ONE_YEAR_AGO = CURRENT_YEAR - 10
TWO_YEARS_AGO = CURRENT_YEAR - 20

# Department Model
# Departments have many instructors, courses , fcqs
class Department < ActiveRecord::Base
  # serialize :data, ActiveRecord::Coders::Hstore
  has_many :instructors, -> { distinct }
  has_many :courses, -> { distinct }
  has_many :fcqs, -> { distinct }
  self.per_page = 10
  validates :name, presence: true
  validates_uniqueness_of :name, scope: [:college, :campus]
  validates :slug, uniqueness: true, presence: true
  # testing to see if comments integrate with git
  # testing this new line
  before_validation :generate_slug
  searchable do
    text :name
    text :long_name
  end

  def to_param
    slug
  end

  def generate_slug
    slug ||= "#{name}".parameterize
    puts 'slug generated'
    self.slug = slug
  end

  def instructor_scorecards
    data['instructors_json'] || build_instructor_scorecards.to_json
  end

  def build_instructor_scorecards
    arr = []
    instructors.each do |instr|
      arr << instr.scorecard
    end
    arr
  end

  def course_scorecards
    data['courses_json'] || build_course_scorecards.to_json
  end

  def build_course_scorecards
    arr = []
    courses.each do |course|
      arr << course.scorecard
    end
    arr
  end


  def cache_update_counts
    update_attribute(:instructors_count, instructors.count)
    update_attribute(:courses_count, courses.count)
    update_attribute(:fcqs_count, fcqs.count)
  end

  def get_campus
    case campus
    when 'BD'
      'University of Colorado Boulder'
    else
      'Error!'
    end
  end

  def get_college
    case college
    when 'EN'
      'College of Engineering'
    when 'AS'
      'College of Arts and Sciences'
    when 'BU'
      'Leeds School of Business'
    when 'MB'
      'College of Music'
    when 'JR'
      'College of Journalism'
    when 'XX'
      'Army ROTC'
    when 'LW'
      'School of Law'
    when 'EB'
      'School of Education'
    else
      '--'
    end
  end

  attr_reader :ld_data, :ud_data, :gd_data, :io_data, :co_data, :to_data

  def overall_query
    @ld_data = data['ld_data']
    @ud_data = data['ud_data']
    @gd_data = data['gd_data']
    @io_data = data['io_data']
    @to_data = data['to_data']
    @co_data = data['co_data']
  end

  def build_hstore
    lds = fcqs.where(crse: 1000..2999).order('yearterm').group('yearterm').sum(:formsrequested)
    uds = fcqs.where(crse: 3000..4000).order('yearterm').group('yearterm').sum(:formsrequested)
    gds = fcqs.where(crse: 5000..9999).order('yearterm').group('yearterm').sum(:formsrequested)
    iod = fcqs.where.not(instr_group: 'TA').order('yearterm').group('yearterm').average(:instructoroverall)
    tod = fcqs.where(instr_group: 'TA').order('yearterm').group('yearterm').average(:instructoroverall)
    cod = fcqs.order('yearterm').group('yearterm').average(:courseoverall)
    #method defined in config/initializers/hash.rb
    uds.initialize_keys(lds, 0)
    gds.initialize_keys(uds, 0)
    # yearterms = gds.keys
    @ld_data = []
    @ud_data = []
    @gd_data = []
    @io_data = []
    @to_data = []
    @co_data = []
    lds.each { |k, v| @ld_data << [k, v.to_f.round(1)] }
    uds.each { |k, v| @ud_data << [k, v.to_f.round(1)] }
    gds.each { |k, v| @gd_data << [k, v.to_f.round(1)] }
    iod.each { |k, v| @io_data << [k, v.to_f.round(1)] }
    tod.each { |k, v| @to_data << [k, v.to_f.round(1)] }
    cod.each { |k, v| @co_data << [k, v.to_f.round(1)] }
    data = {}
    data['ld_data'] = @ld_data
    data['ud_data'] = @ud_data
    data['gd_data'] = @gd_data
    data['io_data'] = @io_data
    data['to_data'] = @to_data
    data['co_data'] = @co_data
    build_averages
    build_scorecards
    cache_update_counts
    save
  end

  def build_averages
    data['average_TTT_instructoroverall'] = fcqs.where(:instr_group == 'TTT').average(:instructoroverall)
    data['average_OTH_instructoroverall'] = fcqs.where(:instr_group == 'OTH').average(:instructoroverall)
    data['average_TA_instructoroverall'] = fcqs.where(:instr_group == 'TA').average(:instructoroverall)
    data['average_instructoroverall'] = fcqs.average(:instructoroverall)
    data['average_courseoverall'] = fcqs.average(:courseoverall)
    data['average_instreffective'] = fcqs.average(:instrrespect)
    data['average_availability'] = fcqs.average(:instrrespect)
    data['average_instrrespect'] = fcqs.average(:instrrespect)
    save
  end

  def build_scorecards
    # flag data as volatile
    data_will_change!
    data['instructors_json'] = build_instructor_scorecards.to_json
    data['courses_json'] = build_course_scorecards.to_json
    save
  end


  def average_courseoverall
    return fcqs.average(:courseoverall).round(1)
  end

  def average_instructoroverall
    return fcqs.average(:courseoverall).round(1)
  end

  def average_student_enrollment
    return fcqs.group(:semterm).average(:courseoverall).round(1)
  end

  def elligible_for_ranking(i)
    if (i.is_TA)
      if(i.fcqs.maximum(:yearterm) < ONE_YEAR_AGO)
        return false
      elsif(i.fcqs.count < 3)
        return false
      else
        return true
      end
    else
      if(i.fcqs.maximum(:yearterm) < TWO_YEARS_AGO)
        return false
      elsif(i.fcqs.count < 5)
        return false
      else
        return true
      end
    end
  end

  def get_instructor(a)
    set = Instructor.where('instructor_first = ? AND instructor_last = ?', a[0], a[1])
    puts set
    set.first
  end

  def instructors_count
    hash = self.fcqs.group([:instructor_first,:instructor_last]).count
  end

  def instructors_by_courses_taught
    #taught a minimum of 3 courses
    set = self.instructors.group([:instructor_first,:instructor_last])
    #no TAs allowed
    set = set.delete_if{|x| !elligible_for_ranking(x)}
    set = set.delete_if{|x| x.instr_group == 'TA'}
    #sort by average overall
    set.sort_by{|x| x.average_instructoroverall}
  end

  def set_rank
    ibct = instructors_by_courses_taught
    result = Hash.new
    s = ibct.length
    i = 0
    ibct.each {|k,v| result[k] = s - i; i+=1}
    @instructors_rank = result
  end

  #returns an instructors rank when passing in the i value
  def instructor_rank(i)
    instructor_rank(i.fname,i.lname)
  end

  #returns an instructors rank when passing in a fname,lname
  def instructor_rank(fname,lname)
    a = [fname,lname]
    @instructors_rank.include?(a) ? @instructors_rank[a] : 'N/A'
  end


  def course_count
    courses.count
  end

  def course_ld_count
    courses
  end

  def course_ud_count
    courses.where('crse = ?',3000...5000).group('crse').to_a
  end

  def course_gd_count
    courses.where('crse = ?',5000...10000).group('crse').to_a
  end

  def instructor_total_count
    instructors.count
  end

  def instructor_ta_count
    instructors.count
  end

  def instructor_nonta_count
    instructors.count
  end

  def instructor_order
    instructors.group([:instructor_first, :instructor_last]).order(average_instructoroverall)
  end
end
