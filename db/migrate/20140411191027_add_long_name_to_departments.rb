class AddLongNameToDepartments < ActiveRecord::Migration
  def change
    add_column :departments, :long_name, :string
  end
end
