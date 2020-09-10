class Comment < ApplicationRecord
  belongs_to :product
  belongs_to :collaborator

  before_create :add_post_date

  validates :text, presence: true

  private

  def add_post_date
    self.post_date = DateTime.current
  end
end
