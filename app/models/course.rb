class Course < ActiveRecord::Base
has_many :fcqs
has_many :instructors, through: :fcqs
has_many :department, through: :fcqs

validates :course_title, :crse, :subject, presence: true
validates_uniqueness_of :crse, scope: [:subject, :course_title]
end
