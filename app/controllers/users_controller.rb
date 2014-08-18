class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def show
    if signed_in? && admin?
      @user = User.find(params[:id])
    else
      redirect_to root_url
    end
  end

  def index
    if signed_in? && admin?
      @users = User.all
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

  def change_default_courseplan
    current_user.update(active_courseplan_id: params[:courseplan_id])
    redirect_to :back
  end
  
  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation, :default_id)
    end


end
