class SearchController < ApplicationController
	
	def search
	  if params[:q].nil?
	    @instructors = []
	  else
	    @instructors = Instructor.search params[:q]
	  end
	end

end
