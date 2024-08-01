require "test_helper"

class ListingsControllerTest < ActionDispatch::IntegrationTest
   setup do
     @user = users(:jerry)
     log_in @user
   end

   test "can create a listing" do
      assert_difference "Listing.count", 1 do
        post listings_path, params: {
          listing: {
              title: Faker::Commerce.product_name,
              price: Faker::Commerce.price.floor,
              condition: "mint"
            }
          }  
       end
       assert_redirected_to listing_path(Listing.last)
   end


   test "Error when creating  a invalidlisting" do
      assert_no_difference "Listing.count" do
        post listings_path, params: {
          listing: {
              title: "title",
              price: 300,
              condition: "mint"
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
          condition: "mint"
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
           condition: "mint"
        }
      }
      assert_response :unprocessable_entity
   end
    test "can delete a listing" do
       @listing = listings(:auto_listing_1_jerry)
       assert_difference "Listing.count", -1 do
         delete listing_path(@listing)
       end
       assert_redirected_to root_path
    end

end
