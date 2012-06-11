class Machine < ActiveRecord::Base
  attr_accessible :name
  validates_uniqueness_of :name
  validates_presence_of :name

  has_many :histories
  has_many :usages

  def gen_daily_usage_stats

  end

  def gen_usage_stats
    #reset all usage stats
    usages = Usage.find_all_by_machine_id_and_date(self.id,histories[0].time.end_of_day)
    usages.each do |usage|
      usage.minutes = 0
      usage.save
    end

    self.histories.each do |history|  
      app = Application.find_by_process(history.process)
      date = Calendar.find_or_create_by_date(history.time.end_of_day)
      usage = Usage.find_or_create_by_application_id_and_machine_id_and_calendar_id(app.id,self.id,date.id)
      if ( usage.minutes.nil? )
        usage.minutes = 1
      else 
        
        usage.minutes = usage.minutes + 1
      end
      usage.save
    end
    #usage.pry
    
  end
end
