require "test_helper"

class ListingTest < ActiveSupport::TestCase

  setup do
    @user = users(:jerry)
  end
  test "User should create a listing with valid params" do
    listing = Listing.new(title: "The world is one", price: 100, creator: @user, organization: @user.organizations.first)
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

end
