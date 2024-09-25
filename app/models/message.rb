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
class Message < ApplicationRecord
  include EmailRespondable, ActionView::RecordIdentifier

  belongs_to :conversation
  belongs_to :from, class_name: "Organization"
  belongs_to :sender, class_name: "User", optional: true

  validates :body, presence: true

  scope :for_display, -> {
    includes(:from, :sender)
    .where.not(created_at: nil)
    .order(created_at: :asc)
  }

  scope :last_10, -> {
    last(10)
  }

  after_create_commit -> {
    broadcast_append_later_to(
      conversation, 
      target: dom_id(conversation, :messages),
      locals: { from: from.id }
    )
  }

  after_create_commit -> {
     conversation.notify_recipient(self)
  }

  
end
