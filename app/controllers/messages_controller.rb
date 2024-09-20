class MessagesController < ApplicationController
  include ActionView::RecordIdentifier # Add this line to include dom_id helper
  
  before_action :load_conversation
  before_action -> { authorize! @conversation.can_message? }


   def create
     @message = @conversation.messages.build(
      message_params.with_defaults(
        from: Current.organization,
        sender: Current.user
      )
     )
     Rails.logger.info "Message Id: #{@message.id}" # Log the message ID "Message Id"
     @message.save
     respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
             turbo_stream.replace("#{dom_id(@conversation, :form)}", partial: "conversations/form", locals: { conversation: @conversation, message:  @conversation.messages.build })
           ]
        end
     end
   end

   def index
    @pagy, @messages = pagy(@conversation.messages, items: 5) 
    render partial: "messages/messages", locals: { conversation: @conversation, messages: @messages, pagy: @pagy }   end

  private
   
  def message_params
    params.require(:message).permit(:body)
  end

  def load_conversation
    @conversation = Conversation.find(params[:conversation_id])
  end

end
