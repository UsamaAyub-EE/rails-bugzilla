# frozen_string_literal: true

class Project < ApplicationRecord
  validates :name, presence: true
  validates :name, uniqueness: true

  belongs_to :manager
  has_many :bugs, dependent: :destroy
  has_and_belongs_to_many :developers
end
