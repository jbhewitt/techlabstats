class Location < ActiveRecord::Base
  attr_accessible :name, :state

  has_many :machines
end
