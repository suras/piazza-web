require "test_helper"

class ListingTest < ActiveSupport::TestCase

  setup do
    @user = users(:jerry)
    @listing = listings(:auto_listing_1_jerry)
  end
  test "User should create a listing with valid params" do
    listing = Listing.new(title: "The world is one", price: 100, creator: @user, organization: @user.organizations.first,
    tags: ["Test"])
    assert listing.valid?
  end


  test "User should not be able create a listing with short title count" do
    listing = Listing.new(title: "The", price: 100, creator: @user, organization: @user.organizations.first)
    assert_not listing.valid?
  end

  test "User should not be able create a listing with invalid price" do
    listing = Listing.new(title: "The", price: "vvv", creator: @user, organization: @user.organizations.first)
    assert_not listing.valid?
  end

  test "downcases tags before saving" do
    @listing.tags = ["Electronics", "Tools"]
    @listing.save

    assert_equal ["electronics", "tools"], @listing.tags
  end

end
