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

    #find last history recorded for machine
    last_history = History.find_last_by_machine_id(self.machine.id, :order => 'time ASC')
    if last_history.nil?
      last_import_time = Chronic.parse('2012-01-01')
    else
      last_import_time = last_history.time
    end
   


   # last_import_date_str = last_history.time("%Y/%m/%d")
    today = Time.now
    #today_date_str = today.time("%Y/%m/%d")

    #decompress 7zip file
    system "cd #{Rails.root}/tmp; 7z -y x #{Rails.root}/public#{self.fileupload}"
 
    db = SQLite3::Database.open( "#{Rails.root}/tmp/upload.dat" )
    columns, *rows = db.execute2( "select * from snapshot" )
    # snapshot rows = 
    # 0 = "id", 1 = "time", 2 = "window", 3 = "process", 4 = "user"]
    columns = nil
    sql_query = "select * from snapshot WHERE time BETWEEN '#{last_import_time.to_s}' AND '#{today.to_s}';"
    puts sql_query
    db.execute2( sql_query ) do |row|
     if columns.nil?
        columns = row
      else        
        #puts row[1]
        time = Chronic.parse(row[1])
        #time = DateTime.parse(row[1])
        #if time_difference is postive then it is a newer record, so iport

        time_difference = time - last_import_time
        if time_difference > 0           
          #puts "#{self.machine.name} | #{time}"

          history = History.find_or_create_by_time_and_machine_id(time,self.machine.id)
          if history.process.nil?
            history.window = row[2]
            history.process = row[3]
            history.save
            puts "#{self.machine.name} | #{time} | SAVING HISTORY FOR #{history.process}"
          end
          #import application name
          app = Application.find_or_create_by_process(history.process)
          if (app.name.nil?)
            app.name = history.process.split('\\').last
            app.save
          end
        end
      end
    
    end

    #endtime = Time.new


  end
end