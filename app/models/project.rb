# frozen_string_literal: true

class Project < ApplicationRecord
  validates :name, presence: true, length: { maximum: 50 }
  validates :name, uniqueness: true

  belongs_to :manager
  has_many :bugs, dependent: :destroy
  has_many :assignments, :class_name => 'Assignment'
  has_many :developers, through: :assignments
end
