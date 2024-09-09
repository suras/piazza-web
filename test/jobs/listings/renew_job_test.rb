require "test_helper"

class Listings::RenewJobTest < ActiveJob::TestCase
  include ActionMailer::TestHelper
  setup do
    @listing = listings(:auto_listing_1_jerry)
  end
  test "Sends a email for renew" do
    assert_not @listing.renew_date_past?
    Listings::RenewJob.perform_now(@listing)
    assert_enqueued_emails 1

  end
end
