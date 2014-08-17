module ApplicationHelper
  
  #figure out if this goes into a different model
  def current_courseplan
    current_user.default_courseplan
  end
  
end
