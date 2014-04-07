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
        puts "rescued -" + e.message      
    end
      #puts params
      i = i.nil? ? Course.where(params).first : i
      i.fcqs << x  unless (i.fcqs.exists?(x))
      puts i.id + x.id
    end      
end

task :recitation_correction => :environment do
  Fcq.find_each do |x|
    begin
      if(x.recitation?)
        next
      end
      params = {"course_title" => x.course_title, "crse" => x.crse, "subject" => x.subject}
      i = Course.where(params).first
      pre = x.course_title
      x.correct_title(i.course_title)
      puts pre + " - " + x.course_title
      rescue Exception => e
        puts "rescued -" + e.message + " - " + x.course_title
    end      
  end
end
