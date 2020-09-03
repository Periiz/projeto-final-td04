class NegotiationsController < ApplicationController
  def index
    @negotiations = Negotiation.where('collaborator_id = ? OR product.collaborator_id = ?',
                                      current_collaborator.id, current_collaborator.id)
  end

  def show
    @negotiation = Negotiation.find(params[:id])
  end

  def new
    @negotiation = Negotiation.new
    @product = Product.find(params[:product_id])
  end

  def create
    @negotiation = Negotiation.new(negotiation_params)
    @negotiation.collaborator = current_collaborator
    @negotiation.date_of_start = DateTime.current

    if @negotiation.save
      vendedor = @negotiation.product.collaborator
      vendedor.notifications_number += 1
      redirect_to @negotiation, notice: 'Negociação iniciada'
    else
      redirect_to root_path, notice: 'Deu algo errado!'
    end
  end

  private

  def negotiation_params
    params.permit(:product_id, :collaborator_id,
                  :date_of_start, :status)
  end
end
