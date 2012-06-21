class CreateDailyUsages < ActiveRecord::Migration
  def change
    create_table :daily_usages do |t|
      t.string :name
      t.integer :users
      t.date :date
      t.integer :application_id
      t.integer :machine_id
      t.timestamps
    end
  end
end
