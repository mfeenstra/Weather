class LocationsController < ApplicationController
  before_action :set_location, only: %i[ show edit update destroy ]

  # GET /locations or /locations.json
  def index
    @locations = Location.all.order('created_at DESC')
  end

  # GET /locations/1 or /locations/1.json
  def show
  end

  # GET /locations/new
  def new
    @location = Location.new
  end

  # POST /locations or /locations.json
  def create
    @location = Location.new(location_params)
    
    cached = false
    now = Time.now
    # returns only those created within the last CONFIG.cache_minutes
    cached_location = Location.where(zipcode: location_params[:zipcode].to_s,
                                     created_at: (now - CONFIG.cache_minutes.minutes)..now).first
    if cached_location.blank? then
      weather_svc = WeatherService.new(location_params[:city].downcase, location_params[:country].downcase)

      if weather_svc.data['main'].nil?
        redirect_to new_location_path, notice: "NOT FOUND."
        return
      end

      puts "NOT cached: #{weather_svc.city}, #{weather_svc.country}"
      unless @location.temp = weather_svc.data['main']['temp'] then
         @location.temp = nil
      end
      unless @location.feelslike = weather_svc.data['main']['feels_like'] then
         @location.feelslike = nil
      end
      unless @location.tempmin = weather_svc.data['main']['temp_min'] then
        @location.tempmin = nil
      end
      unless @location.tempmax = weather_svc.data['main']['temp_max'] then
        @location.tempmax = nil
      end
      unless @location.humidity = weather_svc.data['main']['humidity'] then
        @location.humidity = nil
      end
    else
      cached = true
      puts "\nFROM CACHE: #{cached_location.inspect}"
      @location = cached_location
    end

    respond_to do |format|
      if cached
        format.html { redirect_to @location, notice: "Loaded from cache: #{@location.age} old" }
      else
        if @location.save
          puts "\nSAVING: #{@location.inspect}"
          format.html { redirect_to @location, notice: "Location was successfully created." }
          format.json { render :show, status: :created, location: @location }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @location.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PATCH/PUT /locations/1 or /locations/1.json
  def update
    respond_to do |format|
      if @location.update(location_params)
        puts "\nUPDATE: #{@location.inspect}"
        format.html { redirect_to @location, notice: "Location was successfully updated." }
        format.json { render :show, status: :ok, location: @location }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @location.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /locations/1 or /locations/1.json
  def destroy
    puts "\nDESTROY: #{@location.inspect}"
    @location.destroy
    respond_to do |format|
      format.html { redirect_to locations_url, notice: "Location was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

    def set_location
      @location = Location.find(params[:id])
    end

    def location_params
      params.require(:location).permit(:zipcode, :address, :city, :state, :country)
    end
end
