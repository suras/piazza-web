class Listings::RenewJob < ApplicationJob
  queue_as :default

  def perform(listing)
     return if listing.expired?
     
     unless listing.renew_date_past?
       listing.send_renew_mail
     end
  end
end
