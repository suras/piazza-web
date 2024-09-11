class Listings::Search 
  include ActiveModel::Model

  attr_accessor :query, :location, :tags


  def initialize(attributes={})
     super
     Rails.logger.info "Tags : ---- #{self.tags}" 
     self.query = nil unless query.present?
     self.location = nil unless location.present?
     self.tags = nil unless tags&.compact_blank.present?
  end

  # def perform
  #   if location.present?
  #      Listing.feed.search(query).near(location)
  #   else
  #      Listing.feed.search(query)
  #   end
  # end
  # 
  def perform
     case [query, location, tags]
     in [String, nil, nil]
        Listing.feed.search(query)
     in [String, String, nil]
        Listing.feed.search(query).near(location)
     in [nil, nil, Array]
        Listing.feed.filter_by_tags(tags)   
     in [String, nil, Array]
         Listing.feed.search(query).filter_by_tags(tags)           
     else
      raise "Error in search data"  
     end
  end
end
