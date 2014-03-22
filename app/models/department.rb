class Department < ActiveRecord::Base
	has_many :instructors, through: :fcqs
	has_many :courses, through: :fcqs
	has_many :fcqs
	validates :name, :college, :campus, presence: true
	validates_uniqueness_of :name, scope: [:college, :campus]
end
