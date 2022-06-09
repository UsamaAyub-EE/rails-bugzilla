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
    if @user.manager? || @user.developer?
      @user.projects.include?(@record)
    elsif @user.qa?
      true
    end
  end

  def create?
    @user.manager?
  end

  def update?
    show?
  end

  def destroy?
    show?
  end

  def new?
    @user.manager?
  end

  def edit?
    show?
  end

  def add_developer?
    show?
  end

  def remove_developer?
    show?
  end

  def mark_as_resolved?
    show?
  end

  def pick_developer?
    show?
  end

  def drop_developer?
    show?
  end
end
