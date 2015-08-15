class UsersController < ApplicationController

  before_action :logged_in_user,  only: [:index, :edit, :update, :destroy]
  before_action :correct_user,    only: [:edit, :update]
  before_action :admin_user,      only: :destroy

  # GET: Sign up page
  def new
    @user = User.new
  end

  # GET: Profile page
  def show
    @user = User.find(params[:id])
  end

  # POST: Sign up info
  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = "Welcome to the Sample App!"
      # note: Rails automatically infers "redirect_to user_url(@user)"
      redirect_to @user
    else
      render 'new'
    end
  end

  # GET: Edit profile page
  def edit
  end

  # PATCH (POST): Updated profile info
  def update
    if @user.update_attributes(user_params)
      # successful update
      flash[:success] = 'Profile Updated'
      redirect_to @user
    else
      # error
      render 'edit'
    end
  end

  # GET: Show all users
  def index
    @users = User.paginate(page: params[:page])
  end

  # DELETE (POST): Delete a user 
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end

  #############################################################################
  private

    # filters in relevant user info
  	def user_params
  		params.require(:user).permit(:name, :email, :password, :password_confirmation)
  	end

    # Before Filters

    # Confirms a logged-in user
    def logged_in_user
      unless logged_in?
        flash[:danger] = "Please log in."
        store_location
        redirect_to login_url
      end
    end

    # Confirms the correct user
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    # Confirms an admin user
    def admin_user
      unless current_user.admin?
        redirect_to root_url
      end
    end

end
