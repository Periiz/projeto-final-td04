class NegotiationsController < ApplicationController
  def index
    @seller_negotiations = Negotiation.where('seller_id = ?', current_collaborator.id).where.not(status: :canceled).where.not(status: :sold)
    @buyer_negotiations = Negotiation.where('collaborator_id = ?', current_collaborator.id).where.not(status: :canceled).where.not(status: :sold)
  end

  def show
    @negotiation = Negotiation.find(params[:id])
  end

  def new
    @product = Product.find(params[:product_id])
    @negotiation = Negotiation.new

  end

  def edit
    @negotiation = Negotiation.find(params[:id])
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

  def update
    @negotiation = Negotiation.find(params[:id])
    @negotiation.date_of_end = DateTime.current

    if @negotiation.final_price.present?
      @negotiation.sold!
      @negotiation.product.sold!
      @negotiation.date_of_end = DateTime.current
    end

    if @negotiation.update(negotiation_params)
      redirect_to @negotiation
    else
      redirect_to root_path, notice: 'Algo deu errado! :('
    end
  end

  private

  def negotiation_params
    params.permit(:product_id, :collaborator_id, :status, :seller_id,
                  :date_of_start, :date_of_end, :final_price)
  end
end
