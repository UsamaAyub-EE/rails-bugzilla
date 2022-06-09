# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  include Pundit
  protect_from_forgery with: :exception

  rescue_from Pundit::NotAuthorizedError do
    redirect_to root_url, alert: 'You do not have access to this page'
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  end
end
