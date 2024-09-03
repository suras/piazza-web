require "test_helper"

class ListingsControllerTest < ActionDispatch::IntegrationTest
   setup do
     @user = users(:jerry)
     log_in @user
     @address = addresses(:address_1_jerry)

   end

   test "can create a listing" do
      assert_difference "Listing.count", 1 do
        post listings_path, params: {
          listing: {
              title: Faker::Commerce.product_name,
              price: Faker::Commerce.price.floor,
              cover_photo: fixture_file_upload("test-image-1.jpg"),
              condition: "mint",
              tags: ["test"],
              address_attributes: @address.attributes.except('id', 'created_at', 'updated_at'),
              description: "<p>Test</p>"
            }
          }  
       end
       assert_redirected_to listing_path(Listing.last)
       assert Listing.last.published?
   end


   test "Error when creating  a invalidlisting" do
      assert_no_difference "Listing.count" do
        post listings_path, params: {
          listing: {
              title: "title",
              price: 300,
              condition: "mint",
              tags: ["test"],
              address_attributes: @address.attributes.except('id', 'created_at', 'updated_at')
            }
          }  
      end
      assert_response :unprocessable_entity
      # assert_select "p.is-danger"
    end

   test "can update a listing" do
    @listing = listings(:auto_listing_1_jerry)
    new_title = Faker::Commerce.product_name
    patch listing_path(@listing), params: {
        listing: {
          title: new_title,
          price: @listing.price,
          condition: "mint",
          tags: ["test"],
          address_attributes: @address.attributes.except('id', 'created_at', 'updated_at')
        }
    }
    assert_redirected_to listing_path(@listing)
    assert_equal new_title, @listing.reload.title
  end  


  test "error when updating a listing with invalid data" do
      @listing = listings(:auto_listing_1_jerry)
      patch listing_path(@listing), params: {
        listing: {
           title: @listing.title,
           price: "NaN",
           condition: "mint",
           tags: ["test"],
           address_attributes: @address.attributes.except('id', 'created_at', 'updated_at')
          }
      }
      assert_response :unprocessable_entity
   end

   test "can't create  a listing without tags" do
    assert_no_difference "Listing.count" do
      post listings_path, params: {
        listing: {
            title: Faker::Commerce.product_name,
            price: 123,
            condition: nil,
            tags: nil,
            address_attributes: @address.attributes.except('id', 'created_at', 'updated_at')
          }
        }  
     end
     assert_response :unprocessable_entity
     assert_select "label[for='listing_tags'] ~ .is-danger", I18n.t("activerecord.errors.models.listing.attributes.tags.too_short")
    end

    test "can't create  a listing without description" do
      assert_no_difference "Listing.count" do
        post listings_path, params: {
          listing: {
              title: Faker::Commerce.product_name,
              price: 123,
              condition: nil,
              tags: nil,
              address_attributes: @address.attributes.except('id', 'created_at', 'updated_at')
            }
          }  
       end
       assert_response :unprocessable_entity
       assert_select ".is-danger", I18n.t("activerecord.errors.models.listing.attributes.description.blank")
      end

    test "can delete a listing" do
       @listing = listings(:auto_listing_1_jerry)
       assert_difference "Listing.count", -1 do
         delete listing_path(@listing)
       end
      #  assert_redirected_to url_for(controller: :listings, action: :index)
      #  assert_redirected_to my_listings_path(flash: { success: I18n.t("listings.destroy.success") }, status: :see_other)
      assert_redirected_to my_listings_path
    end

    test "updating a draft listing publishes it" do
      @listing = listings(:auto_listing_1_jerry)
      @listing.draft!
      patch listing_path(@listing)
      assert_redirected_to listing_path(@listing)
      assert @listing.reload.published?
    end

end
