class CoursesController < ApplicationController
  before_action :require_admin, only: [:edit, :update] # TDD add create and update
  def show
    @course = Course.find(params[:id])
  end
  
  def index
  end
  
  def edit
    @course = Course.find(params[:id])
  end
  
  def update
    @course = Course.find(params[:id])
    if @course.update_attributes(course_params) && @course.update_fce_from_params(params[:credits])
      flash[:success] = "Successfully updated!"
      redirect_to @course
    else
      render 'edit'
    end
  end
  
  private
  
  def course_params
    params.require(:course).permit(:code, :name, :description)
  end
  
end
