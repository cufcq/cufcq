CURRENT_YEAR = 20121
ONE_YEAR_AGO = CURRENT_YEAR - 10
TWO_YEARS_AGO = CURRENT_YEAR - 20
class Department < ActiveRecord::Base
	has_many :instructors, -> { distinct }, through: :fcqs
	has_many :courses, -> { distinct }, through: :fcqs
	has_many :fcqs, -> { distinct }

	validates :name, :college, :campus, presence: true
	validates_uniqueness_of :name, scope: [:college, :campus]


	def get_campus
		case campus
		when "BD"
			"University of Colorado Boulder"
		else
			"Error!"
		end
	end

	def get_college
		case college
		when "EN"
			"College of Engineering"
		end
	end

	attr_reader :ld_data, :ud_data, :gd_data, :io_data, :co_data, :to_data

	def overall_query
		lds = self.fcqs.where(crse: 1000..2999).group("yearterm").sum(:forms_requested)
		uds = self.fcqs.where(crse: 3000..4000).group("yearterm").sum(:forms_requested)
		gds = self.fcqs.where(crse: 5000..9999).group("yearterm").sum(:forms_requested)
		iod = self.fcqs.where.not(instructor_group: 'TA').group("yearterm").average(:instructor_overall)
		tod = self.fcqs.where(instructor_group: 'TA').group("yearterm").average(:instructor_overall)
		cod = self.fcqs.group("yearterm").average(:course_overall)
		#method defined in config/initializers/hash.rb
		uds.initialize_keys(lds,0)
		gds.initialize_keys(uds,0)
		@ld_data = []
		@ud_data = []
		@gd_data = []
		@io_data = []
		@to_data = []
		@co_data = []
		lds.each {|k,v| @ld_data << [k,v.to_f.round(1)]}
		uds.each {|k,v| @ud_data << [k,v.to_f.round(1)]}
		gds.each {|k,v| @gd_data << [k,v.to_f.round(1)]}
		iod.each {|k,v| @io_data << [k,v.to_f.round(1)]}
		tod.each {|k,v| @to_data << [k,v.to_f.round(1)]}
		cod.each {|k,v| @co_data << [k,v.to_f.round(1)]}
	end

	def average_course_overall
		return self.fcqs.average(:course_overall).round(1)
	end

	def average_instructor_overall
		return self.fcqs.average(:course_overall).round(1)
	end

	def average_student_enrollment
		return self.fcqs.group(:semterm).average(:course_overall).round(1)
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
		set = Instructor.where("instructor_first = ? AND instructor_last = ?", a[0], a[1])
		puts set
		return set.first
	end

	def instructors_count
		hash = self.fcqs.where('percentage_passed IS NOT NULL').group([:instructor_first,:instructor_last]).count
	end

	def instructors_by_courses_taught
		#taught a minimum of 3 courses
		set = self.instructors.group([:instructor_first,:instructor_last])
		#no TAs allowed
		set = set.delete_if{|x| !elligible_for_ranking(x)}
		set = set.delete_if{|x| x.instructor_group == "TA"}
		#sort by average overall
		set.sort_by{|x| x.average_instructor_overall}
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
		@instructors_rank.include?(a) ? @instructors_rank[a] : "N/A"
	end


	def course_count
		self.courses.count
	end
	def course_ld_count
		self.courses
	end
	def course_ud_count
		self.courses.where("crse = ?",3000...5000).group("crse").to_a
	end
	def course_gd_count
		self.courses.where("crse = ?",5000...10000).group("crse").to_a
	end
	def instructor_total_count
		self.instructors.count
	end
	def instructor_ta_count
		self.instructors.count
	end
	def instructor_nonta_count
		self.instructors.count
	end

	def instructor_order
		self.instructors.group([:instructor_first,:instructor_last]).order(average_instructor_overall)
	end
end
