# frozen_string_literal: true

class ProjectsController < ApplicationController
  before_action :authenticate_user!

  before_action :set_project, only: %i[edit update destroy show]
  def index
    @projects = policy_scope(Project)
    authorize @projects
  end

  def show
    @developers = Developer.all
  end

  def new
    @project = current_user.projects.new
    authorize @project
  end

  def create
    @project = current_user.projects.new(project_params)
    authorize @project
    render :new, project: @project, manager: current_user and return unless @project.save

    redirect_to user_projects_path(current_user), info: 'Project was successfully created.'
  end

  def update
    if params[:developer_id].present?
      assignment = Assignment.where('project_id = ? AND developer_id = ?', @project.id, params[:developer_id])
      if assignment.exists?
        redirect_to user_project_path(current_user, params[:id]), danger: 'Developer was not removed.' and return unless assignment.destroy_all

        redirect_to user_project_path(current_user, params[:id]), info: 'Developer was successfully removed.'
      else
        redirect_to user_project_path(current_user, params[:id]), danger: 'Developer was not added.' and return unless Assignment.new(project_id: @project.id, developer_id: params[:developer_id]).save

        redirect_to user_project_path(current_user, params[:id]), info: 'Developer was successfully added.'
      end
    elsif @project.update(project_params)
      redirect_to user_projects_path(current_user), info: 'Project was successfully updated.'
    else
      render :edit, project: @project, manager: current_user
    end
  end

  def destroy
    redirect_to user_projects_path(current_user), danger: 'Project was not destroyed.' and return unless @project.destroy

    redirect_to user_projects_path(current_user), info: 'Project was successfully destroyed.'
  end

  private

  def project_params
    params.require(:project).permit(:name, :user_id)
  end

  def set_project
    @project = Project.find(params[:id])
    authorize @project
  end
end
