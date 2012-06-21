class Stat < ActiveRecord::Base
  require 'carrierwave/orm/activerecord'
  
  mount_uploader :fileupload, FileUploader

  attr_accessible :fileupload, :name, :machine_id, :remove_fileupload, :fileupload_cache, :processed
  #validates_presence_of :machine_id
  validates_presence_of :fileupload

  belongs_to :machine

  before_create :upcase_name
  before_create :check_machine

  def upcase_name
    self.name = self.name.upcase
  end

  def check_machine
    if self.machine.nil?
      machine = Machine.find_or_create_by_name(self.name)
      self.machine = machine
    end
  end

  def import_wam_db
    require 'sqlite3'

    #decompress 7zip file
    system "cd #{Rails.root}/tmp; 7z -y x #{Rails.root}/public#{self.fileupload}"
 
    db = SQLite3::Database.open( "#{Rails.root}/tmp/upload.dat" )
    columns, *rows = db.execute2( "select * from snapshot" )
    # snapshot rows = 
    # 0 = "id", 1 = "time", 2 = "window", 3 = "process", 4 = "user"]
    columns = nil
    db.execute2( "select * from snapshot" ) do |row|
     if columns.nil?
        columns = row
      else
        time = Chronic.parse(row[1])
        #time = row[1]
        history = History.find_or_create_by_time(time)
        history.machine = self.machine
        history.window = row[2]
        history.process = row[3]
        history.save
        #import application name
        app = Application.find_or_create_by_process(history.process)
        if (app.name.nil?)
          app.name = history.process.split('\\').last
        end
        app.save
      end
    end
  end
end