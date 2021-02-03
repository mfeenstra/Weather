# Using OpenWeather's api.openweathermap.org
class WeatherService

  attr_reader :city, :country, :data

  def initialize(city, country)
    @city = city
    @country = country
    @data = fetch_weather(@city, @country)
  end

  private

  def fetch_weather(city, country)

    query_data = { appid: Rails.application.credentials.openweather[:api_key],
                   q:     "#{city},#{country}",
                   units: CONFIG.temp_units }
    uri_string = "#{CONFIG.api_url}?#{query_data.to_query}"
    puts "URI: #{uri_string}"

    attempt = 0
    while attempt < 3
      begin
        attempt += 1
        uri = URI.parse(uri_string)
        http = Net::HTTP.new(uri.host, uri.port)
        request = Net::HTTP::Get.new(uri.request_uri)
        response = Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
          http.request(request)
        end
        response_code = response.code.to_i
        print 'http '
        puts "[#{response_code}]"
        break
      rescue StandardError => e
        response_code = response.code.to_i
        print 'http '
        puts "[#{response_code}]"
        puts "fetch_weather: Connection error (#{attempt} of 3): #{e}"
        sleep 3
      end
    end
    JSON.parse(response.body)
  end

end
