class CoursesController < ApplicationController
  before_action :require_admin, only: [:edit, :update]
  def show
    @course = Course.find(params[:id])
  end
  
  def index
  end
  
  def edit
  end
  
  def update
  end
  
end
