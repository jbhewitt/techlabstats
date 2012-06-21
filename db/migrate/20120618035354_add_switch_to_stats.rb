class AddSwitchToStats < ActiveRecord::Migration
  def change
    add_column :stats, :processed, :boolean
  end
end
