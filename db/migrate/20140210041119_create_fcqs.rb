class CreateFcqs < ActiveRecord::Migration
  def change

    create_table :fcqs do |t|
      t.belongs_to :instructor
      t.belongs_to :course
      t.belongs_to :department
      t.integer  :yearterm
    t.string   :subject
    t.integer  :crse
    t.integer  :sec
    t.string   :onlineFCQ
    t.string   :bd_continuing_education
    t.string   :instructor_last
    t.string   :instructor_first
    t.integer  :forms_requested
    t.integer  :forms_returned
    t.float    :percentage_passed
    t.float    :course_overall
    t.float    :course_overall_SD
    t.float    :instructor_overall
    t.float    :instructor_overall_SD
    t.string   :total_hours
    t.float    :prior_interest
    t.float    :effectiveness
    t.float    :availability
    t.float    :challenge
    t.float    :amount_learned
    t.float    :respect
    t.string   :course_title
    t.string   :courseOverall_old
    t.string   :courseOverall_SD_old
    t.string   :instrOverall_old
    t.string   :instrOverall_SD_old
    t.string   :r_Fair
    t.string   :r_Access
    t.string   :workload
    t.string   :r_Divstu
    t.string   :r_Diviss
    t.string   :r_Presnt
    t.string   :r_Explan
    t.string   :r_Assign
    t.string   :r_Motiv
    t.string   :r_Learn
    t.string   :r_Complx
    t.string   :campus
    t.string   :college
    t.string   :aSdiv
    t.string   :level
    t.string   :fcqdept
    t.string   :instructor_group
    t.integer  :i_Num
      
      t.timestamps
    end
    add_index :fcqs, [:instructor_first, :instructor_last]
    add_index :fcqs, [:course_title]
  end
end
