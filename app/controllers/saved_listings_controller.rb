class SavedListingsController < ApplicationController
  before_action :load_listing, except: :show
  before_action -> { authorize! @listing.can_save? }, except: :show

  def create
    Current.user.saved_listings << @listing
    Turbo::StreamsChannel.broadcast_refresh_to Current.user
    redirect_to @listing, status: :see_other
  end

  def destroy
    Current.user.saved_listings.destroy(@listing)

    redirect_to request.referer || @listing, status: :see_other
  end

  def show
    drop_breadcrumb t(".title")

    @pagy, @listings = pagy(Current.user.saved_listings)

    render :show # due to default render define so explicit render is required
  end

  private 

  def load_listing
    @listing = Listing.find(params[:listing_id])
  end


end
