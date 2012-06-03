class CreateHistories < ActiveRecord::Migration
  def change
    create_table :histories do |t|
      t.string :window
      t.string :process
      t.date :time

      t.timestamps
    end
  end
end
