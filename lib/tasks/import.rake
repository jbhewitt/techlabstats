namespace :import do
  desc "TODO"

  task :all_stats => :environment  do
    puts '-=PROCESSING ALL DBs INTO HISTORIES=-'
    stats = Stat.where(:processed => nil)
    #stats.pry
    stats.each_with_index do |stat, index|
      puts "-==== importing #{stat.name} ====-"
      stat.import_wam_db
      stat.processed = true
      stat.save
    end

    puts 'all done importing!'
  end
end
