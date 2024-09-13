class Listings::ContactController < ApplicationController
   before_action :load_listing
   before_action -> { authorize! @listing.can_contact? }
  
  def show
    @conversation = @listing.conversations.find_or_create_by(
      buyer: Current.organization
      )
    @message = @conversation.messages.build  

    # @conversation.messages.build is designed specifically for associations and automatically handles the association between the new message and @conversation. 
    # It adds the new message to the messages collection of @conversation.
  end


  private

    def load_listing
      @listing = Listing.find(params[:listing_id])
    end

end
