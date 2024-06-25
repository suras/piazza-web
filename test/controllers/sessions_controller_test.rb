require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest

  setup do
    @user = users(:jerry)
  end
  test "User is logged in and redirected to home with correct credentials" do
    assert_difference("@user.app_sessions.count", 1) {
      log_in(@user)
    }
    assert_not_empty cookies[:app_session]
    assert_redirected_to root_path
  end

  test "Error rendered for login with incorrect details" do
    post login_path, params: { 
      user: {
        email: "jerry@example.com", 
        password: "password123" 
     }   
    }
    assert_select ".notification", I18n.t("sessions.create.incorrect_details")
  end



end
