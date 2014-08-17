class PlanEntriesController < ApplicationController
  
  def create
    @courseplan = current_user.courseplans.find_by(id: params[:courseplan_id])
    @course = Course.find_by(id: params[:course])
    @courseplan.add_course!(@course)
    redirect_to :back
  end
  
  def destroy
    @courseplan = current_user.courseplans.find_by(id: params[:courseplan_id])
    @plan_entry = @courseplan.plan_entries.find_by(id: params[:id])
    @course = Course.find_by(id: @plan_entry.course_id)
    @courseplan.remove_course!(@course)
    redirect_to :back
  end
  
end
