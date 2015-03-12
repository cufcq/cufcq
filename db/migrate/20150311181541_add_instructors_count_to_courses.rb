class AddInstructorsCountToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :instructors_count, :integer, default: 0
    add_column :courses, :fcqs_count, :integer, default: 0
    add_column :instructors, :courses_count, :integer, default: 0
    add_column :instructors, :fcqs_count, :integer, default: 0
    add_column :departments, :courses_count, :integer, default: 0
    add_column :departments, :fcqs_count, :integer, default: 0
    add_column :departments, :instructors_count, :integer, default: 0
  end
end
