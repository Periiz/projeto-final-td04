class CollaboratorsController < ApplicationController
  def show
    @collaborator = Collaborator.find(params[:id])
  end

  def edit
    @collaborator = Collaborator.find(params[:id])
  end

  def update
    @collaborator = Collaborator.find(params[:id])
    if @collaborator.update(collaborator_params)
      flash[:notice] = 'Perfil preenchido com sucesso!' if @collaborator.profile_filled?
      redirect_to @collaborator
    else
      render :edit
    end
  end

  private

  def collaborator_params
    params.require(:collaborator)
          .permit(:full_name, :social_name,
                  :birth_date, :position, :sector)
  end
end
