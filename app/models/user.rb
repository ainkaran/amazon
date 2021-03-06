class User < ApplicationRecord

  has_many :products, dependent: :nullify
  has_many :reviews, dependent: :nullify

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

  has_secure_password

  validates :email, presence: true, uniqueness: true, format: VALID_EMAIL_REGEX

  validates :first_name, :last_name, presence: true

  def full_name
    "#{first_name.capitalize} #{last_name.capitalize}"
  end
end
