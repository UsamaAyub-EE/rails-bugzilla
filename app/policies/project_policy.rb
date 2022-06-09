# frozen_string_literal: true

class ProjectPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if @user.manager?
        scope.where(manager_id: @user.id)
      elsif @user.developer?
        @user.projects
      elsif @user.qa?
        scope.all
      end
    end
  end

  def index?
    true
  end

  def show?
    @user.manager? || @user.developer? || @user.qa?
  end

  def create?
    @user.manager?
  end

  def update?
    @user.manager?
  end

  def destroy?
    @user.manager?
  end

  def new?
    @user.manager?
  end

  def edit?
    @user.manager?
  end

  def add_developer?
    @user.manager?
  end

  def remove_developer?
    @user.manager?
  end

  def mark_as_resolved?
    @user.developer?
  end

  def pick_developer?
    @user.developer?
  end

  def drop_developer?
    @user.developer?
  end
end
