require "test_helper"

class Messages::EmailResponseParserTest < ActiveSupport::TestCase
    test "parses HTML email" do
      @mail = Mail.read(file_fixture("html_email.eml"))
      @parser = Messages::EmailResponseParser.new(@mail)
      assert_match "a man on the moon", @parser.plain_text_body
      assert_no_match "<html>", @parser.plain_text_body
    end

    test "parses plain text email" do
      @mail = Mail.read(file_fixture("plain_text_email.eml"))
      @parser = Messages::EmailResponseParser.new(@mail)
      assert_match "a man on the moon", @parser.plain_text_body
    end

    test "parses multipart email" do
      @mail = Mail.read(file_fixture("multipart_email.eml"))
      @parser = Messages::EmailResponseParser.new(@mail)
      assert_match "a man on the moon", @parser.plain_text_body
      assert_no_match "<html>", @parser.plain_text_body
    end
    
  end
