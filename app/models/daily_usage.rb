class DailyUsage < ActiveRecord::Base
  attr_accessible :application_id, :calendar_id, :machine_id, :name, :users

  belongs_to :machine
  belongs_to :application

end
