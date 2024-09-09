module Listing::Renewable
   extend ActiveSupport::Concern

   included do
     after_save_commit :queue_renewed_job,
      if: -> {
        (id_previously_was.nil? && published? ) ||
        (status_previous_change in [_, "published"])
      }
   end

   def renew_date
     expiry_date.beginning_of_day  - 1.day
   end

   def renew_date_past?
    (expiry_date - 1.hours).past?
   end

   def send_renew_mail
    token = self.creator.generate_token_for(:authenticate)
    puts "Renew mail sent"   
    UserMailer.with(user: self.creator)
              .renew(token, id)
              .deliver_later

   end

   private 

   def queue_renewed_job
      Listings::RenewJob.set(wait_until: renew_date).perform_later(self)
   end
end
