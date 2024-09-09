# == Schema Information
#
# Table name: listings
#
#  id              :bigint           not null, primary key
#  condition       :enum
#  price           :integer
#  published_on    :datetime
#  searchable      :tsvector
#  status          :enum             default("published")
#  tags            :string           is an Array
#  title           :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  creator_id      :bigint
#  organization_id :bigint           not null
#
# Indexes
#
#  index_listings_on_creator_id       (creator_id)
#  index_listings_on_organization_id  (organization_id)
#  index_listings_on_searchable       (searchable) USING gin
#
# Foreign Keys
#
#  fk_rails_...  (creator_id => users.id)
#  fk_rails_...  (organization_id => organizations.id)
#
require "test_helper"

class ListingTest < ActiveSupport::TestCase

  setup do
    @user = users(:jerry)
    @listing = listings(:auto_listing_1_jerry)
    @address = addresses(:address_1_jerry)
    @cover_photo_blob = active_storage_blobs(:blob_1) # replace :blob_1 with the correct fixture name
  end
  test "User should create a listing with valid params" do
    listing = Listing.new(title: "The world is one", price: 100, creator: @user, organization: @user.organizations.first, address: @address,
    tags: ["Test"], cover_photo: @cover_photo_blob.signed_id, description: "<p>Hellow</p>")
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
    tags: ["Test"], cover_photo: @cover_photo_blob.signed_id,  description: "<p>Hellow</p>")
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


  test "can check if the current user has saved a listing" do
    Current.user = @user
    assert_not @listing.saved?

    @user.saved_listings << @listing
    assert @listing.saved?
  end

  test "returns false when checking if saved without a current user" do
    assert_not @listing.saved?
  end

end
