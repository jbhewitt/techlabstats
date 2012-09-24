class CreateLocations < ActiveRecord::Migration

   def change
    add_column :machines, :location_id, :integer
  end
end
