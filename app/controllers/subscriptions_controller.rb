class SubscriptionsController < ApplicationController
  before_action :require_admin
  before_action :set_organization
  
  def show
    @subscription = @organization
    @plans = {
      'starter' => {
        name: 'Starter',
        price: 29,
        project_limit: 5,
        features: ['Up to 5 projects', 'Basic file uploads', 'Email support']
      },
      'professional' => {
        name: 'Professional', 
        price: 79,
        project_limit: 25,
        features: ['Up to 25 projects', 'Advanced file uploads', 'Priority support', 'Team collaboration']
      },
      'enterprise' => {
        name: 'Enterprise',
        price: 199,
        project_limit: nil,
        features: ['Unlimited projects', 'Advanced file uploads', '24/7 phone support', 'Custom integrations', 'Dedicated account manager']
      }
    }
  end
  
  def edit
    @subscription = @organization
  end
  
  def create_checkout_session
    plan = params[:plan]
    
    unless ['starter', 'professional', 'enterprise'].include?(plan)
      redirect_to subscription_path, alert: 'Invalid plan selected.'
      return
    end
    
    price_ids = {
      'starter' => Rails.application.config.x.stripe[:starter_price_id],
      'professional' => Rails.application.config.x.stripe[:professional_price_id],
      'enterprise' => Rails.application.config.x.stripe[:enterprise_price_id]
    }
    
    begin
      session = Stripe::Checkout::Session.create({
        payment_method_types: ['card'],
        line_items: [{
          price: price_ids[plan],
          quantity: 1,
        }],
        mode: 'subscription',
        success_url: subscription_url + '?session_id={CHECKOUT_SESSION_ID}',
        cancel_url: subscription_url,
        customer_email: current_user.email,
        metadata: {
          organization_id: current_organization.id,
          plan: plan
        }
      })
      
      redirect_to session.url, allow_other_host: true
    rescue Stripe::InvalidRequestError => e
      redirect_to subscription_path, alert: "Error creating checkout session: #{e.message}"
    end
  end
  
  def success
    session_id = params[:session_id]
    
    if session_id
      begin
        session = Stripe::Checkout::Session.retrieve(session_id)
        
        if session.metadata.organization_id == current_organization.id.to_s
          @organization.update!(
            stripe_customer_id: session.customer,
            subscription_plan: session.metadata.plan,
            subscription_status: 'active'
          )
          
          redirect_to subscription_path, notice: 'Subscription activated successfully!'
        else
          redirect_to subscription_path, alert: 'Invalid session.'
        end
      rescue Stripe::InvalidRequestError => e
        redirect_to subscription_path, alert: "Error processing subscription: #{e.message}"
      end
    else
      redirect_to subscription_path
    end
  end
  
  def manage_billing
    if @organization.stripe_customer_id.present?
      begin
        session = Stripe::BillingPortal::Session.create({
          customer: @organization.stripe_customer_id,
          return_url: subscription_url,
        })
        
        redirect_to session.url, allow_other_host: true
      rescue Stripe::InvalidRequestError => e
        redirect_to subscription_path, alert: "Error accessing billing portal: #{e.message}"
      end
    else
      redirect_to subscription_path, alert: 'No billing information found.'
    end
  end
  
  private
  
  def set_organization
    @organization = current_organization
  end
end
