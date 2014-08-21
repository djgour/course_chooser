module PlanEntriesHelper
  
  def format_semester(semester_key)
    formatted_string = semester_key.to_s.gsub!('_', ' ')
    formatted_string[0] = formatted_string[0].upcase
    formatted_string
  end
  
  def default_semester_for(entry)
    semester = entry.semester_to_string || entry.upcoming_semester
  end
  
end
