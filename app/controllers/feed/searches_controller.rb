class Feed::SearchesController < ApplicationController
   allow_unauthenticated

   def show
     @search = Listings::Search.new(search_params)
    #  @pagy, @listings = pagy(Listing.feed.search(search_params[:query]))
     @pagy, @listings = pagy(@search.perform)
     render "feed/show" # without this rendering all
   end


   private 
   
   def search_params

     params.require(:listings_search).permit(:query, :location, :tags => [])
   end

   rescue_from ActionController::ParameterMissing do
    redirect_to root_path, status: :see_other
   end
end
