# frozen_string_literal: true

class Developer < User
  has_many :bugs, dependent: :nullify
  has_many :assignments, :class_name => 'Assignment'
  has_many :projects, through: :assignments
end
