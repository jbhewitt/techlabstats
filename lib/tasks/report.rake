namespace :report do
  desc "TODO"

  task :weekly => :environment  do
    puts '-= generating weekly report =-'
    # spreadsheet startup
    Spreadsheet.client_encoding = 'UTF-8'
    book = Spreadsheet::Workbook.new
    sheet = Hash.new
    sheet1 = book.create_worksheet :name => 'USER USAGE'
    
    today = DateTime.now
    today = DateTime.civil(2012,7,20,0,0,0,0)
    target_week = today - 7 
    #today = today - 2
    #today = Chronic.parse('2012-09-13')
    beginning_of_week = target_week.beginning_of_week 
    end_of_week = target_week.end_of_week

    machines = Machine.find(:all)

    puts "Week Number #{target_week.cweek}"
    number_of_days = end_of_week - beginning_of_week
    day_of_week = 0

    sheet1[0,0] = 'MACHINE'

    while day_of_week < number_of_days      
      day = beginning_of_week + day_of_week
      column_no = day_of_week + 1

      #set top row date
      sheet1[0,column_no] = day.strftime("%d-%m-%Y") 

      weekly_process = Hash.new
      machines.each_with_index do |machine, index|
        row_no = index + 1
        daily_usage = machine.gen_daily_user_usage(day)
        idle_usage = daily_usage['total_user_sessions']

        #set machine name
        sheet1[row_no,0] = machine.name
        sheet1[row_no,column_no] = idle_usage
        puts "#{machine.name} - #{day_of_week} - #{idle_usage}"
        
        #cycle throw processes
        processes = daily_usage['process']
        p_rowcount = 2
        processes.each do |process, minutes|
          #do not count mdx demo
          if process == "Microsoft.MDX.Demo.exe"           
          else
            if sheet[machine.name].nil?
              #setup sheet basics
              sheet[machine.name] = book.create_worksheet :name => machine.name
              sheet[machine.name][0,0] = machine.name
              sheet[machine.name][0,3] = "WEEK #{target_week.cweek}"
              sheet[machine.name][0,4] = "YEAR #{target_week.cwyear}"
              sheet[machine.name][1,0] = "PROCESS"
              sheet[machine.name][1,1] = "MINUTES USED"
            end
             sheet[machine.name][p_rowcount, 0] = process
             sheet[machine.name][p_rowcount, 1] = minutes
             p_rowcount += 1 
         #   sheet1[row_no,column_no] = 
          end
        end

      end
      day_of_week += 1 
    end

    book.write "#{Rails.root}/public/reports/TECHLAB-#{target_week.cwyear}-WEEK#{target_week.cweek}.xls"
  end

  def test123
    puts 'test123'
  end
end
