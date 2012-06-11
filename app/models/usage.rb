class Usage < ActiveRecord::Base
  attr_accessible :application_id, :date, :machine_id, :minutes, :name

  belongs_to :machine
  belongs_to :application
  belongs_to :calendar

end
