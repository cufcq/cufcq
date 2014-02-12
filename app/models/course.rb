class Course < ActiveRecord::Base
has_many :fcqs
has_many :instructors, through: :fcqs
end
