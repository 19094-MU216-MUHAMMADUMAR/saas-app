class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy, :remove_file]
  before_action :check_project_limit, only: [:new, :create]
  
  def index
    @projects = current_organization.projects.recent
  end
  
  def show
  end
  
  def new
    @project = current_organization.projects.build
  end
  
  def create
    @project = current_organization.projects.build(project_params)
    
    if @project.save
      redirect_to @project, notice: 'Project was successfully created.'
    else
      render :new
    end
  end
  
  def edit
  end
  
  def update
    if @project.update(project_params)
      redirect_to @project, notice: 'Project was successfully updated.'
    else
      render :edit
    end
  end
  
  def destroy
    @project.destroy
    redirect_to projects_path, notice: 'Project was successfully deleted.'
  end
  
  def remove_file
    file = @project.files.find(params[:attachment_id])
    file.purge
    redirect_to @project, notice: 'File was successfully removed.'
  end

  private  def set_project
    @project = current_organization.projects.find(params[:id])
  end
  
  def project_params
    params.require(:project).permit(:title, :name, :description, :status, :due_date, files: [], images: [])
  end
  
  def check_project_limit
    unless current_organization.can_create_project?
      redirect_to projects_path, alert: 'Upgrade to Premium to create more projects.'
    end
  end
end
