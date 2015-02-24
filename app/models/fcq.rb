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
    if !VALID_GROUPS.include?(record.instr_group)
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
  validates :yearterm, :subject, :crse, :sec, :instructor_last, :instructor_first, :formsrequested, :formsreturned, :campus, :college, :instr_group, presence: true
  #validates entries match established patterns
  validates :yearterm, length: { is: 5}
  validates :subject, :crse, length: {is: 4}
  validates :sec, length: {maximum: 3}
  #validates instructor group is one of the specified types
  #validates :instr_group, inclusion: { in: %w(TA, TTT, OTH)}
  #checks some more specific bits
  validates_with FcqValidator
  #validates uniqueness
  #validates :yearterm, uniqueness: true
  validates_uniqueness_of :sec, scope: [:crse, :subject, :yearterm, :instructor_last, :instructor_first]


  def pass_rate
    return percentage_passed_string
  end

  #changed to accomodate fcq v0.2
  def float_passed
    #passed = self.percentage_passed || "-100%"
    #return (passed.chop.to_f) / 100
    #return 0.99
    fp = percentage_passed || 0.0
    return fp
  end

  def percentage_passed_string
  val = (float_passed * 100).round(0)
  val = [val, 100].min
  val = [val, 0].max
  string = val.round
  return "#{string}%"
end 

  def uid
    return "#{yearterm}#{subject}#{crse}#{sec}"
  end

  def title
    if recitation?
      return corrected_course_title
    else
      return capitalized_title
    end
  end

  def capitalized_title
    return course_title.split.map(&:capitalize).join(' ')
  end

  def correct_title(title)
    write_attribute(:corrected_course_title, title)
  end

  def recitation?
    if (course_title == "REC" || course_title == "RECITATION")
      return true
    elsif instr_group == "TA"
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

  def rank_string_abridged
    if ld?
      return "ld"
    elsif ud?
      return "ud"
    else
      return "gd"
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
    return "#{crse}-#{sec}"
  end

  #THIS IS DEPRICATED, USED IN OLD FCQ program (DELETE ME)
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

  # def grade_query
  #   overalls = self.fcqs.where.not(instr_group: 'TA').group("yearterm").average(:course_overall)
  #   challenge = self.fcqs.where.not(instr_group: 'TA').group("yearterm").average(:challenge)
  #   interest = self.fcqs.where.not(instr_group: 'TA').group("yearterm").average(:prior_interest)
  #   learned = self.fcqs.where.not(instr_group: 'TA').group("yearterm").average(:amount_learned)
  #   @semesters = []
  #   @overall_data = []
  #   @challenge_data = [] 
  #   @interest_data = [] 
  #   @learned_data = [] 
  #   #records.each {|k,v| fixedrecords[Fcq.semterm_from_int(k)] = v.to_f.round(1)}
  #   overalls.each {|k,v| @overall_data << [k,v.to_f.round(1)]}
  #   challenge.each {|k,v| @challenge_data << [k,v.to_f.round(1)]}
  #   interest.each {|k,v| @interest_data << [k,v.to_f.round(1)]}
  #   learned.each {|k,v| @learned_data << [k,v.to_f.round(1)]}
  #   #if any of the data is < 1.0, it marks it with an x marker
  #   puts overall_data
  #   #@chart_data = fixedrecords.values
  #   puts @chart_data
  # end

end
