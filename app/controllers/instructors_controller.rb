class InstructorsController < ApplicationController
  before_action :set_instructor, only: [:show, :edit, :update, :destroy]
  helper_method :sort_column, :sort_direction
  # GET /instructors
  # GET /instructors.json

  # def index
  #   if params[:search] != ''
  #     @search = Instructor.search do
  #       fulltext params[:search]
  #     end
  #     @instructors = @search.results
  #   else 
  #     @instructors = Instructor.all
  #   end
  # end

  def index
    @search = Instructor.search do
      fulltext params[:search]
      paginate :page => 1, :per_page => 30000
    end
    @instructors = Instructor.where(id: @search.results.map(&:id)).page(params[:page]).per_page(10).order(sort_column + " " + sort_direction)
    # @instructors = @search.results
    # @instructors = Instructor.where(id: @search.results.map(&:id)).page(params[:page]).per_page(10).order('instructor_last ASC')
    # @instructors = Instructor.where(:id => @search.result_ids).page(params[:page]).per_page(10).order('instructor_last ASC')
  end

  # GET /instructors/1
  # GET /instructors/1.json
  def show    
  end

  # GET /instructors/new
  def new
    @instructor = Instructor.new
  end

  # GET /instructors/1/edit
  def edit
  end

  # POST /instructors
  # POST /instructors.json
  def create
    @instructor = Instructor.new(instructor_params)

    respond_to do |format|
      if @instructor.save
        format.html { redirect_to @instructor, notice: 'Instructor was successfully created.' }
        format.json { render action: 'show', status: :created, location: @instructor }
      else
        format.html { render action: 'new' }
        format.json { render json: @instructor.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /instructors/1
  # PATCH/PUT /instructors/1.json
  def update
    respond_to do |format|
      if @instructor.update(instructor_params)
        format.html { redirect_to @instructor, notice: 'Instructor was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @instructor.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /instructors/1
  # DELETE /instructors/1.json
  def destroy
    @instructor.destroy
    respond_to do |format|
      format.html { redirect_to instructors_url }
      format.json { head :no_content }
    end
  end

  attr_reader :chart
  def test_chart
    @chart = Instructor.test_chart
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_instructor
      @instructor = Instructor.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def instructor_params
      params.require(:instructor).permit(:instructor_first, :instructor_last)
    end

    def sort_column
      # puts params[:sort]
      # puts Course.first.data.include?("data -> #{params[:sort]}")
      if Instructor.column_names.include?(params[:sort]) 
        return params[:sort]
      elsif Instructor.first.data.include?(params[:sort])
        return "data -> '#{params[:sort]}'"
      end
      return "instructor_last"
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
