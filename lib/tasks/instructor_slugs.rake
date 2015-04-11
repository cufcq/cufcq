task :instructor_slugs => :environment do
  Instructor.find_each do |x|
    begin
        puts x.name
        if x.slug != nil
            puts "skipped"
            next
        end
        x.update_column(:slug, x.generate_slug)
        puts "attribute updated"
        x.save()
        puts "slugd #{x.name}"
    rescue Exception => e

        puts "rescued - " + e.message
        
    end
    end
end