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
  belongs_to :department
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
    return "#{yearterm}#{subject}#{crse}#{sec}"
  end

  def title
    if recitation?
      return "#{capitalized_title}-REC"
    else
      return capitalized_title
    end
  end

  def capitalized_title
    return course_title.split.map(&:capitalize).join(' ')
  end

  def correct_title(title)
    course_title = title
  end

  def recitation?
    if (course_title == "REC" || course_title == "RECITATION")
      return true
    elsif (sec == 1 || sec == 10 || sec == 100)
      return false
    else 
      return true
    end
  end

  def ld?
    return (crse < 3000)
  end

  def ud?
    return !(self.ld?) && (crse < 5000)
  end

  def grad?
    return (crse >= 5000)
  end

  def rank_string
    if ld?
      return "Lower Division"
    elsif ud?
      return "Upper Division"
    else
      return "Graduate Level"
    end
  end


  def year
    return yearterm / 10
  end

  attr_reader :semterm
  def semterm
    return (VALID_TERMS[yearterm % 10] + " " + year.to_s)
  end

  def self.semterm_from_int(s)
    return (VALID_TERMS[s % 10] + " " + (s/10).to_s)
  end

  def bad?
    return (forms_returned < 1)
  end

  def color
    if ld?
      return "box1"
    elsif ud?
      return "box2"
    else
      return "box3"
    end
  end

  def fcq_object
    #return %Q{#{semterm} | #{subject} #{crse}-#{sec} | #{title} | #{instructor_first} #{instructor_last}}
    return %Q{#{semterm} #{subject} #{crse}-#{sec} #{title}}
  end

  def fcq_header
    #return %Q{#{semterm} | #{subject} #{crse}-#{sec} | #{title} | #{instructor_first} #{instructor_last}}
    return "#{subject} #{crse}-#{sec}"
  end

  def img_file
    if ld?
      return "fcq_64_ld.png"
    elsif ud?
      return "fcq_64_ud.png"
    else
      return "fcq_64_gd.png"
    end
  end

  def requested_returned_string
    "#{forms_returned} / #{forms_requested}"
  end

  def instructor_full_name
    "#{instructor_first} #{instructor_last}"
  end

end
