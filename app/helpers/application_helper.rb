# frozen_string_literal: true

module ApplicationHelper
  def active_class(path)
    if request.path == path
      'active'
    else
      ''
    end
  end

  def assigned?(project, developer)
    Assignment.where(project_id: project.id, developer_id: developer.id).exists?
  end
end
