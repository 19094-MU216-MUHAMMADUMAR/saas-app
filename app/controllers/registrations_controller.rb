class RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  skip_before_action :set_tenant, only: [:new, :create]
  
  protected

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:tenant_attributes])
  end
  
  def build_resource(hash = {})
    super(hash)
    
    if action_name == 'create'
      # Create tenant and associate with user during registration
      tenant_params = params.dig(:user, :tenant_attributes)
      if tenant_params.present?
        tenant = Tenant.new(tenant_params)
        if tenant.valid?
          resource.tenant = tenant
        else
          tenant.errors.each do |error|
            resource.errors.add(:tenant, error.full_message)
          end
        end
      end
    end
  end
  
  def create
    super do |resource|
      if resource.persisted? && resource.tenant
        # Set the current tenant after successful registration
        set_current_tenant(resource.tenant)
      end
    end
  end
end
