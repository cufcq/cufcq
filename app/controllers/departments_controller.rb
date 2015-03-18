class DepartmentsController < ApplicationController
  before_action :set_department, only: [:show, :edit, :update, :destroy]
  helper_method :sort_column, :sort_direction
  # GET /departments
  # GET /departments.json
  # def index
  #   @departments = Department.all
  # end



  # def index
  #   @search = Department.search do
  #     fulltext params[:search]
  #     paginate :page => 1, :per_page => 1000
  #   end
  #   @departments = Department.where(id: @search.results.map(&:id)).page(params[:page]).per_page(10).order(sort_column + " " + sort_direction)
  # end
  def index
    page = params[:page] || 1
    @search = Department.search do
      fulltext params[:search]
      # order_by(sort_column , sort_direction)
      paginate :page => page, :per_page => 10
    end
    @departments = @search.results
  end

  # def index
  #   if params[:search] != ''
  #     puts "#{params[:search]}"
  #     @search = Department.search do
  #       fulltext params[:search]
  #       paginate :page => 2, :per_page => 10
  #     end
  #     @departments = @search.results
  #   else 
  #     @departments = Department.paginate :page => params[:page], :per_page => 10, :order => 'name ASC'
  #   end
  # end

  # GET /departments/1
  # GET /departments/1.json
  def show
  end

  # GET /departments/new
  def new
    @department = Department.new
  end

  # GET /departments/1/edit
  def edit
  end

  # POST /departments
  # POST /departments.json
  def create
    @department = Department.new(department_params)

    respond_to do |format|
      if @department.save
        format.html { redirect_to @department, notice: 'Department was successfully created.' }
        format.json { render action: 'show', status: :created, location: @department }
      else
        format.html { render action: 'new' }
        format.json { render json: @department.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /departments/1
  # PATCH/PUT /departments/1.json
  def update
    respond_to do |format|
      if @department.update(department_params)
        format.html { redirect_to @department, notice: 'Department was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @department.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /departments/1
  # DELETE /departments/1.json
  def destroy
    @department.destroy
    respond_to do |format|
      format.html { redirect_to departments_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_department
      @department = Department.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def department_params
      params.require(:department).permit(:name, :college, :campus, :long_name)
    end

    def sort_column
      Course.column_names.include?(params[:sort]) ? params[:sort] : "name"
    end
    
    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
    end
end
