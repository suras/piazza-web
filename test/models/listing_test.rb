require "test_helper"

class ListingTest < ActiveSupport::TestCase

  setup do
    @user = users(:jerry)
    @listing = listings(:auto_listing_1_jerry)
    @address = addresses(:address_1_jerry)
  end
  test "User should create a listing with valid params" do
    listing = Listing.new(title: "The world is one", price: 100, creator: @user, organization: @user.organizations.first, address: @address,
    tags: ["Test"])
    # puts "-----" + listing.errors.full_messages.join(", ")
    assert listing.valid?
  end


  test "User should not be able create a listing with short title count" do
    listing = Listing.new(title: "The", price: 100, creator: @user, organization: @user.organizations.first, address: @address)
    assert_not listing.valid?
  end

  test "User should not be able create a listing with invalid price" do
    listing = Listing.new(title: "The", price: "vvv", creator: @user, organization: @user.organizations.first, address: @address)
    assert_not listing.valid?
  end

  test "downcases tags before saving" do
    @listing.tags = ["Electronics", "Tools"]
    @listing.save
    assert_equal ["electronics", "tools"], @listing.tags
  end

  test "should not create listing without a valid address" do
    invalid_address = Address.new(city: nil, country: nil, line_1: nil, line_2: nil)
    listing = Listing.new(title: "The world is one", price: 100, creator: @user, organization: @user.organizations.first, address: invalid_address,
    tags: ["Test"])
    assert_not listing.valid?


    valid_address = Address.new(city: "london", country: "UK", line_1: "line 1", line_2: "line 2", postcode: "12345")
    # listing.build_address(valid_address.attributes)
    listing.address = valid_address
    assert listing.valid?
    # puts "-----" + listing.errors.full_messages.join(", ")

    # @address.city = nil
    # @listing.address = @address # this is auto saving on assigning
#     Error:
# ListingTest#test_should_not_create_listing_without_a_valid_address:
# ActiveRecord::RecordNotSaved: Failed to save the new associated address.
#     test/models/listing_test.rb:48:in `block in <class:ListingTest>'

  
    @address.city = nil
    @address.postcode = nil
    @listing.build_address(@address.attributes)
    # puts @address.attributes
    assert_not @listing.valid?

    # assign_attributes is used due to 
    # The error indicates that the address is being saved automatically, 
    # even though you haven't explicitly called save on the @listing or 
    # @address. This can happen if the @listing object is attempting to 
    # save its associated records automatically during assignment,
    #  which is a behavior controlled by Rails' autosave functionality.
    #  
    
    # can't use same address name 
    # The FrozenError: can't modify frozen attributes error occurs because you're trying to 
    # modify an instance of Address that has already been assigned 
    # to the @listing and possibly frozen due to how Rails handles 
    # associations.
  end

end
