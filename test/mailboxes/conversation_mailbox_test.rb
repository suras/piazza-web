require "test_helper"

class ConversationMailboxTest < ActionMailbox::TestCase
  include ActionMailer::TestHelper
  # test "receive mail" do
  #   receive_inbound_email_from_mail \
  #     to: '"someone" <someone@example.com>',
  #     from: '"else" <else@example.com>',
  #     subject: "Hello world!",
  #     body: "Hello?"
  # end

  setup do
    @user = users(:jerry)
    @conversation = conversations(:kramer_jerry_1)
    @recipient = organizations(:kramer)
    @mail = file_fixture("multipart_email.eml").read
  end

  test "creates message for conversation" do
    set_email_to(
    @conversation.messages.last.response_email(@recipient)
    )
    assert_difference "@conversation.messages.count", 1 do
      receive_inbound_email_from_source(@mail)
    end  
    assert_equal(
        Mail.read_from_string(@mail).text_part.body.decoded.strip,
        @conversation.messages.last.body.strip
        )  
  end 

  test "bounces email with invalid identifier" do
    set_email_to "conversation+test@inbound.test.com"
    mail = receive_inbound_email_from_source(@mail)
    assert mail.bounced?
    assert_enqueued_emails 1
  end

private
  def set_email_to(email)
    @mail = @mail.gsub(/{{ to }}/, email)
  end 
end
