  class AddLocations < ActiveRecord::Migration


  def change
    create_table :locations do |t|
      t.string :name
      t.string :state

      t.timestamps
    end
  end

end