require "test_helper"

class Conversations::UnreadBadgeControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:jerry)
    @conversation = conversations(:kramer_jerry_1)
    log_in @user
  end

  test "renders unread messages count" do
    @conversation.notifications.create(
    message: messages(:kramer_jerry_1_3),
    recipient: organizations(:jerry)
    )
    get unread_badge_conversations_path
    assert_response :ok
    assert_select "#navbar_unread"
    assert_select ".tag", text: /1/
  end

  test "renders no content when there are no unreads" do
    get unread_badge_conversations_path
    assert_response :no_content
    assert response.body.empty?
  end  
end
