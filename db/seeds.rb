# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end


100.times do
  user = User.create(
  name: Faker::Name.name,
  email: Faker::Internet.email,
  password: "password")
  Organization.create(members: [user])
end

1000.times do
  cover_photo_blob = ActiveStorage::Blob.create_and_upload!(
      io: StringIO.new(File.read(Rails.root.join("test", "fixtures", "files", "test-image-#{rand(1..9)}.jpg"
   ))),
   filename: "photo.jpg",
   )
  random_user = User.offset(rand(User.count)).first
  Listing.create(
    creator: random_user,
    organization: random_user.organizations.first,
    title: Faker::Commerce.product_name,
    cover_photo: cover_photo_blob,
    price: Faker::Commerce.price.floor,
    condition: Listing.conditions.values.sample,
    tags: Faker::Commerce.send(:categories, 4),
    address_attributes: {
      line_1: Faker::Address.building_number,
      line_2: Faker::Address.street_address,
      city: Faker::Address.city,
      country: "GB",
      postcode: Faker::Address.postcode
    }
  )
  end