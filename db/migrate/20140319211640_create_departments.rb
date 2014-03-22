class CreateDepartments < ActiveRecord::Migration
  def change
    create_table :departments do |t|
      t.string :name
      t.string :college
      t.string :campus

      t.timestamps
    end
  end
end
