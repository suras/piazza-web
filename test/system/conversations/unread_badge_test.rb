require "application_system_test_case"
class Conversation::UnreadBadgeTest < ApplicationSystemTestCase
  setup do
    @user = users(:jerry)
    @conversation = conversations(:kramer_jerry_1)
    @conversation.notifications.create(
    message: messages(:kramer_jerry_1_3),
    recipient: organizations(:jerry)
    )
    log_in(@user)
  end
  test "shows unread badge for unread notification" do
    visit root_path
    assert_selector "#navbar_unread .tag", text: 1
  end
end