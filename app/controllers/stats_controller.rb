class StatsController < ApplicationController
  # GET /stats
  # GET /stats.json




  def index
    @stats = Stat.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @stats }
    end
  end

  # GET /stats/1
  # GET /stats/1.json
  def show
    @stat = Stat.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @stat }
    end
  end

  def import
    @stat = Stat.find(params[:id])

    #decompress 7zip file
    #system "7z -y x #{Rails.root}/public#{@stat.fileupload}"
    
    require 'sqlite3'

    db = SQLite3::Database.open( "upload.dat" )
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
        history.window = row[2]
        history.process = row[3]
        history.save
      # process row
      @test = time
      end
    end

  #test = db.get_first_row( "select * from snapshot" )
  #puts test.inspect


    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @stat }
    end
  end

  # GET /stats/new
  # GET /stats/new.json
  def new
    @stat = Stat.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @stat }
    end
  end

  # GET /stats/1/edit
  def edit
    @stat = Stat.find(params[:id])
  end

  # POST /stats
  # POST /stats.json
  def create
    @stat = Stat.new(params[:stat])

    respond_to do |format|
      if @stat.save
        format.html { redirect_to @stat, notice: 'Stat was successfully created.' }
        format.json { render json: @stat, status: :created, location: @stat }
      else
        format.html { render action: "new" }
        format.json { render json: @stat.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /stats/1
  # PUT /stats/1.json
  def update
    @stat = Stat.find(params[:id])

    respond_to do |format|
      if @stat.update_attributes(params[:stat])
        format.html { redirect_to @stat, notice: 'Stat was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @stat.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /stats/1
  # DELETE /stats/1.json
  def destroy
    @stat = Stat.find(params[:id])
    @stat.destroy

    respond_to do |format|
      format.html { redirect_to stats_url }
      format.json { head :no_content }
    end
  end
end
