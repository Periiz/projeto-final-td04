class Collaborator < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :products

  validates :full_name, :social_name, :position, :sector, presence: true, allow_nil: true
        #Pode ser nulo (logo quando cria) mas não pode ser blank (string vazia)

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
    social_name ? social_name : full_name
  end

  def notif_count
    Negotiation.where('seller_id = ?', self.id).where(status: :waiting).count
  end
end
