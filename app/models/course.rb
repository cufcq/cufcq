CURRENT_YEARTERM = 20141
class Course < ActiveRecord::Base
belongs_to :department
has_many :fcqs
has_many :instructors, -> { distinct }, through: :fcqs


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

attr_reader :semesters, :overall_data, :challenge_data, :interest_data, :learned_data, :categories

def overall_query
  overalls = self.fcqs.where.not(instructor_group: 'TA').group("yearterm").average(:course_overall)
  challenge = self.fcqs.where.not(instructor_group: 'TA').group("yearterm").average(:challenge)
  interest = self.fcqs.where.not(instructor_group: 'TA').group("yearterm").average(:prior_interest)
  learned = self.fcqs.where.not(instructor_group: 'TA').group("yearterm").average(:amount_learned)
  @semesters = []
  @overall_data = []
  @challenge_data = [] 
  @interest_data = [] 
  @learned_data = [] 
  #records.each {|k,v| fixedrecords[Fcq.semterm_from_int(k)] = v.to_f.round(1)}
  overalls.each {|k,v| @overall_data << [k,v.to_f.round(1)]}
  challenge.each {|k,v| @challenge_data << [k,v.to_f.round(1)]}
  interest.each {|k,v| @interest_data << [k,v.to_f.round(1)]}
  learned.each {|k,v| @learned_data << [k,v.to_f.round(1)]}
  #if any of the data is < 1.0, it marks it with an x marker
  puts overall_data
  #@chart_data = fixedrecords.values
  puts @chart_data
end



end
