class Machine < ActiveRecord::Base
  attr_accessible :name
  validates_uniqueness_of :name
  validates_presence_of :name

  has_many :histories
  has_many :usages
  has_many :daily_usages


  def gen_daily_user_usage(day)
    min_idle_minutes = 5
    min_process_minutes = 8

    start_date = day
    end_of_day_date = start_date.end_of_day

    histories = History.where(:machine_id => self.id, :time => start_date..end_of_day_date).all

    total_user_sessions = 0
    total_idle_count = 0
    idle_count = 0
    process_count = 0
    previous_idle = 0
    process_minutes = Hash.new

#    histories.pry
    histories.each do |history|
      if history.process == 'IDLE'        
        previous_idle = 1
        idle_count = idle_count + 1      
      else 
        #not idle - so it's another process
        previous_idle = 0 
        process_count = process_count + 1 
        if (process_count >= min_process_minutes) && (idle_count >= min_idle_minutes)
          total_user_sessions = total_user_sessions + 1
          process_count = 0
        end
      end
      #record total minutes for all processes
      process_name = history.process.split('\\').last
      if process_minutes[process_name].nil?
        process_minutes[process_name] = 1
      else
        process_minutes[process_name] += 1 
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
  
end
