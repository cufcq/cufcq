class Array

	def self.mode
	self.group_by do |e|
    	e
	end.values.max_by(&:size).first
end