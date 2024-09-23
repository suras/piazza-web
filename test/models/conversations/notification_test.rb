# == Schema Information
#
# Table name: conversations_notifications
#
#  id           :bigint           not null, primary key
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  message_id   :bigint
#  recipient_id :bigint
#
# Indexes
#
#  index_conversations_notifications_on_message_id    (message_id)
#  index_conversations_notifications_on_recipient_id  (recipient_id)
#
# Foreign Keys
#
#  fk_rails_...  (message_id => messages.id) ON DELETE => cascade
#  fk_rails_...  (recipient_id => organizations.id) ON DELETE => cascade
#
require "test_helper"

class Conversations::NotificationTest < ActiveSupport::TestCase
  include ActionMailer::TestHelper
  
  setup do
    @to = organizations(:jerry)
    @conversation = conversations(:kramer_jerry_1)
    @message = messages(:kramer_jerry_1_3)
    @recipient = organizations(:kramer)
  end

  test "creates notification for offline participant" do
    assert_difference "Conversations::Notification.count", 1 do
    @conversation.notify_recipient(@message)
    end
    assert_equal @to, Conversations::Notification.last.recipient
  end

  test "does not create notification for online participant" do
    @conversation.online_participants << @to.id
    assert_no_difference "Conversations::Notification.count" do
    @conversation.notify_recipient(@message)
    end
  end

  test "sends email notification after creation" do
    Conversations::Notification.create(
    message: @message,
    recipient: @recipient
    )
    assert_enqueued_email_with(
    ConversationMailer,
      :new_message,
      args: [
      @message,
      to: users(:kramer),
      ]
    )
end
end
