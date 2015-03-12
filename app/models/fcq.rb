VALID_TERMS = {1 => "Spring",4 => "Summer",7=>"Fall"}
VALID_GROUPS = ["TA", "TTT", "OTH"]
class FcqValidator < ActiveModel::Validator
  def validate(record)
    key = record.yearterm || 0
    # puts key
    key %= 10
    if !VALID_TERMS.has_key?(key)
      record.errors[:base] << "term is not valid! must end in 1, 4, 7 to indicate Spring, Summer and Fall instrrespectively"
    end
    if !VALID_GROUPS.include?(record.instr_group)
      record.errors[:base] << "instructor group is not valid! must be either TTT, TA, or OTH"
    end
  end
end

class Fcq < ActiveRecord::Base
  #Belongs to
  belongs_to :instructor, counter_cache: true
  belongs_to :course, counter_cache: true
  belongs_to :department, counter_cache: true
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
  # before_save :update_counters
  ##################################

  def pass_rate
    return percentage_passed_string
  end

  def float_passed
    failed = pct_c_minus_or_below || 1.0
    fp = (1.0 - failed)
    return fp
  end

  def percentage_passed_string
  	val = (float_passed * 100).round(0)
  	val = [val, 100].min
  	val = [val, 0].max
  	if (val == 0)
  		return '--'
  	else
  		string = val.round
  		return "#{string}%"
  	end
  end 

  def pct_a_string
    if pct_a != nil
      val = (pct_a * 100).round(0)
      val = [val, 100].min
      val = [val, 0].max
      if (val == 0)
        return '--'
      else
        string = val.round
        return "#{string}%"
      end
    else 
      return "--"
    end 
  end 

  def pct_b_string
    if pct_a != nil
      val = (pct_b * 100).round(0)
      val = [val, 100].min
      val = [val, 0].max
      if (val == 0)
        return '--'
      else
        string = val.round
        return "#{string}%"
      end
    else 
      return "--"
    end 
  end 

  def pct_c_string
    if pct_c != nil
      val = (pct_c * 100).round(0)
      val = [val, 100].min
      val = [val, 0].max
      if (val == 0)
        return '--'
      else
        string = val.round
        return "#{string}%"
      end
    else 
      return "--"
    end 
  end 

  def pct_d_string
    if pct_d != nil
      val = (pct_d * 100).round(0)
      val = [val, 100].min
      val = [val, 0].max
      if (val == 0)
        return '--'
      else
        string = val.round
        return "#{string}%"
      end
    else 
      return "--"
    end 
  end

  def pct_f_string
    if pct_f != nil
      val = (pct_f * 100).round(0)
      val = [val, 100].min
      val = [val, 0].max
      if (val == 0)
        return '--'
      else
        string = val.round
        return "#{string}%"
      end
    else 
      return "--"
    end 
  end

  def avg_grd_string
    if avg_grd != nil
      val = avg_grd.round(2)
      return "#{val}"
    else
      return "--"
    end
  end


  ###################################

  def course_overall_string 
    if courseoverall != nil
      val = courseoverall.round(1)
      return "#{val}"
    else 
      return "--"
    end
  end

  ##################################
 
  def department_name_string
    if department != nil 
      val = department.name
      return "#{val}"
    else 
      return "--"
    end
  end

  def yearterm_identifier
    "#{subject} #{crse}-#{section_string}, #{semterm}"
  end

  def section_string
    return sec.to_s.rjust(3, '0')
  end

  def collected_online
    if onlinefcq == "OL"
      return true
    end
    return false
  end

  def uid
    return "#{yearterm}#{subject}#{crse}#{sec}"
  end

  def n_withdrawn
    e = n_enroll || 0
    t = n_eot || 0
    return [(e - t), 0].max
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
    elsif (activity_type != nil)
      if (activity_type[0..2] = "REC")
        return true
      else
        return false
      end
    else 
      return true
    end
  end

  def activity_type_string
    if(activity_type != nil)
      return self.activity_type
    else
      return "--"
    end
  end

  def hours_string
    if(hours != nil)
      return self.hours
    else
      return "--"
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

  def summer_fcq?
    return ((yearterm % 10) == 4)
  end

  def bad?
    if missing_fcq_data?
      return true
    end
    return (formsreturned < 1)
  end

  def missing_fcq_data?
    return (courseoverall == nil)
  end


  def missing_grade_data?
    return (avg_grd == nil)
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
    return %Q{#{semterm} #{subject} #{crse}-#{sec} #{title}}
  end

  def fcq_header
    return "#{crse}-#{sec}"
  end

  def requested_returned_string
    "#{formsreturned} / #{formsrequested}"
  end

  def instructor_full_name
    "#{instructor_first} #{instructor_last}"
  end

end
