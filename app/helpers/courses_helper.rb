module CoursesHelper
  def course_link(course)
    link_to "#{course.code}: #{course.name}", course
  end
  
  def removal_link_for(course, courseplan)
    plan_entry = courseplan.plan_entries.find_by(course: course)
    link_to "-", courseplan_plan_entry_path(courseplan, plan_entry), method: :delete, class: "widget removal"
  end
  
  def addition_link_for(course, courseplan)
    link_to "+", courseplan_plan_entries_path(courseplan.id, course: course), method: :post, class: "widget addition"
  end
  
end
