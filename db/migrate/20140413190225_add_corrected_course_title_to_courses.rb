class AddCorrectedCourseTitleToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :corrected_course_title, :string
  end
end
