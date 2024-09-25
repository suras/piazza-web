class Conversations::UnreadBadgeController < ApplicationController

  layout false

  def show

    @unread_count = Conversations::Notification
    .where(recipient: Current.organization).unread.count

    head :no_content unless @unread_count > 0
    
  end
end
