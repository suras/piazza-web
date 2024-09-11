module Address::Geocodable
   extend ActiveSupport::Concern


   included do
      geocoded_by :redacted
      after_save_commit :queue_geocode_job, if: :should_geocode?

      def should_geocode?
        saved_change_to_city? || saved_change_to_postcode?
      end

      # below wont work after save
      # def should_geocode?
      #    city_changed? || postcode_changed?
      # end
   end

   private

   def queue_geocode_job
      # binding.b
    Rails.logger.info "--------------------------------------------------------set for geocoding"
    Listings::GeocodeJob
    .perform_now(self)
   end

end