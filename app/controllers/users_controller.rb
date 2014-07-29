class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
  end

  def index
  end

  def create
    @user = User.new(user_params) # fix later to use strong params

    if @user.save
      flash[:success] = "Successfully registered!"
      sign_in @user
      redirect_to root_url
    else
      render 'new'
    end
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end


end
