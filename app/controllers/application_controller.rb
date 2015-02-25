class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception


 #Can we just Create and index method and pass it along to all of the other controllers via inheritence?
#   def index
#     if params[:search] and (params[:option] == 1)
#       @search = Course.search do
#         fulltext params[:search]
#       end
#     @courses = @search.results
#     else
#        @courses = Course.all
#     end
#   end

end
