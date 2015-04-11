class AddSlugToInstructors < ActiveRecord::Migration
  def change
    add_column :instructors, :slug, :string
    add_index :instructors, :slug
  end
end
