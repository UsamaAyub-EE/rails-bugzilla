# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :type, presence: true
  validates :name, presence: true, length: { maximum: 50 }
  validate :valid_type

  def valid_type
    errors.add(:type, 'must be Manager, Developer, or Qa') unless manager? || developer? || qa?
  end

  def manager?
    type == 'Manager'
  end

  def developer?
    type == 'Developer'
  end

  def qa?
    type == 'Qa'
  end
end
