class AddDataToInstructors < ActiveRecord::Migration
  def change
    add_column :instructors, :data, :hstore
  end
end
