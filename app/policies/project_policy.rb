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
    show? && @user.manager?
  end

  def destroy?
    update?
  end

  def new?
    @user.manager?
  end

  def edit?
    update?
  end

  def mark_as_resolved?
    show? && @user.developer?
  end
end
