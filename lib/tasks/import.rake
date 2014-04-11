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
      f = Fcq.create!(row.to_hash)
      puts f.fcq_object
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

task :drop_tables => :environment do
  drop_table :departments
  drop_table :instructors
  drop_table :courses
end


task :department_populate => :environment do
  Fcq.find_each(:batch_size => 200) do |x|
    begin
      params = {"name" => x.subject, "college" => x.college, "campus" => x.campus}
      i = Department.create!(params)

      puts i
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
  Fcq.find_each(:batch_size => 200) do |x|
    begin
      params = {"instructor_first" => x.instructor_first, "instructor_last" => x.instructor_last}
      i = Instructor.create!(params)
      puts i
      rescue Exception => e
        puts "rescued -" + e.message
    end
      i = i.nil? ? Instructor.where(params).first : i
      i.fcqs << x  unless (i.fcqs.exists?(x))
      puts i.id + x.id
    end      
end

task :course_populate => :environment do
  Fcq.find_each(:batch_size => 200) do |x|
    begin
      params = {"course_title" => x.course_title, "crse" => x.crse, "subject" => x.subject}
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
        if c.nil? 
          next
        elsif d.nil?
          next
        end

        c.instructors << i unless c.instructors.exists?(i)
        puts "added " + i.full_name.to_s + " to " + c.course_title.to_s
        i.courses << c unless i.courses.exists?(c)
        puts "added " + c.course_title.to_s + " to " + i.full_name.to_s
        d.instructors << i unless d.instructors.exists?(i)
        puts "added " + i.full_name.to_s + " to " + d.name.to_s
        d.courses << c unless d.courses.exists?(c)
        puts "added " + c.course_title.to_s + " to " + d.name.to_s

        puts c.course_title.to_s + " <-> " + i.full_name.to_s
      end
      #puts c.instructors

      rescue ActiveRecord::RecordInvalid => e
        #puts "skipping invalid record, this is intentional"
      rescue ActiveRecord::AssociationTypeMismatch => e
        puts "association mismatch error, this means courses are having a hard time being found/associated. This is bad"
      #end
      rescue Exception => e
        puts "rescued -" + e.inspect
      end
    end     
end


task :set_department_name => :environment do
    puts "Setting Department Long Names"
    puts "For every Department code, Enter it's long name, eg"
  Department.find_each do |d|
    begin
      print d.name + ": "
      ln = STDIN.gets.chomp
      #puts d.update_attribute(:long_name, ln)
      
      Department.update(d.id, :long_name => ln)
      #puts d.long_name
      rescue Exception => e
        puts "rescued -" + e.message
     end
     puts "finished"
    end
  Department.find_each do |d|
      puts d.long_name
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
