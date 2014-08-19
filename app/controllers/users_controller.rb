class UsersController < ApplicationController
  skip_before_action :require_login, only: [:new, :create]
  before_action :correct_user, only: [:update]

  def new
    @user = User.new
  end

  def show
    if (current_user.admin?) || (current_user? User.find(params[:id]))
      @user = User.find(params[:id])
    else
      redirect_to root_url
    end
  end

  def index
    if current_user.admin?
      @users = User.all
      render 'index'
    else
      redirect_to root_url
    end
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "Successfully registered!"
      sign_in @user
      redirect_to root_url
    else
      render 'new'
    end
  end

  def update
  end

  def change_active_courseplan
    new_active_courseplan = current_user.courseplans.find_by(id: params[:courseplan_id])
    if new_active_courseplan.nil?
      render :file => "public/401.html", :status => :unauthorized
    else
      current_user.update(active_courseplan_id: new_active_courseplan.id)
      redirect_to :back
    end
  end
  
  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation, :default_id)
    end

    def correct_user
      @user = User.find(params[:id])
      render :file => "public/401.html", :status => :unauthorized unless current_user?(@user)
    end

end
