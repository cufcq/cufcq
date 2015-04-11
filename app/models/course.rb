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
    return "#{self.subject}-#{self.crse}"
  end

  def to_param
    slug
  end

  def generate_slug
    # puts "generating slug!"
    # puts "#{self.instructor_last.titleize}, #{self.instructor_first.titleize}".parameterize
    self.slug ||= "#{self.name}".parameterize
    # puts "slug generated"
    return self.slug
  end

  def scorecard
    scorecard = {
      :average_overall => self.average_courseoverall, 
      :average_howmuchlearned => self.average_howmuchlearned, 
      :average_challenge => self.average_challenge,
      :average_priorinterest => self.average_priorinterest
    }
    return scorecard
  end

  def cache_instructor_count
    self.update_attribute(:instructors_count, self.instructors.count)
  end

  def capitalized_title
    return course_title.split.map(&:capitalize).join(' ')
  end

  def course_identifier
    "#{subject} #{crse} - #{capitalized_title}"
  end

  def self.averages(rank = nil, dept = nil)
    prior = 0.0
    challenge = 0.0
    howmuchlearned = 0.0
    overall = 0.0
    count = 0
    Course.all.each do |crse|
      if rank != nil
        if crse.abbv_rank_string != rank
          next
        end
      end
      if dept != nil
        if crse.department.name != dept
          next
        end
      end
      count += 1
      prior += crse.average_priorinterest
      challenge += crse.average_challenge
      howmuchlearned += crse.average_howmuchlearned
      overall += crse.average_courseoverall
    end
    # count = Instructor.count || 1
    prior = (prior / count ).round(1)
    challenge = (challenge / count ).round(1)
    howmuchlearned = (howmuchlearned / count ).round(1)
    overall = (overall / count ).round(1)
    print "Average   prior int: #{prior}\n"
    print "Average   challenge: #{challenge}\n"
    print "Average muchlearned: #{howmuchlearned}\n"
    print "Average     Overall: #{overall}\n"
  end


  def average_priorinterest
  	# self.fcqs.where.not(instr_group: 'TA').average(:priorinterest).round(1)
    # self.fcqs.average(:priorinterest).round(1)
    
    r = self.data['average_prior_interest'] || 0.0
    return r.to_f
  end

  def average_challenge
  	# self.fcqs.where.not(instr_group: 'TA').average(:challenge).round(1)
    # self.fcqs.average(:challenge).round(1)
    
    r = self.data['average_challenge'] || 0.0
    return r.to_f
  end

  def average_courseoverall
  	# return self.fcqs.where.not(instr_group: 'TA').average(:courseoverall).round(1)
    # return self.fcqs.average(:courseoverall).round(1)
    
    r = self.data['average_course_overall'] || 0.0
    return r.to_f
  end

  def hoursperwkinclclass_string
  	# return self.fcqs.where.not(instr_group: 'TA').pluck(:hoursperwkinclclass).mode
    return self.data['hoursperwkinclclass'] || "--"
  end

  def average_howmuchlearned
  	# return self.fcqs.where.not(instr_group: 'TA').average(:howmuchlearned).round(1)
    
    r = self.data['average_how_much_learned'] || 0.0
    return r.to_f
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

  def abbv_rank_string
    if ld?
      return "ld"
    elsif ud?
      return "ud"
    else
      return "gd"
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
    r = self.fcqs.average(:priorinterest) || 0.0
    self.data['average_prior_interest'] = r.round(1)
    r = self.fcqs.average(:challenge) || 0.0
    self.data['average_challenge'] = r.round(1)
    r = self.fcqs.average(:courseoverall) || 0.0
    self.data['average_course_overall'] = r.round(1)
    r = self.fcqs.pluck(:hoursperwkinclclass) || [0.0]
    self.data['hoursperwkinclclass'] = r.mode
    r = self.fcqs.average(:howmuchlearned) || 0.0
    self.data['average_how_much_learned'] = r.round(1)
    cache_instructor_count
    self.save
  end


end
