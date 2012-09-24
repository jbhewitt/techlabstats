class Application < ActiveRecord::Base
  attr_accessible :name, :process, :classification_id

  attr_accessible :classification_attributes
  belongs_to :classification
end
