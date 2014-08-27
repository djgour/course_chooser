class CoursesController < ApplicationController
  before_action :require_admin, only: [:new, :create, :edit, :update]
  def show
    @course = Course.find(params[:id])
  end
  
  def index
  end
  
  def new
    @course = Course.new
  end
  
  def create
    @course = Course.new(course_params)
    if @course.save
      flash[:success] = "Course successfully created!"
      redirect_to @course
    else
      render 'new'
    end
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
