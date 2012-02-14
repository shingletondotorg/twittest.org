class UsersController < ApplicationController
  before_filter :authenticate, :only => [:index, :edit, :update, :destroy]
  before_filter :correct_user, :only => [:edit, :update]
  before_filter :admin_user,   :only => :destroy

  def new
    @user = User.new
    @title = "Sign up"
  end

  def index
    @title = "All users"
    @users = User.paginate(:page => params[:page])
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(:page => params[:page])
    @title = @user.first_name + " " + @user.last_name 
  end

  def create    
    @user = User.new(params[:user])
    if @user.save
      flash[:success] = "Welcome to Twittest!"
      sign_in @user
      redirect_to @user
    else
      @title = "Sign up"
      # Reset password to it's cleared in the form input
      @user.password = ""
      render 'new'
    end
  end

  def my_profile
    @title = "My Profile"
    @user = User.find(current_user.id)
  end

  def edit
    @user = User.find(params[:id])
    @title = "Edit user"
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated."
      redirect_to @user
    else
     @title = "Edit user"
      render 'edit'
    end
  end
  
  def update_profile
     
     
     
     @user = User.find(current_user.id)
      if @user.update_attributes(params[:user])
        flash.now[:success] = "Profile updated."
      else
        flash.now[:error] = "There has been a problem saving your profile."
      end
      render 'my_profile'
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed."
    redirect_to users_path
  end

  private
    # Sets @user and ensures that @user is the logged-in user
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end
end
