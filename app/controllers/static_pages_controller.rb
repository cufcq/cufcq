class StaticPagesController < ApplicationController
  def home
 	if params[:search].include? "instructor"
      puts "YYYYYYYYYYYY " + params[:search]
    end
  end

  def help
  end

  def about
  end
end
