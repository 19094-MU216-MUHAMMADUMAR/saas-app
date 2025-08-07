# Stripe configuration
Stripe.api_key = ENV['STRIPE_SECRET_KEY'] || 'sk_test_51234567890'

# Store Stripe keys in Rails configuration for easy access
Rails.application.configure do
  config.x.stripe = {
    publishable_key: ENV['STRIPE_PUBLISHABLE_KEY'] || 'pk_test_51234567890',
    secret_key: ENV['STRIPE_SECRET_KEY'] || 'sk_test_51234567890',
    starter_price_id: ENV['STRIPE_STARTER_PRICE_ID'] || 'price_1234567890',
    professional_price_id: ENV['STRIPE_PROFESSIONAL_PRICE_ID'] || 'price_1234567891',
    enterprise_price_id: ENV['STRIPE_ENTERPRISE_PRICE_ID'] || 'price_1234567892'
  }
end
