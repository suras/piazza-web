# == Schema Information
#
# Table name: messages
#
#  id              :bigint           not null, primary key
#  body            :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  conversation_id :bigint
#  from_id         :bigint
#  sender_id       :bigint
#
# Indexes
#
#  index_messages_on_conversation_id  (conversation_id)
#  index_messages_on_from_id          (from_id)
#  index_messages_on_sender_id        (sender_id)
#
# Foreign Keys
#
#  fk_rails_...  (conversation_id => conversations.id) ON DELETE => cascade
#  fk_rails_...  (from_id => organizations.id)
#  fk_rails_...  (sender_id => users.id) ON DELETE => nullify
#
require "test_helper"

class MessageTest < ActiveSupport::TestCase
  include ActiveJob::TestHelper, ActionCable::TestHelper

  setup do
    @user = users(:jerry)
    @organization = organizations(:jerry)
    @conversation = conversations(:kramer_jerry_1)
    Current.organization = @organization
  end

  test "broadcasts partial after creation" do
    @conversation.messages.create(
    from: @organization,
    sender: @user,
    body: "Ahoy"
    )
    perform_enqueued_jobs
    assert_broadcasts stream_name, 1
  end

  test "notifies recipient after creation" do
    assert_difference "Conversations::Notification.count", 1 do
    @conversation.messages.create(
      from: @organization,
      sender: @user,
      body: "Ahoy"
    )
    end
  end 

  private

  def signed_stream_name
    @signed_stream_name ||=
    ConversationsChannel.signed_stream_name(@conversation)
  end

  def stream_name
    @stream_name ||=
    ConversationsChannel.verified_stream_name(signed_stream_name)
  end
  
end
