class Message < ApplicationRecord
  belongs_to :collaborator
  belongs_to :negotiation

  validates :text, presence: true
end
