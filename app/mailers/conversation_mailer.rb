class ConversationMailer < ApplicationMailer
  
  def new_message(message, to:)
    @message = message
    @conversation = message.conversation
    @listing = @conversation.listing
    mail(
    to: %("#{to.name}" <#{to.email}>),
    subject: t(".subject", title: @listing.title)
    )
  end

end
