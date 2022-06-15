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
    if @project.save
      redirect_to user_projects_path(current_user), info: 'Project was Created Successfully!'
    else
      render :new, project: @project, manager: current_user
    end
  end

  def update
    if params.key?(:developer_id)
      @developer = Developer.find(params[:developer_id])
      if @project.developers.include?(@developer)
        @project.developers.delete(@developer)
        redirect_to user_project_path(current_user, params[:id]), info: 'Developer was successfully removed.'
      else
        @project.developers << @developer
        redirect_to user_project_path(current_user, params[:id]), info: 'Developer was successfully added.'
      end
    elsif @project.update(project_params)
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
