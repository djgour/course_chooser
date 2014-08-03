module CourseplansHelper
  
  def show_courseplan_links(options={})
    current_user.all_courseplans(options).each do |plan|
      plan
    end
  end
  
end
