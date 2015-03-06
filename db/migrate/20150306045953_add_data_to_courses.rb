class AddDataToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :data, :hstore
  end
end
