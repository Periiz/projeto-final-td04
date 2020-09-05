class Comment < ApplicationRecord
  belongs_to :product
  has_one :collaborator

  validates :text, presence: true
end
