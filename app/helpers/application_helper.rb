module ApplicationHelper

 # Returns the full title on a per-page basis.
   def full_title(page_title)
       base_title = "CUFCQ"
           if page_title.empty?
                 base_title
                     else
                           "#{base_title} | #{page_title}"
                      end
            end
    end

    # makes a sortable column, rendering "title" and searching under "column"
    def sortable(title, column)
        # title ||= column.titleize
        css_class = ((column == sort_column) || (sort_column == "data -> '#{column}'")) ? "current #{sort_direction}" : nil
        direction = ((column == sort_column) || (sort_column == "data -> '#{column}'")) && sort_direction == "asc" ? "desc" : "asc"
        # direction = sort_direction == "asc" ? "desc" : "asc"
        link_to title, params.merge(:sort => column, :direction => direction, :page => nil),{:class => css_class}
    end

    def activity_type_flavor_text(code)
      text = code || "---"
      case text[0..2]
      when "LEC"
        puts "Lecture"
      when "SEM"
        puts "Seminar"
      when "REC"
        puts "Recitation"
      when "WKS"
        puts "Workshop"
      when "PRA"
        puts "Practicum"
      when "INT"
        puts "Internship"
      when "STU"
        puts "Studio"
      when "LAB"
        puts "Labratory"
      when "MLS"
        puts "Main Lab"
      when "RSC"
        puts "Research"
      when "DIS"
        puts "Dissertation"
      when "OTH"
        puts "Other"
      when "IND"
        puts "Independant Study"
      when "CLN"
        puts "Clinical"
      when "FLD"
        puts "Field"
      when "DSC"
        puts "Discussion"
      else
        puts "---"
      end
=begin
  


DSC
OTH - Other
FLD
OTH
FLD - Field
CLN - Clinical
RSC
MLS
CLN
RSC - Research
WKS
IND
DIS
DIS - Dissert
IND - Ind Study
DSC - Discussion
  
=end
    end

