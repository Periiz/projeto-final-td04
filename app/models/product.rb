class Product < ApplicationRecord
  belongs_to :product_category
  belongs_to :collaborator

  validates :name, :description, :sale_price, presence: true
  validates :sale_price, numericality: { greater_than_or_equal_to: 0 }

  enum status: {avaiable: 0, confirmed: 10, sold: 20} #TODO Suspended status:30?
end
