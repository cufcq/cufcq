# gets the set of all known activity types
task :department_college_query => :environment do
    At = []
  Department.find_each(:batch_size => 200) do |x|
    begin
        # if (x.id % 1000) == 0
        #     puts "#{x.id}\n"
        # end
        a = x.college
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