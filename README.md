# Weather App Server
### matt.a.feenstra@gmail.com
---
## A fully functional Ruby on Rails application server, demonstrating the [OpenWeather API](https://openweathermap.org/api).
---
*  No external dependencies required.
*  If necessary, set your OpenWeather API key (openweather => api_key) with: ```rails credentials:edit```
*  Available here: [OpenWeather API](https://openweathermap.org/api)
*  Configuration parameters in: ```config/weather.yml```
*  For OpenWeather API calls, see: ```app/services/weather_service.rb```
*  Listener binding is in: ```config/puma.yml``` with ```http://0.0.0.0:8080```
*  Tests can be ran from Rails.root: ```test.sh```
*  Ruby version: ```ruby 2.7.1p83 (2020-03-31 revision a0c7c23c9c) [x86_64-linux]```
*  Rails version: ```Rails 6.0.3.4```
---
