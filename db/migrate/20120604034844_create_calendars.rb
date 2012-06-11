class CreateCalendars < ActiveRecord::Migration
  def change
    add_column :usages, :calendar_id, :integer

    create_table :calendars do |t|
      t.date :date

      t.timestamps
    end
  end
end
