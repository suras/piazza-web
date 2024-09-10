class AddGeocodingToAddress < ActiveRecord::Migration[7.1]
  def change
    change_table :addresses do |t|
      t.decimal :latitude
      t.decimal :longitude
    end
    add_index :addresses, [:latitude, :longitude]
  end
end
