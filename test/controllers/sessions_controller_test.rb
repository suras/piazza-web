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

  test "logging out redirects to the root url and deletes the session" do
    log_in(@user)

    assert_difference("@user.app_sessions.count", -1) { log_out }
    assert_redirected_to root_path

    follow_redirect!
    assert_select ".notification", I18n.t("sessions.destroy.success")
  end

  test "Remeber me sets a permanent cookie" do
    post login_path, params: {
      user: {
         email: @user.email,
         password: "password",
         remember_me: true
      }
    }

   # Access the raw headers for the Set-Cookie value
    set_cookie_header = response.headers["Set-Cookie"]
    assert_not_nil set_cookie_header, "Set-Cookie header should be present"

    assert_not_empty cookies[:app_session]
    set_cookie_header = response.headers["Set-Cookie"].join("\n") if set_cookie_header.is_a?(Array)
    # Check if the cookie includes an expiration date approximately 20 years from now
    puts set_cookie_header
    if set_cookie_header =~ /expires=([^;]+)/
      cookie_expiration = Time.parse($1)
      assert_in_delta 20.years.from_now.to_i, cookie_expiration.to_i, 1.day, "Cookie expiration should be approximately 20 years from now"
    else
      flunk "Cookie expiration date not found in Set-Cookie header"
    end

  end 
  
  
  test "Not Remeber me sets a session cookie" do
    post login_path, params: {
      user: {
        email: @user.email,
        password: "password",
        remember_me: false
      }
    }
    assert_not_empty cookies[:app_session]
    
    # Access the raw headers for the Set-Cookie value
    set_cookie_header = response.headers["Set-Cookie"]
    assert_not_nil set_cookie_header, "Set-Cookie header should be present"
    set_cookie_header = response.headers["Set-Cookie"].join("\n") if set_cookie_header.is_a?(Array)

    
    # Check if the Set-Cookie header does not contain an expiration date
    assert_no_match /expires=/, set_cookie_header, "Session cookies should not have an expiration date"
  end

end
