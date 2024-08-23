class MyListingsController < ApplicationController
  def show
    @pagy,@listings = pagy(Current.organization.listings, limit: 24)
  end
end
