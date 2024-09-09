# == Schema Information
#
# Table name: listings
#
#  id              :bigint           not null, primary key
#  condition       :enum
#  price           :integer
#  published_on    :datetime
#  status          :enum             default("published")
#  tags            :string           is an Array
#  title           :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  creator_id      :bigint
#  organization_id :bigint           not null
#
# Indexes
#
#  index_listings_on_creator_id       (creator_id)
#  index_listings_on_organization_id  (organization_id)
#
# Foreign Keys
#
#  fk_rails_...  (creator_id => users.id)
#  fk_rails_...  (organization_id => organizations.id)
#
class Listing < ApplicationRecord
  belongs_to :creator, class_name: "User"
  belongs_to :organization

  include HasAddress, PermittedAttributes, AccessPolicy, Publishable, Expireable, Renewable

  has_one_attached :cover_photo
  has_rich_text :description


  enum condition: {
    mint: "mint", near_mint: "near_mint", used: "used", defective: "defective"
  }

  enum status: {
    draft: "draft", published: "published", expired: "expired"
  }

  validates :title, length: { in: 10..100 }
  validates :price, numericality: { only_integer: true }
  validates :tags, length: { in: 1..5 }
  validates :cover_photo, presence: true
  validates :description, presence: true


  before_save :downcase_tags

  scope :feed, -> { published.order(created_at: :desc).includes(:address) }

  def saved?
    return false unless Current.user.present?

    Current.user.saved_listings.exists?(id: self.id)
  end

  def expiry_date
    published_on.end_of_day + 30.days
  end

  private 

    def downcase_tags
      self.tags = tags.map(&:downcase)
    end

end
