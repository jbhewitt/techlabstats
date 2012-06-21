class Machine < ActiveRecord::Base
  attr_accessible :name
  validates_uniqueness_of :name
  validates_presence_of :name

  has_many :histories
  has_many :usages
  has_many :daily_usages

  def gen_daily_user_usage(day)
    min_idle_minutes = 8

    start_date = day
    end_of_day_date = start_date.end_of_day

    histories = History.where(:machine_id => self.id, :time => start_date..end_of_day_date).all

    total_user_sessions = 0
    idle_count = 0
    previous_idle = 0
    process_minutes = Hash.new

#    histories.pry
    histories.each do |history|
      if history.process == 'IDLE'        
        previous_idle = 1
        idle_count = idle_count + 1
      else 
        previous_idle = 0
        process_name = history.process.split('\\').last
        if process_minutes[process_name].nil?
          process_minutes[process_name] = 1
        else
          process_minutes[process_name] += 1 
        end
      end
      
      if (idle_count >= min_idle_minutes) && (previous_idle == 0) 
        total_user_sessions = total_user_sessions + 1
        idle_count = 0 
      end
    end

    #total_user_sessions.pry
    #histories.pry
    #process_minutes.pry
    returnit = Hash.new
    returnit['total_user_sessions'] = total_user_sessions
    returnit['process'] = process_minutes.sort_by {|key,value| value}

    return (returnit)
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
