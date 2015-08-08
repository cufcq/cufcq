# Course Model
# Courses have many fcqs, belong to many instructors
class Course < ActiveRecord::Base
  belongs_to :department, counter_cache: true
  has_many :fcqs
  has_many :instructors, -> { distinct }, through: :fcqs, counter_cache: true
  # has_many :instructors

  searchable do
    text :crse
    text :subject
    text :course_title, :default_boost => 5
  end

  validates :course_title, :crse, :subject, presence: true
  validates_uniqueness_of :crse, scope: [:subject]
  validates :slug, uniqueness: true, presence: true
  before_validation :generate_slug

  # after_save :cache_instructor_count

  def name
    "#{subject.downcase}-#{crse}"
  end

  def to_param
    slug
  end

  def generate_slug
    return unless self.slug.nil?
    slug ||= "#{name}".parameterize
    puts "slug generated: #{slug}" unless ENV['RAILS_ENV'] == 'test'
    self.slug = slug
  end

  def scorecard
    # puts name
    scorecard = {
      :id => id,
      :name => name,
      :instructor_count => cache_instructor_count,
      :total_fcqs => total_sections_offered,
      :average_overall => average_courseoverall(3),
      :average_howmuchlearned => average_howmuchlearned(3),
      :average_challenge => average_challenge(3),
      :average_prior_interest => average_prio_interest(3),
      :slug => slug
    }
    scorecard
  end

  def cache_instructor_count
    update_attribute(:instructors_count, instructors.count)
  end

  def capitalized_title
    course_title.split.map(&:capitalize).join(' ')
  end

  def uppercase_name
    "#{subject} #{crse}"
  end

  def course_identifier
    "#{uppercase_name} - #{capitalized_title}"
  end

  def averages(rank = nil, dept = nil)
    prior = 0.0
    challenge = 0.0
    howmuchlearned = 0.0
    overall = 0.0
    count = 0
    Course.all.each do |crse|
      unless rank.nil?
        next if crse.rank_string_abridged != rank
      end
      unless dept.nil?
        next if crse.department.name != dept
      end
      count += 1
      prior += crse.average_prior_interest
      challenge += crse.average_challenge
      howmuchlearned += crse.average_howmuchlearned
      overall += crse.average_courseoverall
    end
    # count = Instructor.count || 1
    prior = (prior / count).round(1)
    challenge = (challenge / count).round(1)
    howmuchlearned = (howmuchlearned / count).round(1)
    overall = (overall / count).round(1)
    print "Average   prior int: #{prior}\n"
    print "Average   challenge: #{challenge}\n"
    print "Average muchlearned: #{howmuchlearned}\n"
    print "Average     Overall: #{overall}\n"
  end

  def json_courses
    hash = {}
    Course.all.each do |crse|
      slug = crse.slug
      next if slug.nil?
      hash[slug] = crse.scorecard
    end
    hash.to_json
  end

  def average_prior_interest(rounding = 1)
    r = data['average_prior_interest'].to_f || 0.0
    r.round(rounding)
  end

  def average_challenge(rounding = 1)
    r = data['average_challenge'].to_f || 0.0
    r.round(rounding)
  end

  def average_courseoverall(rounding = 1)
    r = data['average_course_overall'].to_f || 0.0
    r.round(rounding)
  end

  def hoursperwkinclclass_string
    data['hoursperwkinclclass'] || '--'
  end

  def average_howmuchlearned(rounding = 1)
    r = data['average_how_much_learned'].to_f || 0.0
    r.round(rounding)
  end

  def total_sections_offered
    fcqs.count
  end

  def total_students_enrolled
    fcqs.sum(:formsrequested)
  end

  def average_class_size
    fcqs.average(:formsrequested)
  end

  def course_object
    "#{subject} #{crse} - #{course_title}"
  end

  def ld?
    (crse < 3000)
  end

  def ud?
    !(ld?) && (crse < 5000)
  end

  def grad?
    (crse >= 5000)
  end

  def rank_string
    return 'Lower Division' if ld?
    return 'Upper Division' if ud?
    'Graduate Level'
  end

  def rank_string_abridged
    return 'ld' if ld?
    return 'ud' if ud?
    'gd'
  end

  attr_reader :semesters, :grade_data, :overall_data, :challenge_data, :interest_data, :learned_data, :grade_data, :categories, :pct_a_data, :pct_b_data, :pct_c_data, :pct_d_data, :pct_f_data, :pct_i_data

  def overall_query
    @overall_data = data['overall_data']
    @challenge_data = data['challenge_data']
    @interest_data = data['interest_data']
    @learned_data = data['learned_data']
    @grade_data = data['grade_data']
  end

  def grade_query
    @pct_a_data = data['pct_a_data']
    @pct_b_data = data['pct_b_data']
    @pct_c_data = data['pct_c_data']
    @pct_d_data = data['pct_d_data']
    @pct_f_data = data['pct_f_data']
    @pct_i_data = data['pct_i_data']
    @grade_data = data['grade_data']
  end

  def build_hstore
    pct_a = fcqs.order('yearterm').group('yearterm').average(:pct_a)
    pct_b = fcqs.order('yearterm').group('yearterm').average(:pct_b)
    pct_c = fcqs.order('yearterm').group('yearterm').average(:pct_c)
    pct_d = fcqs.order('yearterm').group('yearterm').average(:pct_d)
    pct_f = fcqs.order('yearterm').group('yearterm').average(:pct_f)
    pct_i = fcqs.order('yearterm').group('yearterm').average(:pct_incomp)
    grade = fcqs.order('yearterm').group('yearterm').average(:avg_grd)
    @pct_a_data = []
    @pct_b_data = []
    @pct_c_data = []
    @pct_d_data = []
    @pct_f_data = []
    @pct_i_data = []
    @grade_data = []
    pct_a.each { |k, v| @pct_a_data << [k, v.to_f.round(2)] }
    pct_b.each { |k, v| @pct_b_data << [k, v.to_f.round(2)] }
    pct_c.each { |k, v| @pct_c_data << [k, v.to_f.round(2)] }
    pct_d.each { |k, v| @pct_d_data << [k, v.to_f.round(2)] }
    pct_f.each { |k, v| @pct_f_data << [k, v.to_f.round(2)] }
    pct_i.each { |k, v| @pct_i_data << [k, v.to_f.round(2)] }
    grade.each { |k, v| @grade_data << [k, v.to_f.round(2)] }
    overalls = fcqs.order('yearterm').group('yearterm').average(:courseoverall)
    challenge = fcqs.order('yearterm').group('yearterm').average(:challenge)
    interest = fcqs.order('yearterm').group('yearterm').average(:priorinterest)
    learned = fcqs.order('yearterm').group('yearterm').average(:howmuchlearned)
    # @semesters = []
    @overall_data = []
    @challenge_data = []
    @interest_data = []
    @learned_data = []
    @grade_data = []
    overalls.each { |k, v| @overall_data << [k, v.to_f.round(1)] }
    challenge.each { |k, v| @challenge_data << [k, v.to_f.round(1)] }
    interest.each { |k, v| @interest_data << [k, v.to_f.round(1)] }
    learned.each { |k, v| @learned_data << [k, v.to_f.round(1)] }
    grade.each { |k, v| @grade_data << [k, v.to_f.round(2)] }
    # build the hstore
    data = {}
    data['pct_a_data'] = @pct_a_data
    data['pct_b_data'] = @pct_b_data
    data['pct_c_data'] = @pct_c_data
    data['pct_d_data'] = @pct_d_data
    data['pct_f_data'] = @pct_f_data
    data['pct_i_data'] = @pct_i_data
    data['overall_data'] = @overall_data
    data['challenge_data'] = @challenge_data
    data['interest_data'] = @interest_data
    data['learned_data'] = @learned_data
    data['grade_data'] = @grade_data
    r = fcqs.average(:priorinterest) || 0.0
    data['average_prior_interest'] = r.round(1)
    r = fcqs.average(:challenge) || 0.0
    data['average_challenge'] = r.round(1)
    r = fcqs.average(:courseoverall) || 0.0
    data['average_course_overall'] = r.round(1)
    r = fcqs.pluck(:hoursperwkinclclass) || [0.0]
    data['hoursperwkinclclass'] = r.mode
    r = fcqs.average(:howmuchlearned) || 0.0
    data['average_how_much_learned'] = r.round(1)
    cache_instructor_count
    self.data = data
    save
  end
end
