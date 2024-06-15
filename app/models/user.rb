class User < ApplicationRecord
  validates :name, presence: true, length: { maximum: 30 }
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP },
                    uniqueness: { case_sensitive: false }



  has_many :memberships, dependent: :destroy
  has_many :organizations, through: :memberships

  normalizes :name, with: ->(name) { name.strip }
  normalizes :email, with: ->(email) { email.strip.downcase }  

  has_secure_password

  validates :password, presence: true, length: { minimum: 8}

end
