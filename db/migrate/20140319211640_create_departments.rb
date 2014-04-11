class CreateDepartments < ActiveRecord::Migration
  def change
    create_table :departments do |t|
      t.string :name
      t.string :college
      t.string :campus
      t.string :long_name
      t.timestamps
    end
  end
end
