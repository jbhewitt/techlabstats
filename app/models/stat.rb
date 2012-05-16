class Stat < ActiveRecord::Base
  require 'carrierwave/orm/activerecord'
  
  mount_uploader :fileupload, FileUploader


  attr_accessible :fileupload, :name

end
