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
  
  def capitalized_deranged_hash(hash)
    hash_with_capitals = ActiveSupport::OrderedHash.new
    hash.each do |key, value|
      capitalized_key = key.to_s.capitalize
      hash_with_capitals[capitalized_key] = value.first
    end
    
    hash_with_capitals
  end
end
