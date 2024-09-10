# == Schema Information
#
# Table name: addresses
#
#  id               :bigint           not null, primary key
#  addressable_type :string
#  city             :string
#  country          :string
#  latitude         :decimal(, )
#  line_1           :string
#  line_2           :string
#  longitude        :decimal(, )
#  postcode         :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  addressable_id   :bigint
#
# Indexes
#
#  index_addresses_on_addressable             (addressable_type,addressable_id)
#  index_addresses_on_latitude_and_longitude  (latitude,longitude)
#
require "test_helper"

class AddressTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
