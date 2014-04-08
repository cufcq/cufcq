class Course < ActiveRecord::Base
has_many :fcqs
has_many :instructors, through: :fcqs
has_many :department, through: :fcqs

validates :course_title, :crse, :subject, presence: true
validates_uniqueness_of :crse, scope: [:subject, :course_title]

def average_prior_interest
	self.fcqs.average(:prior_interest).round(1)
end

def average_challenge
	self.fcqs.average(:challenge).round(1)
end

def average_course_overall
	return self.fcqs.average(:course_overall).round(1)
end

def total_hours_string
	return self.fcqs.pluck(:total_hours).mode
end

def average_amount_learned
	return self.fcqs.average(:amount_learned).round(1)
end

def total_sections_offered
	return self.fcqs.count
end

def total_students_enrolled
	return self.fcqs.sum(:forms_requested) 
end

attr_reader :semesters, :overall_data, :challenge_data, :interest_data, :learned_data, :categories

def overall_query
  overalls = self.fcqs.group("yearterm").average(:course_overall)
  challenge = self.fcqs.group("yearterm").average(:challenge)
  interest = self.fcqs.group("yearterm").average(:prior_interest)
  learned = self.fcqs.group("yearterm").average(:amount_learned)
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
  overall_data.swap(0.0, "{
                    y: 0.0,
                    marker: {
                        symbol: \"url(http://hakenberg.de/_images/icon.red.gif)\"
                    }
                }")
  puts overall_data
  #@chart_data = fixedrecords.values
  puts @chart_data
end



end
