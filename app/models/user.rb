class User < ApplicationRecord

  include Authentication, PasswordReset, Activation, PermittedAttributes

  validates :name, presence: true, length: { maximum: 30 }
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP },
                    uniqueness: { case_sensitive: false }

  has_many :memberships, dependent: :destroy
  has_many :organizations, through: :memberships

  normalizes :name, with: ->(name) { name.strip }
  normalizes :email, with: ->(email) { email.strip.downcase }  

  before_validation :strip_extraneous_spaces

  has_one_attached :profile_photo

  has_and_belongs_to_many :saved_listings, join_table: "saved_listings", class_name: "Listing"
 
  private 

  def strip_extraneous_spaces
    self.name = self.name&.strip
    self.email = self.email&.strip
  end

end
