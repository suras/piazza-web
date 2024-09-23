module Conversation::Notifier
  extend ActiveSupport::Concern

  included do
    kredis_set :online_participants, typed: :integer
  end

  def notify_recipient(message)
    recipient_id = [seller_id, buyer_id].difference([message.from_id]).first
    unless online_participants.include?(recipient_id)
      Conversations::Notification.create(
        message: message,
        recipient_id: recipient_id
      )
    end
  end

end