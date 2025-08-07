class OrganizationsController < ApplicationController
  before_action :require_admin, except: [:show]
  before_action :set_organization
  
  def show
  end
  
  def edit
  end
  
  def update
    if @organization.update(organization_params)
      redirect_to organization_path, notice: 'Organization was successfully updated.'
    else
      render :edit
    end
  end
  
  private
  
  def set_organization
    @organization = current_organization
  end
  
  def organization_params
    params.require(:organization).permit(:name, :description)
  end
end
