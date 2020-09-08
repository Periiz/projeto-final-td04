class Comment < ApplicationRecord
  belongs_to :product
  belongs_to :collaborator

  validates :text, presence: true
end
