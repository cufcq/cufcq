#lib/tasks/import.rake
# to call, run 
require 'csv'
#require "#{Rails.root}/app/helpers/fcqs_helper.rb"
desc "Imports a CSV file into an ActiveRecord table"
task :import => :environment do
  puts "start"
  Dir.glob('csv_make/output/*.csv').each do |csv|
    puts "loading csv file: " + csv   
    CSV.foreach(csv, :headers => true) do |row|
      begin
          #puts row.to_hash
          #h = row.to_hash.select {|k,v| k == "instructor_first" || "k == instructor_last"}
          #inst = get_instructor(params)
          #inst.fcqs.create!(row.to_hash)
      puts row.to_hash.to_s
      f = Fcq.create!(row.to_hash)
      puts f.fcq_object
      #given a new fcq object, create the instructor and course
      i_params = {"instructor_first" => f.instructor_first, "instructor_last" => f.instructor_last}
      c_params = {"course_title" => f.course_title, "crse" => f.crse, "subject" => f.subject}
      d_params = {"name" => f.subject, "college" => f.college, "campus" => f.campus}
      c = Course.where(c_params).first || Course.create!(c_params)
      i = Instructor.where(i_params).first || Instructor.create!(i_params)
      d = Department.where(d_params).first || Department.create!(d_params)
      i.fcqs << f
      c.fcqs << f
      d.fcqs << f
      c.instructors << i unless c.instructors.exists?(i)
      puts "added " + i.full_name.to_s + " to " + c.course_title.to_s
      i.courses << c unless i.courses.exists?(c)
      puts "added " + c.course_title.to_s + " to " + i.full_name.to_s
      d.instructors << i unless d.instructors.exists?(i)
      puts "added " + i.full_name.to_s + " to " + d.name.to_s
      d.courses << c unless d.courses.exists?(c)
      puts "added " + c.course_title.to_s + " to " + d.name.to_s
      
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
  puts "finish"
end
# task :import => :environment do
#   puts "start"
#   Dir.glob('csv_make/output/*.csv').each do |csv|
#     puts "loading csv file: " + csv   
#     CSV.foreach(csv, :headers => true) do |row|
#       begin
#           #puts row.to_hash
#           #h = row.to_hash.select {|k,v| k == "instructor_first" || "k == instructor_last"}
#           #inst = get_instructor(params)
#           #inst.fcqs.create!(row.to_hash)
#       f = Fcq.create!(row.to_hash)
#       puts f.fcq_object
#       rescue ActiveRecord::RecordInvalid => invalid
#           puts invalid.message
#           next
#       rescue ActiveRecord::RecordNotUnique => unique
#         next
#       rescue ActiveRecord::UnknownAttributeError => unknown
#         puts unknown.message
#         next
#       end
#     end
#   end
#   puts "finish"
# end

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
      if x.recitation?
        next
      end
      params = {"course_title" => x.course_title, "crse" => x.crse, "subject" => x.subject}
      title = x.course_title
      sec = x.sec
      i = Course.create!(params)
      rescue Exception => e
        puts "rescued -" + e.inspect     
    end
      #puts params
      i = i.nil? ? Course.where(params).first : i
      i.fcqs << x  unless (i.fcqs.exists?(x))
      puts i.id + x.id
    end 
  #recitation correction
  Fcq.find_each(:batch_size => 200) do |x|
  begin
    unless x.recitation?
      next
    end
    params = {"course_title" => x.course_title, "crse" => x.crse, "subject" => x.subject}
    i = Course.where(params).first
    if i.nil?
      next
    end
    i.fcqs << x
    puts i.id + x.id
   rescue Exception => e
     puts "rescued -" + e.inspect
   end
 end
end

task :ic_relations => :environment do
  Instructor.find_each do |i|
    begin
      puts i.instructor_last
      i.fcqs.to_a.each do |f|
        title = f.recitation? ? f.corrected_course_title : f.course_title 
        params = {"course_title" => title, "crse" => f.crse, "subject" => f.subject}
        puts params
        dep_params = {"name" => f.subject, "college" => f.college, "campus" => f.campus}
        c = Course.where(params).first
        d = Department.where(dep_params).first
        if c.nil? 
          next
        elsif d.nil?
          next
        end
        if f.course.nil?
          c.fcqs << f
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

LONG_NAMES = {"CSCI" => "Computer Science", "MATH" => "Mathematics", "PHIL" => "Philosophy", "APPM" => "Applied Mathematics", "CHEN" => "Chemical Engineering"}
task :set_department_name => :environment do
    puts "Setting Department Long Names"
    puts "For every Department code, Enter it's long name, eg"
  Department.find_each do |d|
    begin
      print d.name + ": "
      if LONG_NAMES.include?(d.name)
        Department.update(d.id, :long_name => LONG_NAMES[d.name])
        print LONG_NAMES[d.name]
        puts ""
        next
      end
      ln = STDIN.gets.chomp
      puts ""
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


task :grades => :environment do
  puts "start"
  Dir.glob('csv_make/grades/gmaster.csv').each do |csv|
    puts "loading csv file: " + csv   
    #puts Fcq.column_names
    CSV.foreach(csv, :headers => true) do |row|
      begin
          #puts row.to_hash
          #h = row.to_hash.select {|k,v| k == "instructor_first" || "k == instructor_last"}
          #inst = get_instructor(params)
          #inst.fcqs.create!(row.to_hash)
      r = row.to_hash
      # puts r.to_s
      #  puts "\n"
      #gets the fcq with the same courtitle, section, yearterm
      f_params = {"yearterm" => r["yearterm"], "subject" => r["subject"], "crse" => r["crse"], "sec" => r["sec"]}
      #puts f_params
      #puts "\n"
      #f = Fcq.create!(row.to_hash)
      #puts f.fcq_object
      f = Fcq.where(f_params).first || next
      puts f.course_title
      puts r
      f.update_attributes(r)
      f.save
      puts f.course_title
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
  puts "finish"
end


task :recitation_correction => :environment do
  Fcq.find_each do |x|
    begin
      if(!x.recitation?)
        next
      end
      params = {"crse" => x.crse, "subject" => x.subject}
      c = Course.where(params).first
      if c.nil?
        next
      end
      pre = x.course_title
      Fcq.update(x.id, :corrected_course_title => c.course_title)
      #Course.update(c.id, :corrected_course_title => x.corrected_course_title)
      puts pre.to_s + " -> " + x.corrected_course_title.to_s
    rescue Exception => e
        puts "rescued -" + e.message + " - " + x.course_title
    end     
  end

#eof
end
