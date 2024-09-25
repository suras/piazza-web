class ConversationMailer < ApplicationMailer
  
  def new_message(message, to:, reply_to:)
    @message = message
    @conversation = message.conversation
    @listing = @conversation.listing
    mail(
      to: %("#{to.name}" <#{to.email}>),
      subject: t(".subject", title: @listing.title),
      reply_to: reply_to
    )
  end

  def email_response_error(to)
    mail to: to, subject: t(".subject")
  end

end
