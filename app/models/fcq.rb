VALID_TERMS = { 1 => 'Spring', 4 => 'Summer', 7 => 'Fall' }
VALID_GROUPS = ['TA', 'TTT', 'OTH']
include FcqsHelper
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
    # unless record.pct_c_minus_or_below.nil?
    #   record.errors[:base] << 'instructor group is not valid! must be either TTT, TA, or OTH'
    # end
  end
end
# represents Fcqs as a unque record
class Fcq < ActiveRecord::Base

  # Belongs to
  belongs_to :instructor, counter_cache: true
  belongs_to :course, counter_cache: true
  belongs_to :department, counter_cache: true
  # validates the minimum entries are present
  validates :yearterm, :subject, :crse, :sec, :instructor_last, :instructor_first, :formsrequested, :formsreturned, :campus, :college, presence: true
  # validates entries match established patterns
  validates :yearterm, length: { is: 5 }
  validates :subject, :crse, length: { is: 4 }
  validates :sec, length: { maximum: 3 }
  validates_with FcqValidator
  validates_uniqueness_of :sec, scope: [:crse, :subject, :yearterm, :instructor_last, :instructor_first]
  # before_save :update_counters
  ##################################

  def float_passed
    failed = pct_c_minus_or_below || 1.0
    (1.0 - failed)
  end

  def to_percentage_string(input)
    unless input.between?(0.0, 1.0)
      fail StandardError, 'input not within acceptable bounds'
    end
    val = (input * 100).round(0)
    val = [val, 100].min
    val = [val, 0].max
    "#{val.round}%"
  end

  def pass_rate
    return to_percentage_string(float_passed) unless pct_c_minus_or_below.nil?
    '--'
  end

  def pct_a_string
    return to_percentage_string(pct_a) unless pct_a.nil?
    '--'
  end

  def pct_b_string
    return to_percentage_string(pct_b) unless pct_b.nil?
    '--'
  end

  def pct_c_string
    return to_percentage_string(pct_c) unless pct_c.nil?
    '--'
  end

  def pct_d_string
    return to_percentage_string(pct_d) unless pct_d.nil?
    '--'
  end

  def pct_f_string
    return to_percentage_string(pct_f) unless pct_f.nil?
    '--'
  end

  ###################################

  def course_overall_string
    return out_of_6(courseoverall.round(1)) unless courseoverall.nil?
    '--'
  end

  def instructor_overall_string
    return out_of_6(instructoroverall.round(1)) unless instructoroverall.nil?
    '--'
  end

  ##################################

  def challenge_string
    return out_of_6(challenge.round(1)) unless challenge.nil?
    '--'
  end

  def prior_interest_string
    return out_of_6(priorinterest.round(1)) unless priorinterest.nil?
    '--'
  end

  def howmuchlearned_string
    return out_of_6(howmuchlearned.round(1)) unless howmuchlearned.nil?
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

  def recitation?
    return true if course_title == 'REC' || course_title == 'RECITATION'
    unless activity_type.nil?
      return true if activity_type[0..2] == 'LEC' && instr_group == 'TA'
      return true if (activity_type[0..2] == 'REC')
      return false
    end
    true
  end
end
