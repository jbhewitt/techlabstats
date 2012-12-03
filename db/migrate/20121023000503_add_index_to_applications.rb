class AddIndexToApplications < ActiveRecord::Migration
  def change
	add_index :histories, :time
	add_index :histories, :process
	add_index :histories, :window
	add_index :histories, :machine_id
	add_index :applications, :name
	add_index :applications, :process
  end
end
