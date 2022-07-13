# frozen_string_literal: true

class ProjectsController < ApplicationController
  before_action :authenticate_user!

  before_action :set_project, only: %i[edit update destroy show project_assignment]
  def index
    @projects = policy_scope(Project)
    authorize @projects
  end

  def show
    @developers = Developer.all
  end

  def new
    @project = Project.new
    authorize @project
  end

  def create
    @project = Project.new(project_params)
    authorize @project
    @project.manager_id = current_user.id
    render :new, project: @project, manager: current_user and return unless @project.save

    redirect_to user_projects_path(current_user), info: 'Project was successfully created.'
  end

  def project_assignment
    assignment = Assignment.find_or_initialize_by(project_id: @project.id, developer_id: params[:developer_id])
    if assignment.new_record?
      if assignment.save
        redirect_to user_project_path(current_user, params[:id]), info: 'Developer was successfully added.'
      else
        redirect_to user_project_path(current_user, params[:id]), danger: 'Developer was not added.'
      end
    elsif assignment.destroy
      redirect_to user_project_path(current_user, params[:id]), info: 'Developer was successfully removed.'
    else
      redirect_to user_project_path(current_user, params[:id]), danger: 'Developer was not removed.'
    end
  end

  def update
    if @project.update(project_params)
      redirect_to user_projects_path(current_user), info: 'Project was successfully updated.'
    else
      render :edit, project: @project, manager: current_user
    end
  end

  def destroy
    if @project.destroy
      redirect_to user_projects_path(current_user), info: 'Project was successfully destroyed.'
    else
      redirect_to user_projects_path(current_user), danger: 'Project was not destroyed.'
    end
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
