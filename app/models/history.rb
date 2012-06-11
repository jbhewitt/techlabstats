class History < ActiveRecord::Base
  attr_accessible :process, :time, :window, :machine_id
  

  belongs_to :machine
end
