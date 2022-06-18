# frozen_string_literal: true

class Developer < User
  has_many :bugs, dependent: :nullify
  has_many :assignments, :class_name => 'Assignment'
  has_many :projects, through: :assignments

  scope :dev_project?, ->(project_id, dev_id) { includes(:projects).where('projects.id = ?', project_id).references(:projects).where('Developer_id = ? ', dev_id).exists? }
end
