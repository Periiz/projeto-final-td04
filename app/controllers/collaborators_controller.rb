class CollaboratorsController < ApplicationController
  before_action :authenticate_collaborator!

  def show
    @collaborator = Collaborator.find(params[:id])
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

  def products
    @collaborator = Collaborator.find(params[:id])
    @products = Product.where('collaborator_id = ?', @collaborator.id)
                       .where.not(status: :canceled).where.not(status: :sold)
  end

  def history
    if params.has_key?(:q)
      coluna = (params[:q] == 'vendidos') ? 'seller_id' : 'collaborator_id'
      @negotiations = Negotiation.where("#{coluna} = ?", params[:id]).sold
    else
      @negotiations = []
    end
  end

  private

  def collaborator_params
    params.require(:collaborator)
          .permit(:full_name, :social_name,
                  :birth_date, :position, :sector)
  end
end
