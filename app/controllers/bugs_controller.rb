# frozen_string_literal: true

class BugsController < ApplicationController
  before_action :authenticate_user!

  before_action :set_qa, only: %i[create edit update destroy new]
  before_action :set_project,
                only: %i[edit update destroy new create index pick_developer drop_developer mark_as_resolved]
  before_action :set_bug, only: %i[show edit update destroy pick_developer drop_developer mark_as_resolved]
  before_action :set_developer, only: %i[pick_developer drop_developer mark_as_resolved]
  def index
    @bugs = policy_scope(Bug).where(project_id: @project.id)
    authorize @bugs
  end

  def new
    @bug = @qa.bugs.new
    @bug.project_id = @project.id
    @bug.qa_id = @qa.id
  end

  def create
    @bug = Bug.new(bug_params)
    @bug.project_id = @project.id
    @bug.qa_id = @qa.id
    if @bug.save
      redirect_to user_project_bugs_path(@qa, @project), info: 'Bug was successfully created.'
    else
      render :new, bug: @bug, project: @project, qa: @qa
    end
  end

  def edit; end

  def pick_developer
    @bug.developer = @developer
    @bug.stature = 'Started' unless @bug.stature == 'Completed' || @bug.stature == 'Resolved'
    @bug.save(validate: false)
    redirect_to user_project_bugs_path(@developer, @project), info: 'Bug was successfully picked up.'
  end

  def drop_developer
    @bug.developer = nil
    @bug.stature = 'New' if @bug.stature == 'Started'
    @bug.save(validate: false)
    redirect_to user_project_bugs_path(@developer, @project), info: 'Bug was successfully dropped.'
  end

  def mark_as_resolved
    @bug.stature = @bug.kind == 'Feature' ? 'Completed' : 'Resolved'
    @bug.save(validate: false)
    redirect_to user_project_bugs_path(@developer, @project), info: 'Bug was successfully marked as resolved.'
  end

  def update
    if @bug.update(bug_params)
      redirect_to user_project_bugs_path(@qa, @project), info: 'Bug was successfully updated.'
    else
      render :edit, bug: @bug, project: @project, user: @qa
    end
  end

  def destroy
    @bug.destroy
    redirect_to user_project_bugs_path(@qa, @project), info: 'Bug was successfully destroyed.'
  end

  def show; end

  private

  def bug_params
    params.require(:bug).permit(:title, :deadline, :kind, :stature, :project_id, :qa_id, :description, :screenshot)
  end

  def set_qa
    @qa = current_user
  end

  def set_project
    @project = Project.find(params[:project_id])
  end

  def set_bug
    @bug = Bug.find(params[:id])
    authorize @bug
  end

  def set_developer
    @developer = current_user
  end
end
