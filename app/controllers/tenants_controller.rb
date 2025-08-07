class TenantsController < ApplicationController
  skip_before_action :set_tenant, only: [:new, :create]
  before_action :authenticate_user!, except: [:new, :create]
  
  def show
    @tenant = current_tenant
    redirect_to root_path unless @tenant
  end
  
  def new
    @tenant = Tenant.new
    @user = User.new
  end
  
  def create
    @tenant = Tenant.new(tenant_params)
    @user = User.new(user_params)
    @user.tenant = @tenant
    
    if @tenant.save && @user.save
      sign_in(@user)
      set_current_tenant(@tenant)
      redirect_to root_path, notice: 'Welcome! Your account has been created.'
    else
      render :new
    end
  end
  
  private
  
  def tenant_params
    params.require(:tenant).permit(:name, :subdomain)
  end
  
  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
