class Array

	def mode
		freq = self.inject(Hash.new(0)) { |h,v| h[v] += 1; h }
		return self.max_by { |v| freq[v] }
	end
end