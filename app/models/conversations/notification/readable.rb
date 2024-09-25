module Conversations::Notification::Readable
  extend ActiveSupport::Concern
    included do
      scope :unread, -> { where(read_at: nil) }
    end
    def read?
      read_at.present?
    end
    def unread?
      read_at.nil?
    end
    def read!
      update(read_at: Time.zone.now)
    end
end