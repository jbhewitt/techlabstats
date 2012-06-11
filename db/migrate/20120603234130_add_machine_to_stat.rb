class AddMachineToStat < ActiveRecord::Migration
  def change
    add_column :stats, :machine_id, :integer
    add_column :histories, :machine_id, :integer

  end
end
