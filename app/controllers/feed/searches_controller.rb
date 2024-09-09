class Feed::SearchesController < ApplicationController
   allow_unauthenticated

   def show
     puts "Searching  ============+++++++++++++++++++++++++++++++++++++++"
     @pagy, @listings = pagy(Listing.feed.search(search_params[:query]))

     render "feed/show" # without this rendering all
   end


   private 
   
   def search_params
     params.require(:listings_search).permit(:query)
   end

   rescue_from ActionController::ParameterMissing do
    redirect_to root_path, status: :see_other
   end
end
