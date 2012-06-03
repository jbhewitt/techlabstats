class ChangeDateFormatInHistories < ActiveRecord::Migration
  def up
       change_column :histories, :time, :datetime
  end

  def down
           change_column :histories, :time, :date

  end
end
