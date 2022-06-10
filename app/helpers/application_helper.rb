# frozen_string_literal: true

module ApplicationHelper
  def active_class(path)
    if request.path == path
      return 'active'
    else
      return ''
    end
  end
end
