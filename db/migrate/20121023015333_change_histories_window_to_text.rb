class ChangeHistoriesWindowToText < ActiveRecord::Migration
  def up
		change_column :histories, :window, :text, :limit => nil
  end

  def down
  end
end
