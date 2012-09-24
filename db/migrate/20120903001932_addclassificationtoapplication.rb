class Addclassificationtoapplication < ActiveRecord::Migration
  def up
    add_column :applications, :classification_id, :integer

  end

  def down
  end
end
