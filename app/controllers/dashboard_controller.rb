class DashboardController < ApplicationController
  def index
    @organization = current_user.organization
    if current_organization
      @projects = current_organization.projects
      @recent_projects = current_organization.projects.recent.limit(5)
      @user_count = current_organization.users.count
      @project_count = current_organization.projects.count
      @active_projects_count = current_organization.projects.where(status: 'active').count
      @completed_projects_count = current_organization.projects.where(status: 'completed').count
    else
      @projects = []
      @recent_projects = []
      @user_count = 0
      @project_count = 0
      @active_projects_count = 0
      @completed_projects_count = 0
    end
  end
end
