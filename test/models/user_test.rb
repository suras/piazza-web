# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  email           :string
#  name            :string
#  password_digest :string
#  verified        :boolean          default(FALSE)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_users_on_email  (email) UNIQUE
#
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
    @user = User.create(name: "Test User ", email: " test@example.com ", password: "password")
    assert_equal @user.email, "test@example.com"
    assert_equal @user.name, "Test User"
 end

 test "Should valdate password  while saving with password context" do
  @user = User.create(name: "Test User", email: " test@example.com ", password: "password")

  @user.name = "modified"
  @user.password = nil # explicit nil is need since its a virtual attribute
  @user.save(context: :password_change)

  assert_not @user.valid?(:password_change)

  @user.reload
  assert_not_equal @user.name, "modified"
 end

 test "Should not valdate password  while saving without password context" do
  @user = User.create(name: "Test User", email: " test@example.com ", password: "password")

  @user.name = "modified"
  @user.password = "12345"
  @user.save

  assert @user.valid?

  @user.reload
  assert_equal @user.name, "modified"


 end


end
