# == Schema Information
#
# Table name: conversations
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  buyer_id   :bigint
#  listing_id :bigint
#  seller_id  :bigint
#
# Indexes
#
#  index_conversations_on_buyer_id                               (buyer_id)
#  index_conversations_on_listing_id                             (listing_id)
#  index_conversations_on_seller_id                              (seller_id)
#  index_conversations_on_seller_id_and_buyer_id_and_listing_id  (seller_id,buyer_id,listing_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (buyer_id => organizations.id)
#  fk_rails_...  (listing_id => listings.id) ON DELETE => cascade
#  fk_rails_...  (seller_id => organizations.id)
#
class Conversation < ApplicationRecord

  include AccessPolicy

  before_validation :set_seller, unless: :persisted?
  
  belongs_to :listing
  belongs_to :seller, class_name: "Organization"
  belongs_to :buyer, class_name: "Organization"

  has_many :messages, dependent: :destroy

  private
  
  def set_seller
    self.seller = listing.organization
  end

end
