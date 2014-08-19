class CourseplansController < ApplicationController
  before_action :correct_user, only: [:show, :destroy]

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

  def destroy
    @courseplan = current_user.courseplans.find_by(id: params[:id])
    @courseplan.destroy
    redirect_to root_url
  end
  

    private

      def courseplan_params
        params.require(:courseplan).permit(:name)
      end

      def correct_user
        current_user.courseplans.find(params[:id])
        rescue ActiveRecord::RecordNotFound
          render :file => "public/401.html", :status => :unauthorized
      end
end
