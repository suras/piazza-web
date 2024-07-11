require "test_helper"

class Users::PasswordsControllerTest < ActionDispatch::IntegrationTest

  setup do
    @user = users(:jerry)
    log_in(@user)
  end


  test "can change password" do
    patch users_change_password_path, params: { user: 
        { password_challenge: "password", password: "new_password" }
      } 

      assert_redirected_to profile_path
      assert @user.reload.authenticate("new_password")  

  end

  test "error response if current password is incorrect" do
      patch users_change_password_path, params: { user: 
        { password_challenge: "wrong", password: "new_password" }
        } 
      assert_response :unprocessable_content
  end

  test "error response if new password is invalid" do
    patch users_change_password_path, params: { user:
       { password_challenge: "password", password: "invalid" }
    } 
    assert_response :unprocessable_content


  end




end
