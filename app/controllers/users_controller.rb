class UsersController < ApplicationController
  # add_breadcrumb "home", :root_path
  before_action :authenticate_user!  
  add_breadcrumb "Dashboard", :user_root_path

  def index
    
    add_breadcrumb "Users", :users_path
    @users = User.all
  end
  
  def settings
    add_breadcrumb "Settings", :settings_path
    @user = current_user
  end

  def update_settings
   
    @user = current_user
    if @user.update(user_params)
      redirect_to  settings_path, notice: "Member was successfully updated."     
    else
      render :settings, status: :unprocessable_entity    
    end
  end

  def password
    add_breadcrumb "Password", :change_password_path
    @user = current_user
  end

  def update_password
    @user = current_user
    if @user.update(params.require(:user).permit(:password))
      redirect_to  change_password_path, notice: "Member was successfully updated."     
    else
      render :password, status: :unprocessable_entity    
    end
  end


  def impersonate
    user = User.find(params[:id])
    impersonate_user(user)
    redirect_to root_path
  end

  def stop_impersonating
    stop_impersonating_user
    redirect_to root_path
  end


  def user_params
    params.require(:user).permit(:first_name, :last_name, :time_zone, :password, :avatar)
  end
end