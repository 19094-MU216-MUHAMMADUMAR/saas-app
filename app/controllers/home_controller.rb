class HomeController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]
  skip_before_action :set_tenant, only: [:index]
  
  def index
    if user_signed_in?
      redirect_to dashboard_path
    else
      # Show marketing page for non-authenticated users
      @plans = [
        {
          name: "Free Plan",
          price: "Free",
          currency: "",
          period: "",
          features: [
            "1 project",
            "Unlimited employees", 
            "File uploads",
            "Basic support"
          ],
          button_text: "Get Started",
          button_class: "btn-outline-primary",
          popular: false
        },
        {
          name: "Premium Plan", 
          price: "10",
          currency: "$",
          period: "/month",
          features: [
            "Unlimited projects",
            "Unlimited employees",
            "File uploads",
            "Priority support",
            "Advanced analytics"
          ],
          button_text: "Start Premium",
          button_class: "btn-primary",
          popular: true
        }
      ]
    end
  end
end
