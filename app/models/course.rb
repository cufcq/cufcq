CURRENT_YEARTERM = 20147
class Course < ActiveRecord::Base
  belongs_to :department
  has_many :fcqs
  has_many :instructors, -> { distinct }, through: :fcqs


  searchable do
    text :crse
    text :subject
    text :course_title, :default_boost => 5
  end

  validates :course_title, :crse, :subject, presence: true
  validates_uniqueness_of :crse, scope: [:subject, :course_title]

  def average_prior_interest
  	self.fcqs.where.not(instructor_group: 'TA').average(:prior_interest).round(1)
  end

  def average_challenge
  	self.fcqs.where.not(instructor_group: 'TA').average(:challenge).round(1)
  end

  def average_course_overall
  	return self.fcqs.where.not(instructor_group: 'TA').average(:course_overall).round(1)
  end

  def total_hours_string
  	return self.fcqs.where.not(instructor_group: 'TA').pluck(:total_hours).mode
  end

  def average_amount_learned
  	return self.fcqs.where.not(instructor_group: 'TA').average(:amount_learned).round(1)
  end

  def total_sections_offered
  	return self.fcqs.where.not(instructor_group: 'TA').count
  end

  def total_students_enrolled
  	return self.fcqs.where.not(instructor_group: 'TA').sum(:forms_requested) 
  end

  def average_class_size
    return self.fcqs.where.not(instructor_group: 'TA').average(:forms_requested)
  end

  def instructors_sorted_by_instructor_overall
    self.instructors.sort_by(:instructor_overall)
  end

  def course_object
    %Q{#{subject} #{crse} - #{course_title}}
  end

  def overall_from_instructor(i)
    fname = i.instructor_first
    lname = i.instructor_last
    set = self.fcqs.where("instructor_first = ? AND instructor_last = ?", fname, lname)
    return set.average(:course_overall).round(1)
  end

  attr_reader :semesters, :overall_data, :challenge_data, :interest_data, :learned_data, :grade_data, :categories, :pct_a_data, :pct_b_data, :pct_c_data, :pct_d_data, :pct_f_data, :pct_i_data

  def overall_query
    overalls = self.fcqs.where.not(instructor_group: 'TA').group("yearterm").average(:course_overall)
    challenge = self.fcqs.where.not(instructor_group: 'TA').group("yearterm").average(:challenge)
    interest = self.fcqs.where.not(instructor_group: 'TA').group("yearterm").average(:prior_interest)
    learned = self.fcqs.where.not(instructor_group: 'TA').group("yearterm").average(:amount_learned)
    grade = self.fcqs.where.not(instructor_group: 'TA').group("yearterm").average(:avg_grd)
    @semesters = []
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
    #if any of the data is < 1.0, it marks it with an x marker
    puts overall_data
    #@chart_data = fixedrecords.values
    puts @chart_data
  end


  def grade_query
    pct_a = self.fcqs.where.not(instructor_group: 'TA').group("yearterm").average(:pct_a)
    pct_b = self.fcqs.where.not(instructor_group: 'TA').group("yearterm").average(:pct_b)
    pct_c = self.fcqs.where.not(instructor_group: 'TA').group("yearterm").average(:pct_c)
    pct_d = self.fcqs.where.not(instructor_group: 'TA').group("yearterm").average(:pct_d)
    pct_f = self.fcqs.where.not(instructor_group: 'TA').group("yearterm").average(:pct_f)
    pct_i = self.fcqs.where.not(instructor_group: 'TA').group("yearterm").average(:pct_incomp)
    @semesters = []
    @pct_a_data = []
    @pct_b_data = []
    @pct_c_data = []
    @pct_d_data = []
    @pct_f_data = []
    @pct_i_data = []
    pct_a.each {|k,v| @pct_a_data << [k,v.to_f.round(1)]}
    pct_b.each {|k,v| @pct_b_data << [k,v.to_f.round(1)]}
    pct_c.each {|k,v| @pct_c_data << [k,v.to_f.round(1)]}
    pct_d.each {|k,v| @pct_d_data << [k,v.to_f.round(1)]}
    pct_f.each {|k,v| @pct_f_data << [k,v.to_f.round(1)]}
    pct_i.each {|k,v| @pct_i_data << [k,v.to_f.round(1)]}
  end



end
