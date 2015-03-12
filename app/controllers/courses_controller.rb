class CoursesController < ApplicationController
  before_action :set_course, only: [:show, :edit, :update, :destroy]
  helper_method :sort_column, :sort_direction

  # GET /courses
  # GET /courses.json
  # def index
  #   if params[:search]
  #     @search = Course.search do
  #       fulltext params[:search]
  #     end
  #   @courses = @search.results
  #   else
  #      @courses = Course.all
  #   end
  # end

  def index
    @search = Course.search do
      fulltext params[:search]
      paginate :page => 1, :per_page => 30000
    end
    puts "direction by #{sort_direction}"
    puts "params are #{params[:sort]}"
    @courses = Course.where(id: @search.results.map(&:id)).page(params[:page]).per_page(10).order(sort_column + " " + sort_direction)
  end

  # GET /courses/1
  # GET /courses/1.json
  def show
  end

  # GET /courses/new
  def new
    @course = Course.new
  end

  # GET /courses/1/edit
  def edit
  end

  # POST /courses
  # POST /courses.json
  def create
    @course = Course.new(course_params)

    respond_to do |format|
      if @course.save
        format.html { redirect_to @course, notice: 'Course was successfully created.' }
        format.json { render action: 'show', status: :created, location: @course }
      else
        format.html { render action: 'new' }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /courses/1
  # PATCH/PUT /courses/1.json
  def update
    respond_to do |format|
      if @course.update(course_params)
        format.html { redirect_to @course, notice: 'Course was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /courses/1
  # DELETE /courses/1.json
  def destroy
    @course.destroy
    respond_to do |format|
      format.html { redirect_to courses_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_course
      @course = Course.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def course_params
      params.require(:course).permit(:course_title, :crse, :subject)
    end

    def sort_column
      # puts params[:sort]
      # puts Course.first.data.include?("data -> #{params[:sort]}")
      if Course.column_names.include?(params[:sort]) 
        return params[:sort]
      elsif Course.first.data.include?(params[:sort])
        return "data -> '#{params[:sort]}'"
      end
      return "course_title"
    end
    
    def sort_direction
      # puts "includes direction = " + (%w[asc desc].include?(params[:direction])).to_s
      if %w[asc desc].include?(params[:direction])
        return params[:direction]
      else
        return"asc"
      end
    end
end
