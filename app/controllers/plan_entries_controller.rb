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
  
  def update
    @courseplan = current_user.courseplans.find_by(id: params[:courseplan_id])
    @plan_entry = @courseplan.plan_entries.find_by(id: params[:id])
   if params[:no_semester]
     @plan_entry.no_semester!
   else
     season,year = params[:Choose][:semester].split(' ')
     @plan_entry.set_semester(year: year.to_i, season: season.downcase.to_sym)
  end
  
  redirect_to :back
  end
end
