VALID_TERMS = { 1 => 'Spring', 4 => 'Summer', 7 => 'Fall' }
VALID_GROUPS = ['TA', 'TTT', 'OTH']
class FcqValidator < ActiveModel::Validator
  def validate(record)
    key = record.yearterm || 0
    key %= 10
    unless VALID_TERMS.key?(key)
      record.errors[:base] << 'term is not valid! must end in 1, 4, 7 to indicate Spring, Summer and Fall respectively'
    end
    unless VALID_GROUPS.include?(record.instr_group)
      record.errors[:base] << 'instructor group is not valid! must be either TTT, TA, or OTH'
    end
  end
end

class Fcq < ActiveRecord::Base
  # Belongs to
  belongs_to :instructor, counter_cache: true
  belongs_to :course, counter_cache: true
  belongs_to :department, counter_cache: true
  # validates the minimum entries are present
  validates :yearterm, :subject, :crse, :sec, :instructor_last, :instructor_first, :formsrequested, :formsreturned, :campus, :college, :instr_group, presence: true
  # validates entries match established patterns
  validates :yearterm, length: { is: 5 }
  validates :subject, :crse, length: { is: 4 }
  validates :sec, length: { maximum: 3 }
  validates_with FcqValidator
  validates_uniqueness_of :sec, scope: [:crse, :subject, :yearterm, :instructor_last, :instructor_first]
  # before_save :update_counters
  ##################################

  def pass_rate
    percentage_passed_string
  end

  def float_passed
    failed = pct_c_minus_or_below || 1.0
    (1.0 - failed)
  end

  def percentage_passed_string
    val = (float_passed * 100).round(0)
    val = [val, 100].min
    val = [val, 0].max
    return '--' if (val == 0)
    "#{val.round}%"
  end

  def pct_a_string
    unless pct_a.nil?
      val = (pct_a * 100).round(0)
      val = [val, 100].min
      val = [val, 0].max
      return '--' if (val == 0)
      return "#{val.round}%"
    end
    '--'
  end

  def pct_b_string
    unless pct_b.nil?
      val = (pct_b * 100).round(0)
      val = [val, 100].min
      val = [val, 0].max
      return '--' if (val == 0)
      return "#{val.round}%"
    end
    '--'
  end

  def pct_c_string
    unless pct_c.nil?
      val = (pct_c * 100).round(0)
      val = [val, 100].min
      val = [val, 0].max
      return '--' if (val == 0)
      return "#{val.round}%"
    end
    '--'
  end

  def pct_d_string
    unless pct_d.nil?
      val = (pct_d * 100).round(0)
      val = [val, 100].min
      val = [val, 0].max
      return '--' if (val == 0)
      return "#{val.round}%"
    end
    '--'
  end

  def pct_f_string
    unless pct_f.nil?
      val = (pct_f * 100).round(0)
      val = [val, 100].min
      val = [val, 0].max
      return '--' if (val == 0)
      return "#{val.round}%"
    end
    '--'
  end

  ###################################

  def course_overall_string
    return "#{courseoverall.round(1)} / 6.0" unless courseoverall.nil?
    '--'
  end

  def instructor_overall_string
    if instructoroverall != nil
      val = instructoroverall.round(1)
      return "#{val} / 6.0"
    else
      return '--'
    end
  end

  ##################################

  def department_name_string
    return "#{department.name} / 6.0" unless department.nil?
    '--'
  end

  def challenge_string
    return "#{challenge.round(1)} / 6.0" unless challenge.nil?
    '--'
  end

  def prior_interest_string
    return "#{priorinterest.round(1)} / 6.0" unless priorinterest.nil?
    '--'
  end

  def howmuchlearned_string
    return "#{howmuchlearned.round(1)} / 6.0" unless howmuchlearned.nil?
    '--'
  end

  def avg_grd_string
    return "#{avg_grd.round(2)} / 4.0" unless avg_grd.nil?
    '--'
  end

  def yearterm_identifier
    "#{subject} #{crse}-#{section_string}, #{semterm}"
  end

  def section_string
    sec.to_s.rjust(3, '0')
  end

  def collected_online
    return true if onlinefcq == 'OL'
    false
  end

  def uid
    "#{yearterm}#{subject}#{crse}#{sec}"
  end

  def n_withdrawn
    e = n_enroll || 0
    t = n_eot || 0
    [(e - t), 0].max
  end

  def title
    return corrected_course_title unless corrected_course_title.nil?
    capitalized_title
  end

  def capitalized_title
    ctitle = course_title || course.course_title || ''
    ctitle.split.map(&:capitalize).join(' ')
  end

  def correct_title(title)
    write_attribute(:corrected_course_title, title)
  end

  def recitation?
    return true if (course_title == 'REC' || course_title == 'RECITATION')
    return true if (activity_type[0..2] == 'LEC' && instr_group == 'TA')
    unless activity_type.nil?
      return true if (activity_type[0..2] == 'REC')
      return false
    end
    true
  end

  def activity_type_string
    activity_type unless activity_type.nil?
    '--'
  end

  def hours_string
    hours unless hours.nil?
    '--'
  end

  def ld?
    (crse < 3000)
  end

  def ud?
    !(self.ld?) && (crse < 5000)
  end

  def grad?
    (crse >= 5000)
  end

  def rank_string
    return 'Lower Division' if ld?
    return 'Upper Division' if ud?
    'Graduate Level'
  end

  def rank_string_abridged
    return 'ld' if ld?
    return 'ud' if ud?
    'gd'
  end

  def year
    yearterm / 10
  end

  attr_reader :semterm
  def semterm
    (VALID_TERMS[yearterm % 10] + ' ' + year.to_s)
  end

  def self.semterm_from_int(s)
    (VALID_TERMS[s % 10] + ' ' + (s / 10).to_s)
  end

  def summer_fcq?
    ((yearterm % 10) == 4)
  end

  def bad?
    return true if missing_fcq_data?
    (formsreturned < 1)
  end

  def missing_fcq_data?
    (courseoverall.nil?)
  end

  def missing_grade_data?
    avg_grd.nil?
  end

  def color
    return 'box1' if ld?
    return 'box2' if ud?
    'box3'
  end

  def fcq_object
    "#{semterm} #{subject} #{crse}-#{sec} #{title}"
  end

  def fcq_header
    "#{crse}-#{sec}"
  end

  def requested_returned_string
    "#{formsreturned} / #{formsrequested}"
  end

  def instructor_full_name
    "#{instructor_first} #{instructor_last}"
  end
end
