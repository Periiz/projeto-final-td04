class Product < ApplicationRecord
  belongs_to :product_category
  belongs_to :collaborator
  has_many :negotiations
  has_many :comments
  has_many_attached :photos
  #after_commit :add_seller_domain, on: [:create]

  validates :name, :description, :sale_price, :product_category, presence: true
  validates :sale_price, numericality: { greater_than_or_equal_to: 0 }

  enum status: {avaiable: 0, invisible: 10, sold: 20, canceled: 30}

  def seller_name
    collaborator.name
  end

  def seller_email
    collaborator.email
  end

  def first_photo
    photos.empty? ? 'default_product.png' : photos.first.variant(resize: '200x400').processed
  end

#  private
#
#  def add_seller_domain
#    seller_domain = collaborator.domain
#  end
end
