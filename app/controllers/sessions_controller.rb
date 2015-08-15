class SessionsController < ApplicationController
  
  # Get: Login page
  def new
  end

  # Post: Login info
  def create
    @user = User.find_by(email: params[:session][:email].downcase)

    # if user exists and password matches digest
    if @user && @user.authenticate(params[:session][:password])
      log_in @user
      params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
      redirect_back_or @user
    else
      flash.now[:danger] = "Invalid email/password"
      render 'new'
    end
  end

  # Delete: Logout
  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
