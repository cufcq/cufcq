VALID_TERMS = {1 => "Spring",4 => "Summer",7=>"Fall"}
VALID_GROUPS = ["TA", "TTT", "OTH"]
class FcqValidator < ActiveModel::Validator
  def validate(record)
    if !VALID_TERMS.has_key?(record.yearterm % 10)
      record.errors[:base] << "term is not valid! must end in 1, 4, 7 to indicate Spring, Summer and Fall respectively"
    end
    if !VALID_GROUPS.include?(record.instructor_group)
      record.errors[:base] << "instructor group is not valid! must be either TTT, TA, or OTH"
    end
  end
end

class Fcq < ActiveRecord::Base
  #Belongs to
  belongs_to :instructor
  belongs_to :course

  #validates the minimum entries are present
  validates :yearterm, :subject, :crse, :sec, :instructor_last, :instructor_first, :forms_requested, :forms_returned, :course_title, :campus, :college, :instructor_group, presence: true
  #validates entries match established patterns
  validates :yearterm, length: { is: 5}
  validates :subject, :crse, length: {is: 4}
  validates :sec, length: {maximum: 3}
  #validates instructor group is one of the specified types
  #validates :instructor_group, inclusion: { in: %w(TA, TTT, OTH)}
  #checks some more specific bits
  validates_with FcqValidator
  #validates uniqueness
  #validates :yearterm, uniqueness: true
  validates_uniqueness_of :sec, scope: [:crse, :subject, :yearterm]

  attr_reader :float_passed
  def float_passed
    return :percentage_passed.delete("%").to_f / 100
  end

  def uid
    return "#{:yearterm}#{:subject}#{:crse}#{:sec}"
  end

  def ld?
    return (:crse < 5000)
  end

  def ud?
    return (:crse >= 5000)
  end

  def year
    return yearterm / 10
  end

end
