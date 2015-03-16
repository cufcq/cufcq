task :recitation_correction => :environment do
  Fcq.find_each(:batch_size => 200) do |x|
    begin
        puts "==="
        if not x.recitation?
            next
        end
        if x.activity_type == "REC"
            next
        end
        x.update_attribute(:activity_type, "REC")
        x.save()
        puts "fix'd  #{x.id}"
    rescue Exception => e
        puts "rescued -" + e.message
    end
    end
end

# gets the set of all known activity types
task :activity_type_query => :environment do
    At = []
  Fcq.find_each(:batch_size => 200) do |x|
    begin
        if (x.id % 1000) == 0
            puts "#{x.id}\n"
        end
        a = x.activity_type
        if not At.include? a
            At << a
        else
            next
        end
    rescue Exception => e
        puts "rescued -" + e.message
    end
    end
    puts At
end