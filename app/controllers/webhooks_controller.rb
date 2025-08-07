class WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token
  skip_before_action :authenticate_user!
  skip_before_action :set_current_organization
  
  def stripe
    payload = request.body.read
    sig_header = request.env['HTTP_STRIPE_SIGNATURE']
    endpoint_secret = ENV['STRIPE_WEBHOOK_SECRET']
    
    begin
      event = Stripe::Webhook.construct_event(payload, sig_header, endpoint_secret)
    rescue JSON::ParserError => e
      render json: { error: 'Invalid payload' }, status: 400
      return
    rescue Stripe::SignatureVerificationError => e
      render json: { error: 'Invalid signature' }, status: 400
      return
    end
    
    case event['type']
    when 'customer.subscription.created', 'customer.subscription.updated'
      handle_subscription_change(event['data']['object'])
    when 'customer.subscription.deleted'
      handle_subscription_cancellation(event['data']['object'])
    when 'invoice.payment_succeeded'
      handle_payment_success(event['data']['object'])
    when 'invoice.payment_failed'
      handle_payment_failure(event['data']['object'])
    else
      Rails.logger.info "Unhandled event type: #{event['type']}"
    end
    
    render json: { status: 'success' }
  end
  
  private
  
  def handle_subscription_change(subscription)
    customer_id = subscription['customer']
    status = subscription['status']
    
    organization = Organization.find_by(stripe_customer_id: customer_id)
    return unless organization
    
    # Get the price ID to determine the plan
    price_id = subscription['items']['data'].first['price']['id']
    
    plan = case price_id
           when Rails.application.credentials.stripe[:starter_price_id]
             'starter'
           when Rails.application.credentials.stripe[:professional_price_id]
             'professional'
           when Rails.application.credentials.stripe[:enterprise_price_id]
             'enterprise'
           else
             'starter' # fallback
           end
    
    organization.update!(
      subscription_plan: plan,
      subscription_status: status,
      stripe_subscription_id: subscription['id']
    )
    
    Rails.logger.info "Updated subscription for organization #{organization.id}: #{plan} (#{status})"
  end
  
  def handle_subscription_cancellation(subscription)
    customer_id = subscription['customer']
    
    organization = Organization.find_by(stripe_customer_id: customer_id)
    return unless organization
    
    organization.update!(
      subscription_status: 'cancelled'
    )
    
    Rails.logger.info "Cancelled subscription for organization #{organization.id}"
  end
  
  def handle_payment_success(invoice)
    customer_id = invoice['customer']
    
    organization = Organization.find_by(stripe_customer_id: customer_id)
    return unless organization
    
    organization.update!(
      subscription_status: 'active'
    )
    
    Rails.logger.info "Payment succeeded for organization #{organization.id}"
  end
  
  def handle_payment_failure(invoice)
    customer_id = invoice['customer']
    
    organization = Organization.find_by(stripe_customer_id: customer_id)
    return unless organization
    
    organization.update!(
      subscription_status: 'past_due'
    )
    
    Rails.logger.info "Payment failed for organization #{organization.id}"
  end
end
