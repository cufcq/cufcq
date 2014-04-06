class Department < ActiveRecord::Base
	has_many :instructors, through: :fcqs
	has_many :courses, through: :fcqs
	has_many :fcqs
	validates :name, :college, :campus, presence: true
	validates_uniqueness_of :name, scope: [:college, :campus]

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
		set = instructors_count.delete_if{|k,v| v < 3}
		#no TAs allowed
		set = set.delete_if{|k,v| get_instructor(k).is_TA}
		#sort by average overall
		set.sort_by{|k,v| get_instructor(k).average_instructor_overall}
	end

	def set_rank
		ibct = instructors_by_courses_taught
		result = Hash.new
		s = ibct.length
		i = 0
		ibct.each {|k,v| result[k] = s - i; i+=1}
		@instructors_rank = result
	end

	def instructor_rank(fname,lname),
		a = [fname,lname]
		@instructors_rank.include?(a) ? @instructors_rank[a] : "N/A"
	end


	def course_count
		self.fcqs.where('percentage_passed IS NOT NULL').group([:crse]).count.sort_by{|k,v| v}
	end

	def instructor_order
		self.instructors.group([:instructor_first,:instructor_last]).order(average_instructor_overall)
	end
end
