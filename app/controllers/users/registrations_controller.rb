# frozen_string_literal: true

module Users
  class RegistrationsController < Devise::RegistrationsController
    include Accessible
    skip_before_action :check_resource, except: %i[new create]
  end
end
