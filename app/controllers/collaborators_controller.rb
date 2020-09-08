class CollaboratorsController < ApplicationController
  before_action :authenticate_collaborator!
  before_action :set_collaborator, only: [:show, :edit, :update, :products]

  def show
  end

  def edit
  end

  def update
    if @collaborator.update(collaborator_params)
      #@collaborator.avatar.attach(FOTO PADRÃO) if params[:avatar].blank?
      flash[:notice] = 'Perfil preenchido com sucesso!' if @collaborator.profile_filled?
      redirect_to @collaborator
    else
      render :edit
    end
  end

  def products
    @products = Product.where('collaborator_id = ?', @collaborator.id)
                       .not_canceled.not_sold
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
          .permit(:full_name, :social_name, :avatar,
                  :birth_date, :position, :sector)
  end

  def set_collaborator
    @collaborator = Collaborator.find(params[:id])
  end
end
