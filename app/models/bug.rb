# frozen_string_literal: true

class Bug < ApplicationRecord
  belongs_to :developer, optional: true
  belongs_to :qa
  belongs_to :project
  has_one_attached :screenshot

  validates :title, :kind, :stature, presence: true
  validate :unique_title_per_project, on: :create

  def unique_title_per_project
    errors.add(:title, 'must be unique per project') if Bug.where(title: title, project_id: project_id).exists?
  end
end
