class Array

	def mode
		freq = self.inject(Hash.new(0)) { |h,v| h[v] += 1; h }
		return self.max_by { |v| freq[v] }
	end

  def swap(target, value)
    puts "swapping"
    r = self.find_index(target)
    if(r.nil?)
      return self
    else
      self[r] = value
      return self.swap(target, value)
    end
   end 
end
