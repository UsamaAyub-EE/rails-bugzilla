# frozen_string_literal: true

class BugPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def index?
    user.developer? || user.qa?
  end

  def show?
    if user.developer?
      Developer.includes(:projects).where("projects.id = ?" ,record.project_id).references(:projects).where("Developer_id = ? ",user.id).exists?
    elsif user.qa?
      true
    end
  end

  def create?
    user.qa?
  end

  def update?
    show?
  end

  def destroy?
    create?
  end

  def new?
    create?
  end

  def edit?
    create?
  end

  def mark_as_resolved?
    show? && user.developer?
  end
end
