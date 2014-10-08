class TripsController < ApplicationController
  before_action :set_trip, only: [:show, :edit, :update, :destroy]

  # GET /trips
  # GET /trips.json
  def index
    @trips = Trip.all
  end

  # GET /trips/1
  # GET /trips/1.json
  def show
   
    @url = "https://maps.googleapis.com/maps/api/directions/json?origin=#{@trip.origin.gsub(" ", "_") + "_ny"}&destination=#{@trip.destination.gsub(" ", "_") + "_ny"}"
    
    #driving details
    @drivingroute=HTTParty.get(@url)
    @drivingroutedetails = {'distance' => @drivingroute['routes'][0]['legs'][0]['distance']['text'], 'time' => @drivingroute['routes'][0]['legs'][0]['duration']['text']}
    @urltransit = "https://maps.googleapis.com/maps/api/directions/json?origin=#{@trip.origin.gsub(" ", "_") + "_ny"}&destination=#{@trip.destination.gsub(" ", "_") + "_ny"}&departure_time=#{@trip.departure_time.to_i}&mode=transit"

    #transit details
    @transitroute=HTTParty.get(@urltransit)
    @transitroutedetails = {'distance' => @transitroute['routes'][0]['legs'][0]['distance']['text'], 'time' => @transitroute['routes'][0]['legs'][0]['duration']['text']}

    
    @carbondioxideemission = @drivingroute['routes'][0]['legs'][0]['distance']['text'].to_f*248
    @gasolineused = @drivingroute['routes'][0]['legs'][0]['distance']['text'].to_f*0.04149

    # Trip.find(params[:id]).cabcost(@drivingroutedetails['distance'].to_f,@drivingroutedetails['time'].to_i)

    @moneyspent = Trip.find(params[:id]).cabcost(@drivingroutedetails['distance'].to_f,@drivingroutedetails['time'].to_i)
    @moneysaved = (@moneyspent/(Trip.find(params[:id]).number_of_people.to_f) - 2.50).to_f


    # 163g  of CO2 emitted per mile for transit....411g of C02 emitted per mile for cars = 248 diff
    # 9.4g of CO emitted per mile for cars ...
    #sources: EPA, CarbonFund.org, 

    #http://www.epa.gov/otaq/consumer/420f08024.pdf

    #stats to be seen: CO2, gasoline saved, money saved 


  
  end

  # GET /trips/new
  def new
    @trip = Trip.new
    
  end

  # GET /trips/1/edit
  def edit
  end

  # POST /trips
  # POST /trips.json
  def create
    @trip = Trip.new(trip_params)

    respond_to do |format|
      if @trip.save
        format.html { redirect_to @trip, notice: 'Trip was successfully created.' }
        format.json { render :show, status: :created, location: @trip }
      else
        format.html { render :new }
        format.json { render json: @trip.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /trips/1
  # PATCH/PUT /trips/1.json
  def update
    respond_to do |format|
      if @trip.update(trip_params)
        format.html { redirect_to @trip, notice: 'Trip was successfully updated.' }
        format.json { render :show, status: :ok, location: @trip }
      else
        format.html { render :edit }
        format.json { render json: @trip.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /trips/1
  # DELETE /trips/1.json
  def destroy
    @trip.destroy
    respond_to do |format|
      format.html { redirect_to trips_url, notice: 'Trip was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_trip
      @trip = Trip.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def trip_params
      params.require(:trip).permit(:origin, :destination, :latitude, :longitude, :number_of_people, :departure_time)
    end
end
