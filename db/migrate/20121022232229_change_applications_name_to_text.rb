class ChangeApplicationsNameToText < ActiveRecord::Migration
  def up
	change_column :applications, :process, :text
	change_column :histories, :process, :text

  end

  def down
	change_column :applications, :process, :string
	change_column :histories, :process, :string
  end
end
