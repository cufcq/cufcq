task :instructor_slugs => :environment do
  Instructor.find_each do |x|
    begin
        if x.slug != nil
            puts "-"
            next
        end
        x.update_attribute(:slug, x.generate_slug)
        x.save()
        puts "slugd #{x.name}"
    rescue Exception => e

        puts "rescued - " + e.message
        puts x.name
    end
    end
end