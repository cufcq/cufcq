class AddSlugToDepartments < ActiveRecord::Migration
  def change
    add_column :departments, :slug, :string
    add_index :departments, :slug
  end
end
