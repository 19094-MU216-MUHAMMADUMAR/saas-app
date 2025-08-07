# ActsAsTenant Configuration
ActsAsTenant.configure do |config|
  # Don't require tenant for public pages and registration
  config.require_tenant = false
  
  # Pkey is organization_id by default
  config.pkey = :id
end
