# == Schema Information
#
# Table name: addresses
#
#  id               :bigint           not null, primary key
#  addressable_type :string
#  city             :string
#  country          :string
#  line_1           :string
#  line_2           :string
#  postcode         :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  addressable_id   :bigint
#
# Indexes
#
#  index_addresses_on_addressable  (addressable_type,addressable_id)
#
class Address < ApplicationRecord
  belongs_to :addressable, polymorphic: true

  include PermittedAttributes

  validates :line_1, presence:true
  validates :line_2, presence:true
  validates :city, presence:true
  validates :postcode, presence:true
  validates :country, presence:true

  attribute :country, default: "GB"

  def redacted
    "#{city}, #{postcode}"
  end

end
