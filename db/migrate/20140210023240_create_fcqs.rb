class CreateFcqs < ActiveRecord::Migration
  def change
    create_table :fcqs do |t|
      t.integer :yearterm
      t.string :subject
      t.integer :crse
      t.integer :sec
      t.string :instructor_last
      t.string :instructor_first
      t.integer :formsrequested
      t.integer :formsReturned
      t.string :courseOverallPctValid
      t.float :courseOverall
      t.float :courseOverall_SD
      t.float :instructorOverall
      t.float :instructorOverall_SD
      t.string :hoursPerWkInclClass
      t.float :priorInterest
      t.float :instrEffective
      t.float :availability
      t.float :challenge
      t.float :howMuchLearned
      t.float :instrRespect
      t.string :crsTitle
      t.string :campus
      t.string :college
      t.string :instr_Group

      t.timestamps
    end
  end
end
