module PlanEntriesHelper
  
  def format_semester(semester_key)
    formatted_string = semester_key.to_s.gsub!('_', ' ')
    formatted_string[0] = formatted_string[0].upcase
    formatted_string
  end
end
