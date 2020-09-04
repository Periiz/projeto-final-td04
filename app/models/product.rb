class Product < ApplicationRecord
  belongs_to :product_category
  belongs_to :collaborator
  has_many :negotiations

  validates :name, :description, :sale_price, :product_category, presence: true
  validates :sale_price, numericality: { greater_than_or_equal_to: 0 }

  enum status: {avaiable: 0, sold: 20, invisible: 30}

  def seller_name
    collaborator.name
  end

  def seller_email
    collaborator.email
  end
end
