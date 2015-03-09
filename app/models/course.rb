CURRENT_YEARTERM = 20147
class Course < ActiveRecord::Base
  belongs_to :department
  has_many :fcqs
  has_many :instructors, -> { distinct }, through: :fcqs
  # has_many :instructors

  searchable do
    text :crse
    text :subject
    text :course_title, :default_boost => 5
  end

  validates :course_title, :crse, :subject, presence: true
  validates_uniqueness_of :crse, scope: [:subject, :course_title]

  def capitalized_title
    return course_title.split.map(&:capitalize).join(' ')
  end

  def course_identifier
    "#{subject} #{crse} - #{capitalized_title}"
  end

  def average_priorinterest
  	# self.fcqs.where.not(instr_group: 'TA').average(:priorinterest).round(1)
    # self.fcqs.average(:priorinterest).round(1)
    return self.data['average_prior_interest'].to_f
  end

  def average_challenge
  	# self.fcqs.where.not(instr_group: 'TA').average(:challenge).round(1)
    # self.fcqs.average(:challenge).round(1)
    return self.data['average_challenge'].to_f
  end

  def average_courseoverall
  	# return self.fcqs.where.not(instr_group: 'TA').average(:courseoverall).round(1)
    # return self.fcqs.average(:courseoverall).round(1)
    return self.data['average_course_overall'].to_f
  end

  def hoursperwkinclclass_string
  	# return self.fcqs.where.not(instr_group: 'TA').pluck(:hoursperwkinclclass).mode
    return self.data['hoursperwkinclclass']
  end

  def average_howmuchlearned
  	# return self.fcqs.where.not(instr_group: 'TA').average(:howmuchlearned).round(1)
    return self.data['how_much_learned'].to_f
  end

  def total_sections_offered
  	# return self.fcqs.where.not(instr_group: 'TA').count
    return self.fcqs.count
  end

  def total_students_enrolled
  	# return self.fcqs.where.not(instr_group: 'TA').sum(:formsrequested) 
    return self.fcqs.sum(:formsrequested) 
  end

  def average_class_size
    return self.fcqs.average(:formsrequested)
  end

  def instructors_sorted_by_instructoroverall
    self.instructors.sort_by(:instructoroverall)
  end

  def course_object
    %Q{#{subject} #{crse} - #{course_title}}
  end

  def overall_from_instructor(i)
    fname = i.instructor_first
    lname = i.instructor_last
    set = self.fcqs.where("instructor_first = ? AND instructor_last = ?", fname, lname)
    return set.average(:courseoverall).round(1)
  end

  def ld?
    return (crse < 3000)
  end

  def ud?
    return !(self.ld?) && (crse < 5000)
  end

  def grad?
    return (crse >= 5000)
  end

  def rank_string
    if ld?
      return "Lower Division"
    elsif ud?
      return "Upper Division"
    else
      return "Graduate Level"
    end
  end

  attr_reader :semesters, :grade_data, :overall_data, :challenge_data, :interest_data, :learned_data, :grade_data, :categories, :pct_a_data, :pct_b_data, :pct_c_data, :pct_d_data, :pct_f_data, :pct_i_data

  def overall_query
    @overall_data = self.data['overall_data']
    @challenge_data = self.data['challenge_data']
    @interest_data = self.data['interest_data']
    @learned_data = self.data['learned_data']
    @grade_data = self.data['grade_data']
  end


  def grade_query
    @pct_a_data = self.data['pct_a_data']
    @pct_b_data = self.data['pct_b_data']
    @pct_c_data = self.data['pct_c_data']
    @pct_d_data = self.data['pct_d_data']
    @pct_f_data = self.data['pct_f_data']
    @pct_i_data = self.data['pct_i_data']
    @grade_data = self.data['grade_data']
  end

  def build_hstore
    pct_a = self.fcqs.order("yearterm").group("yearterm").average(:pct_a)
    pct_b = self.fcqs.order("yearterm").group("yearterm").average(:pct_b)
    pct_c = self.fcqs.order("yearterm").group("yearterm").average(:pct_c)
    pct_d = self.fcqs.order("yearterm").group("yearterm").average(:pct_d)
    pct_f = self.fcqs.order("yearterm").group("yearterm").average(:pct_f)
    pct_i = self.fcqs.order("yearterm").group("yearterm").average(:pct_incomp)
    grade = self.fcqs.order("yearterm").group("yearterm").average(:avg_grd)
    # @semesters = []
    @pct_a_data = []
    @pct_b_data = []
    @pct_c_data = []
    @pct_d_data = []
    @pct_f_data = []
    @pct_i_data = []
    @grade_data = []
    pct_a.each {|k,v| @pct_a_data << [k,v.to_f.round(2)]}
    pct_b.each {|k,v| @pct_b_data << [k,v.to_f.round(2)]}
    pct_c.each {|k,v| @pct_c_data << [k,v.to_f.round(2)]}
    pct_d.each {|k,v| @pct_d_data << [k,v.to_f.round(2)]}
    pct_f.each {|k,v| @pct_f_data << [k,v.to_f.round(2)]}
    pct_i.each {|k,v| @pct_i_data << [k,v.to_f.round(2)]}
    grade.each {|k,v| @grade_data << [k,v.to_f.round(2)]}
    overalls = self.fcqs.order("yearterm").group("yearterm").average(:courseoverall)
    challenge = self.fcqs.order("yearterm").group("yearterm").average(:challenge)
    interest = self.fcqs.order("yearterm").group("yearterm").average(:priorinterest)
    learned = self.fcqs.order("yearterm").group("yearterm").average(:howmuchlearned)
    # @semesters = []
    @overall_data = []
    @challenge_data = [] 
    @interest_data = [] 
    @learned_data = []
    @grade_data = [] 
    #records.each {|k,v| fixedrecords[Fcq.semterm_from_int(k)] = v.to_f.round(1)}
    overalls.each {|k,v| @overall_data << [k,v.to_f.round(1)]}
    challenge.each {|k,v| @challenge_data << [k,v.to_f.round(1)]}
    interest.each {|k,v| @interest_data << [k,v.to_f.round(1)]}
    learned.each {|k,v| @learned_data << [k,v.to_f.round(1)]}
    grade.each {|k,v| @grade_data << [k,v.to_f.round(2)]}
    # build the hstore
    self.data = {}
    self.data['pct_a_data'] = @pct_a_data
    self.data['pct_b_data'] = @pct_b_data
    self.data['pct_c_data'] = @pct_c_data
    self.data['pct_d_data'] = @pct_d_data
    self.data['pct_f_data'] = @pct_f_data
    self.data['pct_i_data'] = @pct_i_data
    self.data['overall_data'] = @overall_data
    self.data['challenge_data'] = @challenge_data 
    self.data['interest_data'] = @interest_data
    self.data['learned_data'] = @learned_data
    self.data['grade_data'] = @grade_data

    self.data['average_prior_interest'] = self.fcqs.average(:priorinterest).round(1)

    self.data['average_challenge'] = self.fcqs.average(:challenge).round(1)

    self.data['average_course_overall'] = self.fcqs.average(:courseoverall).round(1)

    self.data['hoursperwkinclclass'] = self.fcqs.pluck(:hoursperwkinclclass).mode

    self.data['how_much_learned'] = self.fcqs.average(:howmuchlearned).round(1)
    self.save
  end


end
