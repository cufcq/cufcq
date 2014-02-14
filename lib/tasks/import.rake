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

def get_instructor(params)
  begin
    return Instructor.create!(params)
  rescue ActiveRecord::RecordNotUnique => unique
    return Instructor.where(instructor_first: h["instructor_first"], instructor_last: h["instructor_last"])
  rescue e
    puts e.message
    return nil
  end
end



task :instructor_populate => :environment do
  Fcq.find_each do |x|
    begin
      params = {"instructor_first" => x.instructor_first, "instructor_last" => x.instructor_last}
      puts params
      i = Instructor.create!(params)
      #puts i
      puts insert(i, x)
      rescue ActiveRecord::RecordInvalid => invalid
        #puts invalid.message
      rescue ActiveRecord::RecordNotUnique => unique
        puts "skip!" + params
        i = Instructor.where({instructor_first: x.instructor_first, instructor_last: x.instructor_last})
        puts insert(i, x)
        next
      rescue
      end
    end
end

def insert(inst, fcq)
  if(inst.fcqs.exists?(fcq))
    return inst
  else
    inst.fcqs << fcq
    return inst
  end
end
