class ConversationsController < ApplicationController

  skip_authorization only: :index
  def index
    @conversations = Conversation.current_organization.for_display
  end


  def show 
    @conversation.read!
    @message = @conversation.messages.build
    @pagy, @messages = pagy(@conversation.messages, items: 5) 
  end
  
  private
  
    def authorizable_resource
      @conversation = Conversation.find(params[:id])
    end

end
