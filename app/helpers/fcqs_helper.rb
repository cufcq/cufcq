module FcqsHelper

  def recitation?(course_title, sec)
    return true if course_title == 'REC' || course_title == 'RECITATION'
    unless activity_type.nil?
      return true if activity_type[0..2] == 'LEC' && instr_group == 'TA'
      return true if (activity_type[0..2] == 'REC')
      return false
    end
    true
  end

  def out_of_6(val)
    "#{val} / 6.0"
  end

end
