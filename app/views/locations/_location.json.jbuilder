json.extract! location, :id, :code, :name, :country, :temp, :feelslike, :tempmin, :tempmax, :humidity, :created_at, :updated_at
json.url location_url(location, format: :json)
