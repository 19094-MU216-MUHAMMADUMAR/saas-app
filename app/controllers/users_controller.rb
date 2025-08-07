class UsersController < ApplicationController
  before_action :require_admin, except: [:show, :edit, :update]
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :check_user_permissions, only: [:edit, :update]
  
  def index
    @users = current_organization.users.order(:first_name, :last_name)
  end
  
  def show
  end
  
  def new
    @user = current_organization.users.build
  end
  
  def invite
    @user = User.new
  end
  
  def send_invitation
    @user = User.invite!(user_params, current_user)
    
    if @user.errors.empty?
      redirect_to users_path, notice: 'Invitation sent successfully.'
    else
      render :invite
    end
  end
  
  def edit
  end
  
  def update
    if @user.update(user_params)
      redirect_to @user, notice: 'User was successfully updated.'
    else
      render :edit
    end
  end
  
  def destroy
    if @user == current_user
      redirect_to users_path, alert: 'You cannot delete yourself.'
    else
      @user.destroy
      redirect_to users_path, notice: 'User was successfully deleted.'
    end
  end
  
  private
  
  def set_user
    @user = current_organization.users.find(params[:id])
  end
  
  def user_params
    if current_user.admin?
      params.require(:user).permit(:email, :first_name, :last_name, :role)
    else
      params.require(:user).permit(:first_name, :last_name)
    end
  end
  
  def check_user_permissions
    unless current_user.admin? || @user == current_user
      redirect_to users_path, alert: 'Access denied.'
    end
  end
end
