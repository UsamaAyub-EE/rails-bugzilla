# frozen_string_literal: true

class Developer < User
  has_many :bugs
  has_and_belongs_to_many :projects
end
