require "test_helper"

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "requires a name" do
    @user = User.new(name: "", email: "test@example.com", password: "password")
    assert_not @user.valid?

    @user.name = "Test User"
    assert @user.valid?
  end

 test "requires a valid email" do
    @user = User.new(name: "Test User", email: "", password: "password")
    assert_not @user.valid?

    @user.email = "invalid"
    assert_not @user.valid?

    @user.email = "test@example.com"
    assert @user.valid?
 end

 test "requires a unique email" do
   @existing_mail = User.create(name: "Test User", email: "test@example.com", password: "password")
   assert @existing_mail.persisted?

   @user = User.new(name: "Test User", email: "test@example.com", password: "password")

   assert_not @user.valid?
 end

 test "name and email is stripped of spaces before saving" do
    @user = User.create(name: " Test User ", email: " test@example.com ", password: "password")
    assert_equal @user.email, "test@example.com"
    assert_equal @user.name, "Test User"
 end



end
