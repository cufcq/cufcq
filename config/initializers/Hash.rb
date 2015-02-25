class Hash
	
	def initialize_keys(hash, init)
		hash.keys.each {|k| puts k; self[k] = init unless self.include?(k)}
	end

end
