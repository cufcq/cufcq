
task :reset_counters => :environment do
    puts "resetting Department counters"
    count = 0
    Department.find_each(:batch_size => 200) do |x|
        begin
            Department.reset_counters(x.id, :instructors)
            Department.reset_counters(x.id, :courses)
            Department.reset_counters(x.id, :fcqs)
            count += 1
            if (count % 100) == 0
                print "#{count} finished\n"
            end
        rescue Exception => e
            puts "rescued -" + e.message
        end
    end
    puts "resetting Course counters"
    count = 0
    Course.find_each(:batch_size => 200) do |x|
        begin
            Course.reset_counters(x.id, :instructors)
            Course.reset_counters(x.id, :fcqs)
            count += 1
            if (count % 100) == 0
                print "#{count} finished\n"
            end
        rescue Exception => e
            puts "rescued -" + e.message
        end
    end
    puts "resetting Instructor counters"
    count = 0
    Instructor.find_each(:batch_size => 200) do |x|
        begin
            Instructor.reset_counters(x.id, :courses)
            Instructor.reset_counters(x.id, :fcqs)
            count += 1
            if (count % 100) == 0
                print "#{count} finished\n"
            end
        rescue Exception => e
            puts "rescued -" + e.message
        end
    end

end