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
      user.projects.pluck(:id).include?(record.project_id)
    elsif user.qa?
      true
    end
  end

  def create?
    user.qa?
  end

  def update?
    user.qa? || (user.developer? && show?)
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

  def pick_developer?
    show?
  end

  def drop_developer?
    show?
  end

  def mark_as_resolved?
    show?
  end
end
