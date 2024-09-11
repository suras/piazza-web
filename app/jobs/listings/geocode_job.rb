class Listings::GeocodeJob < ApplicationJob
  queue_as :default

  def perform(address)
    Rails.logger.info "geocoding"
    # return if address.geocoding_complete?

    address.geocode
    # address.geocoding_complete!
    address.save
  end


  # def perform(address_id)
  #   address = Address.find(address_id)
  #   return if address.nil?

  #   Rails.logger.info "geocoding"
    
  #   # Perform geocoding without triggering callbacks
  #   address.geocode
    
  #   # Update the record without callbacks to avoid triggering another job
  #   address.update_columns(
  #     latitude: address.latitude,
  #     longitude: address.longitude
  #   )
  # end
end
