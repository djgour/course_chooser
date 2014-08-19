module ApplicationHelper
  
  #figure out if this goes into a different model
  def current_courseplan
    current_user.active_courseplan
  end

  def current_courseplan? (courseplan)
    current_courseplan == courseplan
  end

  def format_title(title="")
    title_string = "CourseChooser"
    unless title.blank?    
      title_string += " | #{title}"
    end
    title_string
  end
  
end
