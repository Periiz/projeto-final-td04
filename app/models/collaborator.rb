class Collaborator < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :products

  def profile_filled?
    if full_name.present? and social_name.present? and birth_date.present? and position.present? and sector.present?
      return true
    end
    false
  end

  def domain
    email.split('@').last
  end

  def name
    social_name
  end
end
