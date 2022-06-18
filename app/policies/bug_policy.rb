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
      Developer.dev_project?(record.project_id, user.id)
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

  def bug_assignment?
    user.developer?
  end
end
