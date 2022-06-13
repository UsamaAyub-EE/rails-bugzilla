# frozen_string_literal: true

class Qa < User
  has_many :bugs, dependent: :nullify
end
