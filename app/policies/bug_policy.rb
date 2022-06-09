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
    user.developer? || user.qa?
  end

  def create?
    user.qa?
  end

  def update?
    user.qa?
  end

  def destroy?
    user.qa?
  end

  def new?
    user.qa?
  end

  def edit?
    user.qa?
  end

  def pick_developer?
    user.developer?
  end

  def drop_developer?
    user.developer?
  end

  def mark_as_resolved?
    user.developer?
  end
end
