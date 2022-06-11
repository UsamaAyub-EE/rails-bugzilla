# frozen_string_literal: true

class ProjectsController < ApplicationController
  before_action :authenticate_user!

  before_action :set_user, only: %i[new create edit update]
  before_action :set_project, only: %i[edit update destroy add_developer show remove_developer]
  before_action :set_developers, only: %i[show]
  def index
    @projects = policy_scope(Project)
    authorize @projects
  end

  def new
    @project = @user.projects.new
    authorize @project
  end

  def create
    @project = @user.projects.new(project_params)
    authorize @project
    if @project.save
      redirect_to user_projects_path(current_user), info: 'Project was Created Successfully!'
    else
      render :new, project: @project, manager: @user
    end
  end

  def edit; end

  def show; end

  def update
    if @project.update(project_params)
      redirect_to user_projects_path(current_user), info: 'Project was successfully updated.'
    else
      render :edit, project: @project, manager: @user
    end
  end

  def add_developer
    @developer = Developer.find(params[:developer_id])
    authorize @project
    @project.developers << @developer
    redirect_to user_project_path(current_user, params[:id]), info: 'Developer was successfully added.'
  end

  def remove_developer
    @developer = Developer.find(params[:developer_id])
    authorize @project
    @project.developers.delete(@developer)
    redirect_to user_project_path(current_user, params[:id]), info: 'Developer was successfully removed.'
  end

  def destroy
    @project.destroy
    redirect_to user_projects_path(current_user), info: 'Project was successfully destroyed.'
  end

  private

  def project_params
    params.require(:project).permit(:name, :user_id)
  end

  def set_user
    @user = current_user
  end

  def set_project
    @project = Project.find(params[:id])
    authorize @project
  end

  def set_developers
    @developers = Developer.all
  end
end
