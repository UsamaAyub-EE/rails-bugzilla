# frozen_string_literal: true

class Bug < ApplicationRecord
  belongs_to :developer, optional: true
  belongs_to :qa
  belongs_to :project
  has_one_attached :screenshot

  scope :unassigned, -> { where(developer_id: nil) }
  scope :picked, ->(dev_id) { where(developer_id: dev_id) }

  validates :title, presence: true, length: { maximum: 50 }
  validates :kind, :stature, presence: true
  validates :title, uniqueness: { scope: :project_id }

  validate :acceptable_screenshot
  validate :future_deadline

  def future_deadline
    errors.add(:deadline, 'must be in the future') if deadline && deadline < Time.now
  end

  def acceptable_screenshot
    if screenshot.attached?
      acceptable_types = ['image/gif', 'image/png']
      errors.add(:screenshot, 'must be a GIF or PNG') unless acceptable_types.include?(screenshot.content_type)
      errors.add(:screenshot, 'is too big') unless screenshot.byte_size <= 5.megabyte
    end
  end

  before_update :update_status

  def update_status
    if self.developer_id.nil?
      self.stature = stature == 'Started' ? 'New' : stature
    else
      self.stature = (stature == 'Completed' || stature == 'Resolved') ? stature : 'Started'
    end
  end
end
