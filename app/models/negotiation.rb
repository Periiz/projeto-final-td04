class Negotiation < ApplicationRecord
  belongs_to :product
  belongs_to :collaborator

  ############
  ###Collaborator é o COMPRADOR
  ###Se eu quiser saber o vendedor, tenho que acessar o PRODUTO antes
  ############

  enum status:{waiting: 0, negotiating: 10, sold: 20, canceled: 30}

  def seller_name
    product.collaborator.name
  end

  def seller_email
    product.collaborator.email
  end
end