class User < ApplicationRecord
  acts_as_tenant :organization
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable, :invitable
         
  belongs_to :organization, optional: true
  
  validates :role, inclusion: { in: %w[admin employee] }
  validates :first_name, :last_name, presence: true, if: :persisted?
  
  def full_name
    "#{first_name} #{last_name}".strip
  end
  
  def admin?
    role == 'admin'
  end
  
  def employee?
    role == 'employee'
  end
  
  def can_manage_organization?
    admin?
  end
  
  def can_invite_users?
    admin?
  end
  
  # Override Devise method to set organization from current tenant
  def self.invite!(attributes = {}, invited_by = nil)
    invitable = new(attributes)
    invitable.organization = ActsAsTenant.current_tenant if ActsAsTenant.current_tenant
    invitable.skip_invitation = false
    invitable.invite!(invited_by)
    invitable
  end
end
