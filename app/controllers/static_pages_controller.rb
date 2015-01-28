class StaticPagesController < ApplicationController
  def home
		# the name to search for params[:search]
  	# the options (insturctors/courses/dept) params[:option]

  	# /?utf8=%E2%9C%93&option=%2Finstructors&search=george
		
		#checks if there is something in the search box, if there is it redirect to a custom url make from the option and the search params!
		if params[:search].to_s != ''
			redirect_to params[:option] + '?utf8=%E2%9C%93&search=' +  params[:search]
		end 
  end

  def help
  end

  def about
  end
end
