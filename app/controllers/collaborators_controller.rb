class CollaboratorsController < ApplicationController
  def show
    @collaborator = current_collaborator
  end

  def edit
    @collaborator = current_collaborator
  end

  def update
    @collaborator = current_collaborator
    if @collaborator.update(collaborator_params)
      flash[:notice] = 'Perfil preenchido com sucesso!' if @collaborator.profile_filled?
      redirect_to @collaborator
    else
      render :edit
    end
  end

  def all_products
    @collaborator = current_collaborator
    @products = Product.where('collaborator_id = ?', current_collaborator.id)
  end

  private

  def collaborator_params
    params.require(:collaborator)
          .permit(:full_name, :social_name,
                  :birth_date, :position, :sector)
  end
end
