#lib/tasks/import.rake
require 'csv'
desc "Imports a CSV file into an ActiveRecord table"
task :import => :environment do    
    CSV.foreach('sample.csv', :headers => true) do |row|
      begin
          Fcq.create!(row.to_hash)
      rescue ActiveRecord::RecordInvalid => invalid
          puts invalid.message
          next
      rescue ActiveRecord::RecordNotUnique => unique
        next
      end
    end
end
