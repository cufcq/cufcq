class AddDataToDepartments < ActiveRecord::Migration
  def change
    add_column :departments, :data, :hstore
  end
end
