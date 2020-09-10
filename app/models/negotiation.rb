class Negotiation < ApplicationRecord
  belongs_to :product
  belongs_to :collaborator
  has_many :messages

  before_validation :add_date_of_start, :add_seller_id, on: :create
  after_update :check_product_status

  ############
  ###Collaborator é o COMPRADOR
  ###Se eu quiser saber o vendedor, tenho que acessar o PRODUTO antes
  ############

  validates :product_id, :collaborator_id, :date_of_start, :seller_id, presence: true

  enum status: {waiting: 0, negotiating: 10, sold: 20, canceled: 30}

  def seller_name
    product.collaborator.name
  end

  def seller_email
    product.collaborator.email
  end

  def buyer_name
    collaborator.name
  end

  def buyer_email
    collaborator.email
  end

  def buyer_id
    collaborator.id
  end

  private

  def add_date_of_start
    self.date_of_start = DateTime.current if date_of_start.nil?
  end

  def add_seller_id
    self.seller_id = product.collaborator.id if seller_id.nil?
  end

  def check_product_status
    if self.canceled?
      product.avaiable!
      product.update(buyer_id: -1)
    elsif self.sold?
      product.sold!
    elsif self.negotiating?
      product.negotiating!
    end
  end
end
