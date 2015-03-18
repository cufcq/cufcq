# gets the set of all known activity types
task :department_correction => :environment do
  Department.find_each(:batch_size => 200) do |x|
    begin
        if x.fcqs.count == 0
            puts "destroy'd  #{x.id}"
            x.destroy
            next
        elsif x.long_name == nil
            x.update_attribute(:long_name, x.name)
            x.save()
            puts "fix'd  #{x.id}"
            next
        end
    rescue Exception => e
        puts "rescued -" + e.message
    end
    end
end

# gets the set of all known activity types
task :department_college_query => :environment do
    At = []
  Department.find_each(:batch_size => 200) do |x|
    begin
        # if (x.id % 1000) == 0
        #     puts "#{x.id}\n"
        # end
        a = x.college
        if(a == nil)
            print x.name
            print "\n"
        end
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