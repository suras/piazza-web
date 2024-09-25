require "test_helper"

class Message::EmailRespondableTest < ActiveSupport::TestCase
 
  setup do
    @conversation = conversations(:kramer_jerry_1)
    @email = @conversation.messages.last
    .response_email(@conversation.buyer)
    end
  
    test "generates id for email replies" do
    assert_match URI::MailTo::EMAIL_REGEXP, @email
    assert_match /^conversation\+(\S+)@/i, @email
  end

  test "decode id for email replies" do
    identifier = @email.split("@").first.split("+").second
    conversation, from =
    Message.decode_email_reply_identifier(identifier)
    assert_equal @conversation, conversation
    assert_equal @conversation.buyer, from
  end

end