class Listing < ApplicationRecord
  belongs_to :creator, class_name: "User"
  belongs_to :organization

  include HasAddress, PermittedAttributes

  has_one_attached :cover_photo
  has_rich_text :description


  enum condition: {
    mint: "mint", near_mint: "near_mint", used: "used", defective: "defective"
  }

  validates :title, length: { in: 10..100 }
  validates :price, numericality: { only_integer: true }
  validates :tags, length: { in: 1..5 }
  validates :cover_photo, presence: true
  validates :description, presence: true


  before_save :downcase_tags

  scope :feed, -> { order(created_at: :desc).includes(:address) }

  private 

    def downcase_tags
      self.tags = tags.map(&:downcase)
    end

end
