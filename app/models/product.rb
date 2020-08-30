class Product < ApplicationRecord
  has_one :product_category #Opcional?
  belongs_to :collaborator

  validates :name, :description, :sale_price, presence: true
  validates :sale_price, numericality: { greater_than_or_equal_to: 0 }
end
