class Collaborator < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :products

  validates :notifications_number, numericality: { greater_than_or_equal_to: 0 }

  def profile_filled?
    if full_name.present? and social_name.present? and
       birth_date.present? and position.present? and sector.present?
      return true
    end
    false
  end

  def domain
    email.split('@').last
  end

  def name
    return social_name if social_name
    return full_name if full_name
    ''
  end

  def notif_count
    Negotiation.where('seller_id = ?', self.id).where(status: :waiting).count
  end
end
