require "test_helper"

class SavedListingsControllerTest < ActionDispatch::IntegrationTest

  setup do
    @user = users(:jerry)
    @listing = listings(:auto_listing_1_kramer)
    log_in(@user)
  end
  test "can save an ad" do
    post listing_saved_listings_path(@listing)
    # assert_response :ok
    assert @user.saved_listings.exists?(@listing.id)
  end

  test "can un-save an ad" do
    @user.saved_listings << @listing
    delete listing_saved_listings_path(@listing)
    # assert_response :ok
    assert_not @user.saved_listings.exists?(@listing.id)
  end
end
