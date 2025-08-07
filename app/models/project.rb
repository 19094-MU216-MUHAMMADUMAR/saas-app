class Project < ApplicationRecord
  acts_as_tenant :organization
  
  belongs_to :organization
  has_many_attached :files
  has_many_attached :images
  
  validates :title, presence: true
  validates :description, presence: true
  validates :status, inclusion: { in: %w[planning active on_hold completed] }
  
  scope :recent, -> { order(created_at: :desc) }
  
  # Set default status
  after_initialize :set_defaults
  
  # Alias for backward compatibility with views
  def name
    title
  end
  
  def name=(value)
    self.title = value
  end
  
  private
  
  def set_defaults
    self.status ||= 'planning' if new_record?
  end
end
