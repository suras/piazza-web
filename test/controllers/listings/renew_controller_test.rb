require "test_helper"

class Listings::RenewControllerTest < ActionDispatch::IntegrationTest
   setup do
    @user = users(:jerry)
    @listing = listings(:auto_listing_1_jerry)
    log_in @user
   end


   test "Renews a post by updating  published on" do
     travel_to 10.days.from_now

     get renew_listing_url(@listing) 

     assert @listing.published_on.beginning_of_day == 10.days.ago.beginning_of_day
   end
end
