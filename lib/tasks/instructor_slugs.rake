task :instructor_slugs => :environment do
  Instructor.find_each(:batch_size => 200) do |x|
    begin
        if x.slug != nil
            puts "-"
            next
        end
        x.update_attribute(:slug, x.generate_slug)
        x.save()
        puts "slugd #{x.name}"
    rescue Exception => e
        puts "rescued -" + e.message
    end
    end
end