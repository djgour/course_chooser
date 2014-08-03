class CourseplansController < ApplicationController

  def new
    @courseplan = Courseplan.new
  end

  def create
    @courseplan = current_user.courseplans.new(courseplan_params)

    if @courseplan.save
      flash[:success] = "New plan created!"
      redirect_to root_url
    else
      render 'new'
    end
  end
  
  def show
    plans = current_user.courseplans.all
    @courseplan = plans.find(params[:id])
  end
  

    private

    def courseplan_params
      params.require(:courseplan).permit(:name)
    end
end