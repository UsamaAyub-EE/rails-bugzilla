# frozen_string_literal: true

module ApplicationHelper
  def active_class(path)
    if request.path == path
      'active'
    else
      ''
    end
  end
end
