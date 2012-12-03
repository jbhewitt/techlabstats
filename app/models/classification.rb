class Classification < ActiveRecord::Base
  attr_accessible :name, :applications

  has_many :applications
end
