class Organization < ApplicationRecord
  has_many :users, dependent: :destroy
  has_many :projects, dependent: :destroy
  
  validates :name, presence: true
  validates :plan, inclusion: { in: %w[free premium] }
  
  def admin_users
    users.where(role: 'admin')
  end
  
  def employee_users
    users.where(role: 'employee')
  end
  
  def free_plan?
    plan == 'free'
  end
  
  def premium_plan?
    plan == 'premium'
  end
  
  def can_create_project?
    premium_plan? || projects.count < 1
  end
  
  def upgrade_to_premium!
    update!(plan: 'premium')
  end
  
  def downgrade_to_free!
    update!(plan: 'free')
  end
  
  # Compatibility methods for views expecting subscription attributes
  def subscription_plan
    plan
  end
  
  def subscription_status
    plan == 'free' ? 'free' : 'active'
  end
  
  def project_limit
    free_plan? ? 1 : nil
  end
end
