IG_TTT = 'Tenured or tenure-track instructor'
IG_OTH = 'Other primary instructor, such as adjunct, visiting, honorarium, etc.'
IG_TA = 'Teaching_Assistant'

# Instructor Model
# Instructors have many fcqs, belong to many courses
class Instructor < ActiveRecord::Base
  self.per_page = 10

  searchable do
    string :instructor_first
    string :instructor_last
    text :instructor_first
    text :instructor_last, :default_boost => 2
  end
  # handle_asynchronously :solr_index # works like a charm with delayed_job

  belongs_to :department, counter_cache: true
  has_many :fcqs
  # has_many :courses
  has_many :courses, -> { distinct }, through: :fcqs, counter_cache: true

  validates_uniqueness_of :instructor_first, scope: [:instructor_last]
  # added code creates an alternate custom route for accessing our instructors by name
  validates :slug, uniqueness: true, presence: true
  before_validation :generate_slug

  def to_param
    slug
  end

  def generate_slug
    return unless self.slug.nil?
    slug ||= "#{instructor_last.titleize}-#{instructor_first.titleize}".parameterize
    puts "slug generated: #{slug}" unless ENV['RAILS_ENV'] == 'test'
    self.slug = slug
  end

  def scorecard
    scorecard = {
      :id => id,
      :name => name,
      :first_semester => started_teaching,
      :latest_semester => latest_teaching,
      :department => department_string,
      :courses_taught => courses_count,
      :total_fcqs => fcqs_count,
      :requested_returned_ratio => requested_returned_ratio(3),
      :instructor_group => instr_group,
      :average_overall => average_instructoroverall(3),
      :average_respect => average_instrrespect(3),
      :average_availability => average_availability(3),
      :average_effectiveness => average_instreffective(3),
      :slug => slug
    }
    return scorecard
  end

  def self.scorecards(instr_group = nil, dept = nil)
    arr = []
    Instructor.all.each do |instr|
      if instr_group != nil
        if instr.instr_group != instr_group
          next
        end
      end
      if dept != nil
        if instr.department.name != dept
          next
        end
      end
      arr << instr.scorecard
    end
    arr
  end

  def cache_course_count
    update_attribute(:courses_count, courses.count)
  end

  def name
    "#{instructor_last.titleize}, #{instructor_first.titleize}"
  end

  def full_name
    name.split.map(&:capitalize).join(' ')
  end

  def instructor_object
    %(#{college})
  end

  def campus
    department.campus
  end

  def department_string
    return '--' if department.nil?
    department.name
  end

  def instr_group
    data['instructor_group'] || 'TTT'
  end

  def ta?
    (instr_group == 'TA') ? true : false
  end

  def instructor_type_string
    ta? ? 'Teaching Assistant' : 'Instructor'
  end

  def overall_from_course(c)
    subject = c.subject
    crse = c.crse
    set = fcqs.where('subject = ? AND crse = ?', subject, crse)
    set.average(:instructoroverall).round(1)
  end

  def started_teaching
    data['earliest_class'].to_i
  end

  def latest_teaching
    data['latest_class'].to_i
  end

  def average_instrrespect(rounding = 1)
    x = data['average_instructor_respect'].to_f || 0.0
    x.round(rounding)
  end

  def self.averages(instr_group = nil, dept = nil)
    availability = 0.0
    respect = 0.0
    effectiveness = 0.0
    overall = 0.0
    count = 0
    Instructor.all.each do |instr|

      unless instr_group.nil?
        next if instr.instr_group != instr_group
      end
      unless dept.nil?
        next if instr.department.name != dept
      end
      count += 1
      respect += instr.average_instrrespect
      availability += instr.average_availability
      effectiveness += instr.average_instreffective
      overall += instr.average_instructoroverall
    end
    # count = Instructor.count || 1
    respect = (respect / count).round(1)
    availability = (availability / count).round(1)
    effectiveness = (effectiveness / count).round(1)
    overall = (overall / count).round(1)
    print "Average Respect: #{respect}\n"
    print "Average Availab: #{availability}\n"
    print "Average Effectv: #{effectiveness}\n"
    print "Average Overall: #{overall}\n"
  end


  # def self.json_instructors
  #   hash = {}
  #   Instructor.all.each do |instr|
  #     slug = instr.slug
  #     if slug == nil
  #       next
  #     end
  #     hash[slug] = instr.scorecard
  #   end
  #   return hash
  # end

  def average_availability(rounding  = 1)
    x = data['average_instructor_availability'].to_f || 0.0
    x.round(rounding)
  end

  def average_instreffective(rounding = 1)
    x = data['average_instructor_effectiveness'].to_f || 0.0
    x.round(rounding)
  end

  def total_requested
    fcqs.sum(:formsrequested) || 0
  end

  def total_returned
    fcqs.sum(:formsreturned) || 1
  end

  def requested_returned_ratio(rounding = 2)
    (total_returned.to_f / total_requested.to_f).round(rounding)
  end

  def average_instructoroverall(rounding = 1)
    overall = data['average_instructor_overall'].to_f || 0.0
    overall.round(rounding)
  end

  def courses_taught
    count = (data['courses_taught']).to_i
    [count, 1].max
  end

  attr_reader :semesters, :overall_data, :availability_data, :instrrespect_data, :instreffective_data, :overall_average, :availability_average, :instrrespect_average, :instreffective_average

  ########################################
  # This is where we use the grade csv   #
  ########################################

  def average_percentage_passed_float

    data['average_percent_passed'].to_f
  end

  def compute_average_percentage_passed
    total = 0.0
    fcqs.compact.each { |x| next if x.float_passed < 0.0 ; total += x.float_passed }
    count = fcqs.count
    return 1.0 if count == 0
    (total.to_f / count.to_f)
  end

  def pass_rate_string
    pp = average_percentage_passed_float || 0.0
    val = (pp * 100).round(1)
    val = [val, 100].min
    val = [val, 0].max
    string = val.round
    "#{string}%"
  end

  # these take the avg grades of all classes taught by a prof and avg them
  def average_grade_overall
    data['average_grade']
  end

  # these take the avg grades of all classes taught by a prof and avg them
  def compute_average_grade
    total = 0.0
    fcqs.compact.each { |x| next if x.avg_grd.nil? ; total += x.avg_grd }
    count = fcqs.count
    return 1.0 if count == 0
    (total.to_f / count.to_f)
  end

  # #################End grades.csv stuff#####################
  def overall_query
    @overall_data = data['overall_data']
    @availability_data = data['availability_data']
    @instreffective_data = data['instreffective_data']
    @instrrespect_data = data['instrrespect_data']
    @overall_average = department.data['average_instructoroverall']
    @availability_average = department.data['average_availability']
    @instrrespect_average = department.data['average_instrrespect']
    @instreffective_average = department.data['average_instreffective']
  end

  def build_hstore
    self.department = fcqs.pluck(:department).mode
    overalls = fcqs.order('yearterm').group('yearterm').average(:instructoroverall)
    avails = fcqs.order('yearterm').group('yearterm').average(:availability)
    effects = fcqs.order('yearterm').group('yearterm').average(:instreffective)
    instrrespects = fcqs.order('yearterm').group('yearterm').average(:instrrespect)
    @semesters = []
    @overall_data = []
    @availability_data = []
    @instrrespect_data = []
    @instreffective_data = []

    #records.each {|k,v| fixedrecords[Fcq.semterm_from_int(k)] = v.to_f.round(1)}
    overalls.each { |k, v| @overall_data << [k, v.to_f.round(1)] }
    avails.each { |k, v| @availability_data << [k, v.to_f.round(1)] }
    effects.each { |k, v| @instreffective_data << [k, v.to_f.round(1)] }
    instrrespects.each { |k, v| @instrrespect_data << [k, v.to_f.round(1)] }

    data = {}
    data['overall_data'] = @overall_data
    data['availability_data'] = @availability_data
    data['instreffective_data'] = @instreffective_data
    data['instrrespect_data'] = @instrrespect_data
    data['courses_taught'] = fcqs.count
    data['average_grade'] = compute_average_grade
    data['average_percent_passed'] = compute_average_percentage_passed
    data['average_instructor_overall'] = fcqs.average(:instructoroverall)
    data['average_instructor_effectiveness'] = fcqs.average(:instreffective)
    data['average_instructor_respect'] = fcqs.average(:instrrespect)
    data['average_instructor_availability'] = fcqs.average(:availability)
    data['latest_class'] = fcqs.maximum(:yearterm)
    data['earliest_class'] = fcqs.minimum(:yearterm)
    data['instructor_group'] = fcqs.pluck(:instr_group).mode
    self.data = data
    cache_course_count
    save
  end

  def instr_group_flavor_text
    case instr_group
    when 'TTT'
      return IG_TTT
    when 'OTH'
      return IG_OTH
    when 'TA'
      return IG_TA
    end
  end

  def color
    return 'box6' if ta?
    'box4'
  end
end
