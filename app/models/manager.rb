# frozen_string_literal: true

class Manager < User
  has_many :projects
end
