class MachinesController < ApplicationController
  # GET /machines
  # GET /machines.json
  def index
    @machines = Machine.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @machines }
    end
  end

  # GET /machines/1
  # GET /machines/1.json
  def show
    @machine = Machine.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @machine }
    end
  end


  # GET /machines/1
  # GET /machines/1.json
  def usage
    @machine = Machine.find(params[:id])
    @usages = @machine.usages
    @calendar = Calendar.all
    @calendar.pry
#    @machine.gen_usage_stats

    respond_to do |format|
      format.html # show.html.erb
    end
  end

    # GET /machines/1
  # GET /machines/1.json
  def daily_usage
    @machine = Machine.find(params[:id])
    
    day = DateTime.new(2012,06,10)
    @machine.gen_daily_user_usage(day)
    respond_to do |format|
      format.html # show.html.erb
    end
  end



end
