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
  
  # def capitalized_deranged_hash(hash)
  #   hash_with_capitals = ActiveSupport::OrderedHash.new
  #   hash.each do |key, value|
  #     capitalized_key = key.to_s.capitalize
  #     hash_with_capitals[capitalized_key] = value.first
  #   end
  #
  #   hash_with_capitals
  # end
  
  def semester_with_year_hash(hash, options={})
    start_year = options[:start] || (current_user.created_at.year - 6)
    end_year = options[:end] || 6.years.from_now.year
    year_range = (start_year..end_year).to_a
    semesters_with_years = ActiveSupport::OrderedHash.new
    semesters_with_years = Array.new
    year_range.each do |year|
      hash.each do |key, value|
        semester_with_year = "#{key.capitalize} #{year}"
        semesters_with_years << semester_with_year
      end
    end
    semesters_with_years
  end
end
