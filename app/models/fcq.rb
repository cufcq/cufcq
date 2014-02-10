class Fcq < ActiveRecord::Base
	validates :yearterm, length {is: 5}
	validates :subject, length {is: 4}
	validates :crse, length {is: 4}
	validates :sec, length {maximum:  3} 
	validates :yearterm, :subject, :crse, :sec, :instructor_last, :instructor_first, :formsRequested, :formsReturned, :crsTitle, :campus, :college, :instr_Group, presence: true
	def collected?
		if(:formsReturned == 0)
			return false
		else
			return true
		end			
	end
end
