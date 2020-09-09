class NegotiationsController < ApplicationController
  before_action :authenticate_collaborator!
  before_action :set_negotiation, only: [:show, :confirm, :sold,
                                         :negotiating, :canceled]

  def index
    @seller_negotiations = Negotiation.where('seller_id = ?', current_collaborator.id)
                                      .where.not(status: :canceled).where.not(status: :sold)
    @buyer_negotiations = Negotiation.where('collaborator_id = ?', current_collaborator.id)
                                     .where.not(status: :canceled).where.not(status: :sold)
  end

  def show
    @messages = Message.where(negotiation_id: params[:id])
  end

  def new
    @product = Product.find(params[:product_id])
    @negotiation = Negotiation.new
  end

  def create
    @product = Product.find(params[:product_id])
    @negotiation = Negotiation.new(negotiation_params)

    @negotiation.collaborator = current_collaborator
    @negotiation.date_of_start = DateTime.current
    @negotiation.product = @product
    @negotiation.seller_id = @negotiation.product.collaborator.id

    if @negotiation.save
      redirect_to @negotiation, notice: 'Negociação iniciada'
    else
      redirect_to root_path, notice: 'Deu algo errado!'
    end
  end

  ###Métodos para mudar o estado
  ###################

  def confirm
  end

  def sold
    @negotiation.final_price = params[:negotiation][:final_price]
    @negotiation.date_of_end = DateTime.current
    @negotiation.sold!
    @negotiation.product.sold!

    if @negotiation.save
      redirect_to @negotiation
    else
      redirect_to root_path, notice: 'Algo deu errado! :('
    end
  end

  def negotiating
    @negotiation.negotiating!
    redirect_to @negotiation
  end

  def canceled
    @negotiation.canceled!
    @negotiation.update(date_of_end: DateTime.current)
    redirect_to @negotiation
  end

  private

  def negotiation_params
    params.permit(:product_id, :collaborator_id, :status, :seller_id,
                  :date_of_start, :date_of_end, :final_price)
  end

  def set_negotiation
    @negotiation = Negotiation.find(params[:id])
  end
end
