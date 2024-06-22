require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest

   test "redirects to feed after successful sign up" do
    get sign_up_path
    assert_response :ok

    assert_difference [ "User.count", "Organization.count"], 1 do
       post sign_up_path, params: {
          user: {
              name: "rock",
              email: "rock@rock.com",
              password: "qwertyuio"

          }
       }
    end

    assert_redirected_to root_path
    assert_not_empty cookies[:app_session]
    follow_redirect!
    assert_select ".notification.is-success", text: I18n.t("users.create.welcome", name: "rock")

   end

   test "renders error if input data is invalid" do
      get sign_up_path
      assert_response :ok
  
      assert_no_difference [ "User.count", "Organization.count"] do
         post sign_up_path, params: {
            user: {
                name: "rock",
                email: "rock@rock.com",
                password: "1234"
  
            }
         }
      end
  
      assert_response :unprocessable_content
      assert_select "p.is-danger", text: I18n.t("activerecord.errors.models.user.attributes.password.too_short")
  
     end


     test "renders error if password_confirmation is given and password doesn not match" do
      get sign_up_path
      assert_response :ok
  
      assert_no_difference [ "User.count", "Organization.count"] do
         post sign_up_path, params: {
            user: {
                name: "rock",
                email: "rock@rock.com",
                password: "123456789",
                password_confirmation: "123556789"
            }
         }
      end
  
      assert_response :unprocessable_content
      assert_select "p.is-danger", text: I18n.t("activerecord.errors.models.user.attributes.password_confirmation.confirmation")
  
     end

     test "redirects to feed after successful sign up if password_confirmation is given and matches with password" do
      get sign_up_path
      assert_response :ok
  
      assert_difference [ "User.count", "Organization.count"], 1 do
         post sign_up_path, params: {
            user: {
                name: "rockman",
                email: "rock123@rock.com",
                password: "123456789",
                password_confirmation: "123456789"
            }
         }
      end
  
      assert_redirected_to root_path
      follow_redirect!
      assert_select ".notification.is-success", text: I18n.t("users.create.welcome", name: "rockman")

     end


end
