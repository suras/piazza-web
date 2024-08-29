class MyListingsController < ApplicationController

  drop_breadcrumb I18n.t("my_listings.show.title")
  def show
    @pagy,@listings = pagy(Current.organization.listings, limit: 24)
  end
end
