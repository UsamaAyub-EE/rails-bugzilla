# frozen_string_literal: true

class BugsController < ApplicationController
  before_action :authenticate_user!

  before_action :set_project,
                only: %i[edit update destroy new create index mark_as_resolved]
  before_action :set_bug, only: %i[show edit update destroy mark_as_resolved]
  def index
    @bugs = policy_scope(Bug).where(project_id: @project.id)
    authorize @bugs
  end

  def new
    @bug = current_user.bugs.new
    authorize @bug
  end

  def create
    @bug = Bug.new(bug_params)
    @bug.project_id = @project.id
    @bug.qa_id = current_user.id
    authorize @bug
    if @bug.save
      redirect_to user_project_bugs_path(current_user, @project), info: 'Bug was successfully created.'
    else
      render :new, bug: @bug, project: @project
    end
  end

  def mark_as_resolved
    updated_status = @bug.kind == 'Feature' ? 'Completed' : 'Resolved'
    if @bug.update(stature: updated_status)
      redirect_to user_project_bug_path(current_user, @project, @bug), info: 'Bug was successfully marked as resolved.'
    else
      redirect_to user_project_bug_path(current_user, @project, @bug), danger: 'Bug was not marked as resolved.'
    end
  end

  def update
    if current_user.developer?
      if @bug.developer.nil?
        updated_status = 'Started' unless @bug.stature == 'Completed' || @bug.stature == 'Resolved'
        if @bug.update(developer_id: current_user.id, stature: updated_status)
          redirect_to user_project_bug_path(current_user, @project, @bug), info: 'Bug was successfully picked up.'
        else
          redirect_to user_project_bug_path(current_user, @project, @bug), danger: 'Bug was not picked up.'
        end
      else
        updated_status = 'New' if @bug.stature == 'Started'
        if @bug.update(developer_id: nil, stature: updated_status)
          redirect_to user_project_bug_path(current_user, @project, @bug), info: 'Bug was successfully dropped.'
        else
          redirect_to user_project_bug_path(current_user, @project, @bug), danger: 'Bug was not dropped.'
        end
      end
    elsif @bug.update(bug_params)
      redirect_to user_project_bugs_path(current_user, @project), info: 'Bug was successfully updated.'
    else
      render :edit, bug: @bug, project: @project
    end
  end

  def destroy
    @bug.destroy
    redirect_to user_project_bugs_path(current_user, @project), info: 'Bug was successfully destroyed.'
  end

  private

  def bug_params
    params.require(:bug).permit(:title, :deadline, :kind, :stature, :project_id, :qa_id, :description, :screenshot)
  end

  def set_project
    @project = Project.find(params[:project_id])
  end

  def set_bug
    @bug = Bug.find(params[:id])
    authorize @bug
  end
end
