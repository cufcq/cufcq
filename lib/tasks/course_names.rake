
task :course_names => :environment do
    bad = ["Error!", "LAB","REC","RECITATION", nil]
  Course.find_each(:batch_size => 200) do |x|
    begin
        puts "==="
        if not bad.include? x.course_title
            next
        end
        names = x.fcqs.pluck(:course_title)
        for b in bad
            names.delete(b)
        end
        # puts names
        # puts "==="
        name = names.mode
        if bad.include? name
            puts "bad! #{x.id}"
            name = x.fcqs.first.course_title
            sleep(5.seconds)
        end
        puts name
        x.update_attribute(:course_title, name)
        x.save()
    rescue Exception => e
        puts "rescued -" + e.message
    end
    end
end

task :course_missing_hstore => :environment do
  Course.find_each(:batch_size => 200) do |x|
    begin
        puts "==="
        if x.data != nil
            next
        else
            puts "bad! #{x.id}"
            
            sleep(5.seconds)
        end
        x.update_attribute(:data, {})
        x.save()
        x.build_hstore
    rescue Exception => e
        puts "rescued -" + e.message
    end
    end
end

task :course_missing_hstore => :environment do
  Course.find_each(:batch_size => 200) do |x|
    begin
        puts "==="
        if x.data == {}
            puts "bad! #{x.id}"
            x.build_hstore
        elsif x.data != nil
            next
        else 
            puts "bad! #{x.id}"
            sleep(5.seconds)
        end
        # x.update_attribute(:data, {})
        # x.save()
        x.build_hstore
    rescue Exception => e
        puts "rescued -" + e.message
    end
    end
end