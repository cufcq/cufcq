CURRENT_YEAR = 20141
ONE_YEAR_AGO = CURRENT_YEAR - 10
TWO_YEARS_AGO = CURRENT_YEAR - 20
class Department < ActiveRecord::Base
	# serialize :data, ActiveRecord::Coders::Hstore
	has_many :instructors, -> { distinct }
	has_many :courses, -> { distinct }
	has_many :fcqs, -> { distinct }
	self.per_page = 10
	validates :name, presence: true
	validates_uniqueness_of :name, scope: [:college, :campus]

  	searchable do
  		text :name
  		text :long_name
  	end 

  	
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
		when "AS"
			"College of Arts and Sciences"
		when "BU"
			"Leeds School of Business"
		when "MB"
			"College of Music"
		when "JR"
			"College of Journalism"
		else
			"Error! #{college}"
		end
	end

	attr_reader :ld_data, :ud_data, :gd_data, :io_data, :co_data, :to_data

	def overall_query
		@ld_data = self.data["ld_data"]
		@ud_data = self.data["ud_data"]
		@gd_data = self.data["gd_data"]
		@io_data = self.data["io_data"]
		@to_data = self.data["to_data"]
		@co_data = self.data["co_data"]
	end

	def build_hstore
		lds = self.fcqs.where(crse: 1000..2999).order("yearterm").group("yearterm").sum(:formsrequested)
		uds = self.fcqs.where(crse: 3000..4000).order("yearterm").group("yearterm").sum(:formsrequested)
		gds = self.fcqs.where(crse: 5000..9999).order("yearterm").group("yearterm").sum(:formsrequested)
		iod = self.fcqs.where.not(instr_group: 'TA').order("yearterm").group("yearterm").average(:instructoroverall)
		tod = self.fcqs.where(instr_group: 'TA').order("yearterm").group("yearterm").average(:instructoroverall)
		cod = self.fcqs.order("yearterm").group("yearterm").average(:courseoverall)
		#method defined in config/initializers/hash.rb
		uds.initialize_keys(lds,0)
		gds.initialize_keys(uds,0)
		# yearterms = gds.keys
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
		self.data = {}
		self.data['ld_data'] = @ld_data
		self.data['ud_data'] = @ud_data
		self.data['gd_data'] = @gd_data
		self.data['io_data'] = @io_data
		self.data['to_data'] = @to_data
		self.data['co_data'] = @co_data
		self.save
	end









	def average_courseoverall
		return self.fcqs.average(:courseoverall).round(1)
	end

	def average_instructoroverall
		return self.fcqs.average(:courseoverall).round(1)
	end

	def average_student_enrollment
		return self.fcqs.group(:semterm).average(:courseoverall).round(1)
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
		set = set.delete_if{|x| x.instr_group == "TA"}
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
		self.instructors.group([:instructor_first,:instructor_last]).order(average_instructoroverall)
	end
end
