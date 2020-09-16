class CollaboratorsController < ApplicationController
  before_action :set_collaborator, only: [:show, :edit, :update, :products]
  before_action :verify_yourself, only: [:edit, :update]

  def show
  end

  def edit
  end

  def update
    if @collaborator.update(collaborator_params)
      redirect_to @collaborator, notice: 'Perfil preenchido com sucesso!' if @collaborator.profile_filled?
    else
      render :edit
    end
  end

  def products
    @products = Product.where(collaborator: @collaborator)
                       .not_canceled.not_sold
  end

  def history
    @products = Product.where(collaborator: current_collaborator).canceled if params[:r]
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

  def verify_yourself
    #OPTMIZE Eu tinha escrito simplesmente params[:id] == current_collaborator.id,
    #OPTMIZE mas por algum motivo que eu não consigo entender, não ta funcionando! D:
    if not params[:id].to_i == current_collaborator.id
      redirect_to root_path, notice: 'Você não tem permissão pra isso'
    end
  end
end
