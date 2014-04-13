class AddCorrectedCourseTitleToFcqs < ActiveRecord::Migration
  def change
    add_column :fcqs, :corrected_course_title, :string
  end
end
