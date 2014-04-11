class AddDepartmentIdToInstructors < ActiveRecord::Migration
  def change
  	add_column :instructors, :department_id, :integer
  end
end
