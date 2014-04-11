class CreateInstructors < ActiveRecord::Migration
  def change
    create_table :instructors do |t|
      t.string :instructor_first
      t.string :instructor_last

      t.timestamps
    end






  end
end
