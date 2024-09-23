# Preview all emails at http://localhost:3000/rails/mailers/conversation_mailer
class ConversationMailerPreview < ActionMailer::Preview
  def new_message
    @conversation = Conversation.find(5)
    @message = @conversation.messages.first
    ConversationMailer.new_message(@message, to: User.first)
  end
end
