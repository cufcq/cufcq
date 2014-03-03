VALID_TERMS = {1 => "Spring",4 => "Summer",7=>"Fall"}
VALID_GROUPS = ["TA", "TTT", "OTH"]
class FcqValidator < ActiveModel::Validator
  def validate(record)
    key = record.yearterm || 0
    puts key
    key %= 10
    if !VALID_TERMS.has_key?(key)
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
  validates_uniqueness_of :sec, scope: [:crse, :subject, :yearterm, :instructor_last, :instructor_first]

  def float_passed
    passed = self.percentage_passed || "-100%"
    return (passed.chop.to_f) / 100
    #return 0.99
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
    return :yearterm / 10
  end

  attr_reader :semterm
  def semterm
    return (VALID_TERMS[:yearterm % 10] + year.to_S)
  end

  def self.semterm_from_int(s)
    return (VALID_TERMS[s % 10] + " " + (s/10).to_s)
  end


  def bad?
    return (:forms_returned < 1)
  end

end
