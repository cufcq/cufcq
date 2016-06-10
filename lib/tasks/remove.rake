task :remove => :environment do
  Instructor.where(instructor_last: 'Ballipinar').destroy_all
end
