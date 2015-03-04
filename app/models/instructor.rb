IG_TTT = "Tenured or tenure-track instructor"
IG_OTH = "Other primary instructor, such as adjunct, visiting, honorarium, etc."
IG_TA = "Teaching_Assistant"

class Instructor < ActiveRecord::Base
# attr_accessor :instructor_first, :instructor_last
self.per_page = 10

  searchable do 
    text :instructor_first
    text :instructor_last, :default_boost => 2
  end

  belongs_to :department
  has_many :fcqs
  # has_many :courses
  has_many :courses, -> { distinct }, through: :fcqs

  validates_uniqueness_of :instructor_first, scope: [:instructor_last]
  #instrrespect
  #availability
  #instreffective
  #overall
  #passrate
  #classes taught
  #students taught
  #records since

  def name
    return "#{self.instructor_first.titleize}, #{self.instructor_last.titleize}"
  end

  def full_name
  	return name.split.map(&:capitalize).join(' ')
  end

  def instructor_object
    return %Q{#{college}}
  end

  def campus
      #currently defaults to string literal. This should be changed!
    "CU Boulder"
  end

  def department_string
    if department == nil
      return "--"
    else 
      return department.name
    end
  end

  def instr_group
    self.fcqs.pluck(:instr_group).mode
  end

  def is_TA
    return (instr_group == "TA") ? true : false
  end

  def instructor_type_string
    is_TA ? "teaching assistant" : "instructor"
  end

  def overall_from_course(c)
    subject = c.subject
    crse = c.crse
    set = self.fcqs.where("subject = ? AND crse = ?", subject, crse)
    return set.average(:instructoroverall).round(1)
  end

  def started_teaching
    Fcq.semterm_from_int(self.fcqs.minimum(:yearterm))
  end

  def latest_teaching
    Fcq.semterm_from_int(self.fcqs.maximum(:yearterm))
  end

  def average_instrrespect
    x = self.fcqs.average(:instrrespect) || 0.0
    return x.round(1)
  end

  def average_availability
    x = self.fcqs.average(:availability) || 0.0
    return x.round(1)
  end

  def average_instreffective
    x = self.fcqs.average(:instreffective) || 0.0
    return x.round(1)
  end

  def total_requested
    self.fcqs.sum(:formsrequested) 
  end

  def total_returned
    self.fcqs.sum(:formsreturned)
  end


  def requested_returned_ratio
     (total_returned.to_f / total_requested.to_f).round(1)
  end

  def average_instructoroverall
    overall = self.fcqs.average(:instructoroverall) || 0.0
    return overall.round(1)
  end

  def courses_taught
    count = self.fcqs.where('pct_c_minus_or_below IS NOT NULL').count
    return [count,1].max
  end

  attr_reader :semesters, :overall_data, :availability_data, :instrrespect_data, :instreffective_data, :categories


  ########################################
  # This is where we use the grade csv   #
  ########################################

  def average_percentage_passed_float
    total = 0.0
    self.fcqs.compact.each {|x| puts x.float_passed; next if x.float_passed < 0.0; total += x.float_passed}
    count = courses_taught
    if count == 0
      return 1.0 
    else
      return (total.to_f / count.to_f)
    end
  end
  
  def pass_rate_string
    pp = average_percentage_passed_float || 0.0
    val = (pp * 100).round(1)
    val = [val, 100].min
    val = [val, 0].max
    string = val.round 
    return "#{string}%"
  end 

  # these take the avg grades of all classes taught by a prof and avg them 
  def average_grade_overall
     total = 0.0
    self.fcqs.compact.each {|x| puts x.float_passed; next if x.float_passed < 0.0; total += x.float_passed}
    count = courses_taught
    if count == 0
      return 1.0 
    else
      return (total.to_f / count.to_f)
    end
  end

  #these take the avg amount of specififc grade for all classes taught by a prof and avg them 

  def average_grade_as 
  end

  def average_grade_bs 
  end

  def average_grade_cs 
  end

  #Do we want to ds and fs seperately or use ds/fs aggregated (possible perf issues?)
  def average_grade_ds 
  end

  def average_grade_fs 
  end

  #this is the average of all courses taught by the teacher of people withdrawn
  def average_withdrawn
  end 

  ##################End grades.csv stuff#####################


  def overall_query
    overalls = self.fcqs.order("yearterm").group("yearterm").average(:instructoroverall)
    avails = self.fcqs.order("yearterm").group("yearterm").average(:availability)
    effects = self.fcqs.order("yearterm").group("yearterm").average(:instreffective)
    instrrespects = self.fcqs.order("yearterm").group("yearterm").average(:instrrespect)
    @semesters = []
    @overall_data = []
    @availability_data = [] 
    @instrrespect_data = [] 
    @instreffective_data = [] 
    #records.each {|k,v| fixedrecords[Fcq.semterm_from_int(k)] = v.to_f.round(1)}
    overalls.each {|k,v| @overall_data << [k,v.to_f.round(1)]}
    avails.each {|k,v| @availability_data << [k,v.to_f.round(1)]}
    effects.each {|k,v| @instreffective_data << [k,v.to_f.round(1)]}
    instrrespects.each {|k,v| @instrrespect_data << [k,v.to_f.round(1)]}
    #@chart_data = fixedrecords.values
    puts @chart_data
  end

  def instr_group_flavor_text
    case instr_group
    when "TTT" 
      return IG_TTT
    when "OTH"
      return IG_OTH
    when "TA"
      return IG_TA
    else
      return "ERROR! Flavor text not found"
    end
  end

  def color
      if is_TA
        return "box6"
      else
        return "box4"
      end
  end

end
