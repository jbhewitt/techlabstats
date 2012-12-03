class ChangeNoLimitToApplicationsProcess < ActiveRecord::Migration
  def up
	change_column :histories, :process, :text, :limit => nil
	change_column :applications, :process, :text, :limit => nil
  end

  def down
  end
end
