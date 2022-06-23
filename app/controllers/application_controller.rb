# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pundit::Authorization

  rescue_from ActiveRecord::RecordNotFound do
    render file: 'public/404.html', status: :not_found
  end
  rescue_from Pundit::NotAuthorizedError do
    render file: 'public/403.html', status: :forbidden
  end

  add_flash_types :danger, :info, :warning, :success, :messages

  before_action :configure_permitted_parameters, if: :devise_controller?

  protect_from_forgery with: :exception

  def after_sign_in_path_for(resource)
    projects_path
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[name type])
  end
end
