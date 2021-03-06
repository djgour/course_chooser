class SessionsController < ApplicationController
  skip_before_action :require_login, only: [:new, :create]

  def new
    if signed_in?
      flash[:error] = "You're already signed in."
      redirect_to root_url 
    else
      render 'new'
    end
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      sign_in user
      redirect_back_or root_url
    else
      flash.now[:error] = "Invalid email/password combination"
      render 'new'
    end
  end

  def destroy
    sign_out
    redirect_to root_url
  end
  
end
