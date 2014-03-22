#lib/tasks/import.rake
# to call, run 
require 'csv'
desc "Imports a CSV file into an ActiveRecord table"
task :import => :environment do    
    CSV.foreach('sample.csv', :headers => true) do |row|
      begin
          #puts row.to_hash
          #h = row.to_hash.select {|k,v| k == "instructor_first" || "k == instructor_last"}
          #inst = get_instructor(params)
          #inst.fcqs.create!(row.to_hash)
      puts Fcq.create!(row.to_hash)

      rescue ActiveRecord::RecordInvalid => invalid
          puts invalid.message
          next
      rescue ActiveRecord::RecordNotUnique => unique
        next
      rescue ActiveRecord::UnknownAttributeError => unknown
        puts unknown.message
        next
      end
    end
end


task :instructor_populate => :environment do
  Fcq.find_each do |x|
    begin
      params = {"instructor_first" => x.instructor_first, "instructor_last" => x.instructor_last}
      puts params
      i = Instructor.create!(params)
      rescue
      puts "rescued"
    end
      i = i.nil? ? Instructor.where(params).first : i
      i.fcqs << x  unless (i.fcqs.exists?(x))
      puts i.id + x.id
    end      
end

task :department_populate => :environment do
  Fcq.find_each do |x|
    begin
      params = {"name" => x.subject, "college" => x.college, "campus" => x.campus}
      puts params
      i = Department.create!(params)
      rescue
      puts "rescued"
     end
      i = i.nil? ? Department.where(params).first : i
      i.fcqs << x unless (i.fcqs.exists?(x))
      puts i.id + x.id
    end
end
