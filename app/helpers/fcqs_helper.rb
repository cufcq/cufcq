module FcqsHelper

  def recitation?
    if (course_title == "REC" || course_title == "RECITATION")
    	return true
    elsif (sec != 1 || sec != 10 || sec != 100)
    	return true
    else 
    	return false
    end
  end

  def recitation?(course_title, sec)
    if (course_title == "REC" || course_title == "RECITATION")
    	return true
    elsif (sec != 1 || sec != 10 || sec != 100)
    	return true
    else
    	return false
    end
  end

end
