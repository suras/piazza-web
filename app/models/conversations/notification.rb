# == Schema Information
#
# Table name: conversations_notifications
#
#  id              :bigint           not null, primary key
#  read_at         :datetime
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  conversation_id :bigint
#  message_id      :bigint
#  recipient_id    :bigint
#
# Indexes
#
#  index_conversations_notifications_on_conversation_id  (conversation_id)
#  index_conversations_notifications_on_message_id       (message_id)
#  index_conversations_notifications_on_recipient_id     (recipient_id)
#
# Foreign Keys
#
#  fk_rails_...  (conversation_id => conversations.id) ON DELETE => cascade
#  fk_rails_...  (message_id => messages.id) ON DELETE => cascade
#  fk_rails_...  (recipient_id => organizations.id) ON DELETE => cascade
#
class Conversations::Notification < ApplicationRecord
  include Readable
  
  belongs_to :message
  belongs_to :recipient, class_name: 'Organization'
  belongs_to :conversation

  after_create_commit :deliver_by_email


  private
    def deliver_by_email
      to = recipient.members.first

      ConversationMailer.new_message(
        message,
        to: to,
        reply_to: message.response_email(recipient)
      ).deliver_later
    end

end
