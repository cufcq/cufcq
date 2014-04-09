#lib/tasks/import.rake
# to call, run 
require 'csv'
#require "#{Rails.root}/app/helpers/fcqs_helper.rb"
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




task :department_populate => :environment do
  Fcq.find_each do |x|
    begin
      params = {"name" => x.subject, "college" => x.college, "campus" => x.campus}
      puts params
      i = Department.create!(params)
      rescue Exception => e
        puts "rescued -" + e.message
     end
      i = i.nil? ? Department.where(params).first : i
      #puts i
      i.fcqs << x unless (i.fcqs.exists?(x))
      puts i.id + x.id
    end
end

task :instructor_populate => :environment do
  Fcq.find_each do |x|
    begin
      params = {"instructor_first" => x.instructor_first, "instructor_last" => x.instructor_last}
      puts params
      i = Instructor.create!(params)
      rescue Exception => e
        puts "rescued -" + e.message
    end
      i = i.nil? ? Instructor.where(params).first : i
      i.fcqs << x  unless (i.fcqs.exists?(x))
      puts i.id + x.id
    end      
end

task :course_populate => :environment do
  Fcq.find_each do |x|
    begin
      params = {"course_title" => x.course_title, "crse" => x.crse, "subject" => x.subject}
      puts params
      title = x.course_title
      sec = x.sec
      if x.recitation?
        next
      end
      i = Course.create!(params)
      rescue Exception => e
        puts "rescued -" + e.inspect     
    end
      #puts params
      i = i.nil? ? Course.where(params).first : i
      i.fcqs << x  unless (i.fcqs.exists?(x))
      puts i.id + x.id
    end      
end

task :ic_relations => :environment do
  Instructor.find_each do |i|
    begin
      puts i.instructor_last
      i.fcqs.to_a.each do |f|

        params = {"course_title" => f.course_title, "crse" => f.crse, "subject" => f.subject}
        dep_params = {"name" => f.subject, "college" => f.college, "campus" => f.campus}

        c = Course.where(params).first
        d = Department.where(dep_params).first
        
        c.instructors << i unless c.instructors.exists?(i)
        i.courses << c unless i.courses.exists?(c)
        puts d.class
        d.instructors << i unless d.instructors.exists?(i)

        c.departments << d unless c.departments.exists(d)
        i.departments << d unless i.departments.exists(d)
        d.courses << c unless d.instructors.exists?(c)

        puts c.course_title.to_s + " <-> " + i.full_name.to_s
      end
      #puts c.instructors

      rescue ActiveRecord::RecordInvalid => e
        puts "skipping invalid record, this is intentional"
        next
      rescue ActiveRecord::AssociationTypeMismatch => e
        puts "association mismatch error, this means courses are having a hard time being found/associated. This is bad"
      rescue Exception => e
        puts "rescued -" + e.inspect
        puts __LINE__
      end
    end     
end


task :recitation_correction => :environment do
  Fcq.find_each do |x|
    begin
      if(!x.recitation?)
        next
      end
      params = {"crse" => x.crse, "subject" => x.subject}
      i = Course.where(params).first
      puts i.course_title
      pre = x.course_title
      x.correct_title(i.course_title)
      puts pre + " -> " + x.course_title
    rescue Exception => e
        puts "rescued -" + e.message + " - " + x.course_title
    end     
  end

#eof
end
