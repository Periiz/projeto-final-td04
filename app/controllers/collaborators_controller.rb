class CollaboratorsController < ApplicationController
  def show
  end

  def update
    @collaborator = current_collaborator
    @collaborator.save
    redirect_to @collaborator
  end
end
