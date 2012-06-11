class CreateUsages < ActiveRecord::Migration
  def change
    create_table :usages do |t|
      t.string :name
      t.date :date
      t.integer :minutes
      t.integer :application_id
      t.integer :machine_id

      t.timestamps
    end
  end
end
