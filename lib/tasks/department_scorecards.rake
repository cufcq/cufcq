task :department_scorecards => :environment do
  Department.find_each do |x|
    begin
        puts x.name
        x.build_scorecards
        # puts "attribute updated"
        # x.save()
        puts "scorecard'd #{x.name}"
    rescue Exception => e

        puts "rescued - " + e.message
        
    end
    end
end