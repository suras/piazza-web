require "application_system_test_case"

class UsersTest < ApplicationSystemTestCase


  setup do
    ActionMailer::Base.deliveries.clear
  end
  test "new user can sign up" do
    visit root_path

    click_on I18n.t("application.navbar.sign_up")
    
    fill_in User.human_attribute_name(:name), with: "Newman"
    fill_in User.human_attribute_name(:email), with: "newman@example.com"
    fill_in User.human_attribute_name(:password), with: "short"
    fill_in User.human_attribute_name(:password_confirmation), with: "short"

    

    click_on I18n.t("users.new.sign_up")
    assert_selector "p.is-danger", text: I18n.t("activerecord.errors.models.user.attributes.password.too_short")

    fill_in User.human_attribute_name(:password), with: "password"
    fill_in User.human_attribute_name(:password_confirmation), with: "password"

    click_on I18n.t("users.new.sign_up")

    # assert_current_path root_path  # due to new activation user change
    assert_selector ".notification", text: I18n.t("users.create.welcome", name: "Newman")
    assert_selector ".navbar-dropdown", visible: false
  end 
  
  
  test "newly created user need to activate before loggining in" do

    visit root_path

    click_on I18n.t("application.navbar.sign_up")
    
    fill_in User.human_attribute_name(:name), with: "activation_test"
    fill_in User.human_attribute_name(:email), with: "activation_test@example.com"
    fill_in User.human_attribute_name(:password), with: "password"
    fill_in User.human_attribute_name(:password_confirmation), with: "password"

    click_on I18n.t("users.new.sign_up")

    visit root_path

    click_on I18n.t("application.navbar.login")

    fill_in User.human_attribute_name(:email), with: "activation_test@example.com"
    fill_in User.human_attribute_name(:password), with: "password"

    click_button I18n.t("sessions.new.submit")

    assert_selector ".notification.is-notice", text: I18n.t("activation_required")

    activation_path = extract_primary_link_from_last_mail
    visit activation_path

    visit root_path

    click_on I18n.t("application.navbar.login")
    fill_in User.human_attribute_name(:email), with: "activation_test@example.com"
    fill_in User.human_attribute_name(:password), with: "password"
    click_button I18n.t("sessions.new.submit")


    assert_current_path root_path
    assert_selector ".notification", text: I18n.t("sessions.create.success")
    assert_selector ".navbar-dropdown", visible: false


  end
    

  test "existing user can login" do
    visit root_path

    click_on I18n.t("application.navbar.login")

    fill_in User.human_attribute_name(:email), with: "jerry@emample.com"
    fill_in User.human_attribute_name(:password), with: "wrong"

    click_button I18n.t("sessions.new.submit")

    assert_selector ".notification.is-danger", text: I18n.t("sessions.create.incorrect_details")

    fill_in User.human_attribute_name(:email), with: "jerry@example.com"
    fill_in User.human_attribute_name(:password), with: "password"

    click_button I18n.t("sessions.new.submit")

    assert_current_path root_path

    assert_selector ".notification", text: I18n.t("sessions.create.success")
    assert_selector ".navbar-dropdown", visible: false

  end


  test "can update name" do
      log_in(users(:jerry))

      visit profile_path

      fill_in User.human_attribute_name(:name), with: "Jerry Seinfeld"
      click_button I18n.t("users.show.save_profile")

      assert_selector "form .notification", text: I18n.t("users.update.success")
      assert_selector "#current_user_name", text: "Jerry Seinfeld"
  end

  test "can logout" do
    log_in(users(:jerry))

    find('#current_user_name').hover  
      
    click_on I18n.t("application.navbar.logout")

    assert_current_path root_path
    assert_selector ".notification", text: I18n.t("sessions.destroy.success")
  end


  test "can change password with correct password challenge" do
    log_in(users(:jerry))

    visit profile_path

    fill_in :user_password_challenge, with: "password"
    fill_in :user_password, with: "new_password"

    click_button I18n.t("users.show.change_password_button")

    assert_selector "form .notification", text: I18n.t("users.passwords.update.success")
end


test "cannot change password with incorrect password challenge" do
  log_in(users(:jerry))

  visit profile_path

  fill_in :user_password_challenge, with: "password123"
  fill_in :user_password, with: "new_password"

  click_button I18n.t("users.show.change_password_button")

  assert_selector ".is-danger", text: I18n.t('activerecord.errors.models.user.attributes.password_challenge.invalid')
end



end


#  within("#change_password") do
# fill_in I18n.t("users.show.current_password"), with: "password"  # Current password
# fill_in I18n.t("users.show.new_password"), with: "new_password"  # New password
# click_button I18n.t("users.show.change_password_button")
# end 
# 
#
#The fill_in method in Rails system tests can work with several different identifiers:

# The label text
# The input's id
# The input's name