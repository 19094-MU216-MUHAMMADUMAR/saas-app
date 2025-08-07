class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  
  set_current_tenant_through_filter
  before_action :authenticate_user!
  before_action :set_tenant
  before_action :configure_permitted_parameters, if: :devise_controller?
  
  protected
  
  def current_organization
    ActsAsTenant.current_tenant
  end
  helper_method :current_organization
  
  def require_admin
    redirect_to root_path, alert: 'Access denied.' unless current_user&.admin?
  end
  
  private
  
  def set_tenant
    if user_signed_in? && current_user.organization
      set_current_tenant(current_user.organization)
    elsif params[:organization_id]
      organization = Organization.find_by(id: params[:organization_id])
      set_current_tenant(organization) if organization
    end
  end
  
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :role])
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name])
    devise_parameter_sanitizer.permit(:invite, keys: [:first_name, :last_name, :role])
    devise_parameter_sanitizer.permit(:accept_invitation, keys: [:first_name, :last_name, :password, :password_confirmation])
  end
end
