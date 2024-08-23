class FeedController < ApplicationController
  allow_unauthenticated
  
  def show
    @pagy, @listings = pagy(Listing.feed, items: 24)
  end
end
