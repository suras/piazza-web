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
require "test_helper"

class ConversationTest < ActiveSupport::TestCase
   setup do
      @buyer = organizations(:jerry)
      @listing = listings(:auto_listing_1_george)
   end

   test "sets seller on creation" do
    @conversation = Conversation.create(
      buyer: @buyer,
      listing: @listing
      )
      assert @conversation.persisted?
      assert_equal @listing.organization, @conversation.seller
   end

end
