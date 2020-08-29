class CollaboratorsController < ApplicationController
  def show
  end

  def edit
    @collaborator = current_collaborator
  end

  def update
    @collaborator = current_collaborator
    @collaborator.save
  end
end
