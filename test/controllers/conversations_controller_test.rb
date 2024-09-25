require "test_helper"

class ConversationsControllerTest < ActionDispatch::IntegrationTest
  
  setup do
    @user = users(:jerry)
    @conversation = conversations(:kramer_jerry_1)
    log_in @user
  end

  test "shows dual pane index on desktop" do
    get conversations_path
    assert_response :ok
    assert_select "#conversations"
    assert_select "turbo-frame#conversation"
  end

  test "can view messages for a conversation" do
    get conversation_path(@conversation)
    assert_response :ok
    assert_select "##{dom_id(@conversation, :messages)}"
  end

  test "shows single panel index on mobile" do
    get conversations_path, headers: {
    "HTTP_USER_AGENT": "MobileDevice"
    }
    assert_response :ok
    assert_select "#conversations"
    assert_select "turbo-frame#conversation", 0
  end

  test "viewing a coversation marks all notifications as read" do
    @conversation.notifications.create(
    message: messages(:kramer_jerry_1_3),
    recipient: organizations(:jerry)
    )
    assert_not_empty @conversation.notifications.unread
    get conversation_path(@conversation)
    assert_response :ok
    assert_empty @conversation.notifications.unread
  end

end
