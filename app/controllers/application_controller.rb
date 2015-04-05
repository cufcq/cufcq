class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  # before_filter :prepare_for_mobile

# private

#     def mobile_device?
#       if session[:mobile_param]
#         session[:mobile_param] == "1"
#       else
#         request.user_agent =~ /Mobile|webOS/
#       end
#     end
#     helper_method :mobile_device?
    
#     def prepare_for_mobile
#       # session[:mobile_param] = params[:mobile] if params[:mobile]
#       # request.format = :mobile if mobile_device?
#     end

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
