require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  WINDOW_SIZE = [1400, 1400].freeze
  driven_by :selenium, using: :chrome, screen_size: WINDOW_SIZE

  private
    def extract_primary_link_from_last_mail
      mail = ActionMailer::Base.deliveries.last 
      mail_html = Nokogiri::HTML(mail.html_part.body.decoded)

      primary_link = mail_html.css("a.button").attr("href").value
      primary_link = URI(primary_link)
      "#{primary_link.path}?#{primary_link.query}"
    end
end


class MobileSystemTestCase < ApplicationSystemTestCase

  setup do
    visit root_path
    current_window.resize_to(375, 812)
  end

  teardown do
    current_window.resize_to(*WINDOW_SIZE)
  end

end

