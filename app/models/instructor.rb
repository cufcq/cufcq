IG_TTT = "Tenured or tenure-track instructor"
IG_OTH = "Other primary instructor, such as adjunct, visiting, honorarium, etc."
IG_TA = "Teaching_Assistant"

class Instructor < ActiveRecord::Base
# attr_accessor :instructor_first, :instructor_last
self.per_page = 10

  searchable do 
    string :instructor_first
    string :instructor_last
    text :instructor_first
    text :instructor_last, :default_boost => 2
  end

  belongs_to :department, counter_cache: true
  has_many :fcqs
  # has_many :courses
  has_many :courses, -> { distinct }, through: :fcqs, counter_cache: true

  validates_uniqueness_of :instructor_first, scope: [:instructor_last]
  # added code creates an alternate custom route for accessing our instructors by name
  validates :slug, uniqueness: true, presence: true
  before_validation :generate_slug
  #instrrespect
  #availability
  #instreffective
  #overall
  #passrate
  #classes taught
  #students taught
  #records since

  def to_param
    slug
  end

  def generate_slug
    puts "generating slug!"
    # puts "#{self.instructor_last.titleize}, #{self.instructor_first.titleize}".parameterize
    self.slug ||= "#{self.instructor_last.titleize}-#{self.instructor_first.titleize}".parameterize
    puts "slug generated"
    return self.slug
  end

  def scorecard
    scorecard = {
      :id => self.id,
      :name => self.name,
      :first_semester => self.started_teaching,
      :latest_semester => self.latest_teaching,
      :requested_returned_ratio => self.requested_returned_ratio(3),
      :instructor_group => self.instr_group,
      :average_overall => self.average_instructoroverall(3), 
      :average_respect => self.average_instrrespect(3), 
      :average_availability => self.average_availability(3),
      :average_effectiveness => self.average_instreffective(3)
    }
    return scorecard
  end

  def self.scorecards(instr_group = nil, dept = nil)
    arr = []
    Instructor.all.each do |instr|
      if instr_group != nil
        if instr.instr_group != instr_group
          next
        end
      end
      if dept != nil
        if instr.department.name != dept
          next
        end
      end
      arr << instr.scorecard
    end
    return arr
  end


  def cache_course_count
    self.update_attribute(:courses_count, self.courses.count)
  end

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
    return self.data['instructor_group'] || "TTT"
  end

  def is_TA
    return (instr_group == "TA") ? true : false
  end

  def instructor_type_string
    is_TA ? "Teaching Assistant" : "Instructor"
  end

  def overall_from_course(c)
    subject = c.subject
    crse = c.crse
    set = self.fcqs.where("subject = ? AND crse = ?", subject, crse)
    return set.average(:instructoroverall).round(1)
  end

  def started_teaching
    return self.data['earliest_class'].to_i
  end

  def latest_teaching
    return self.data['latest_class'].to_i
  end

  def average_instrrespect(rounding = 1)
    x = self.data['average_instructor_respect'].to_f || 0.0
    return x.round(rounding)
  end

  def self.averages(instr_group = nil, dept = nil)
    availability = 0.0
    respect = 0.0
    effectiveness = 0.0
    overall = 0.0
    count = 0
    Instructor.all.each do |instr|
      if instr_group != nil
        if instr.instr_group != instr_group
          next
        end
      end
      if dept != nil
        if instr.department.name != dept
          next
        end
      end
      count += 1
      respect += instr.average_instrrespect
      availability += instr.average_availability
      effectiveness += instr.average_instreffective
      overall += instr.average_instructoroverall
    end
    # count = Instructor.count || 1
    respect = (respect / count ).round(1)
    availability = (availability / count ).round(1)
    effectiveness = (effectiveness / count ).round(1)
    overall = (overall / count ).round(1)
    print "Average Respect: #{respect}\n"
    print "Average Availab: #{availability}\n"
    print "Average Effectv: #{effectiveness}\n"
    print "Average Overall: #{overall}\n"
  end

  # def self.json_instructors
  #   hash = {}
  #   Instructor.all.each do |instr|
  #     slug = instr.slug
  #     if slug == nil
  #       next
  #     end
  #     hash[slug] = instr.scorecard
  #   end
  #   return hash
  # end

  def average_availability(rounding  = 1 )
    x = self.data['average_instructor_availability'].to_f || 0.0
    return x.round(rounding)
  end

  def average_instreffective(rounding = 1)
    x = self.data['average_instructor_effectiveness'].to_f || 0.0
    return x.round(rounding)
  end

  def total_requested
    return self.fcqs.sum(:formsrequested) || 0
  end

  def total_returned
    return self.fcqs.sum(:formsreturned) || 1
  end


  def requested_returned_ratio(rounding = 2)
     (total_returned.to_f / total_requested.to_f).round(rounding)
  end

  def average_instructoroverall(rounding = 1)
    overall = self.data['average_instructor_overall'].to_f || 0.0
    return overall.round(rounding)
  end

  def courses_taught
    count = (self.data['courses_taught']).to_i
    return [count,1].max
  end

  attr_reader :semesters, :overall_data, :availability_data, :instrrespect_data, :instreffective_data, :overall_average, :availability_average, :instrrespect_average, :instreffective_average


  ########################################
  # This is where we use the grade csv   #
  ########################################

  def average_percentage_passed_float
    return self.data["average_percent_passed"].to_f
  end

  def compute_average_percentage_passed
    total = 0.0
    self.fcqs.compact.each {|x| next if x.float_passed < 0.0; total += x.float_passed}
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
    return self.data["average_grade"]
  end

    # these take the avg grades of all classes taught by a prof and avg them 
  def compute_average_grade
    total = 0.0
    self.fcqs.compact.each {|x| next if x.avg_grd == nil; total += x.avg_grd}
    count = courses_taught
    if count == 0
      return 1.0 
    else
      return (total.to_f / count.to_f)
    end
  end

  ##################End grades.csv stuff#####################


  def overall_query
    @overall_data = self.data['overall_data']
    @availability_data = self.data['availability_data']
    @instreffective_data = self.data['instreffective_data']
    @instrrespect_data = self.data['instrrespect_data']
    @overall_average = self.department.data['average_instructoroverall']
    @availability_average = self.department.data['average_availability']
    @instrrespect_average = self.department.data['average_instrrespect']
    @instreffective_average = self.department.data['average_instreffective']
  end

  def build_hstore
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
    self.data = {}
    self.data['overall_data'] = @overall_data
    self.data['availability_data'] = @availability_data
    self.data['instreffective_data'] = @instreffective_data
    self.data['instrrespect_data'] = @instrrespect_data
    self.data['courses_taught'] = self.fcqs.count
    self.data['average_grade'] = compute_average_grade
    self.data['average_percent_passed'] =compute_average_percentage_passed
    self.data['average_instructor_overall'] = self.fcqs.average(:instructoroverall)
    self.data['average_instructor_effectiveness'] = self.fcqs.average(:instreffective)
    self.data['average_instructor_respect'] = self.fcqs.average(:instrrespect)
    self.data['average_instructor_availability'] = self.fcqs.average(:availability)
    self.data['latest_class'] = self.fcqs.maximum(:yearterm)
    self.data['earliest_class'] = self.fcqs.minimum(:yearterm)
    self.data['instructor_group'] = self.fcqs.pluck(:instr_group).mode
    cache_course_count
    self.save
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
