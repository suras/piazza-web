module Conversation::Notifier
  extend ActiveSupport::Concern

  included do
    has_many :notifications, class_name: 'Conversations::Notification',
     dependent: :destroy

    kredis_set :online_participants, typed: :integer
  end

  def notify_recipient(message)
    recipient_id = [seller_id, buyer_id].difference([message.from_id]).first
    unless online_participants.include?(recipient_id)
      notifications.create(
        message: message,
        recipient_id: recipient_id
      )
    end
  end

  def read!
    notifications.unread.update_all(read_at: Time.zone.now)
  end

end