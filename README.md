<!-- Shields -->
![](https://img.shields.io/badge/Ruby-2.5.3-orange)
![](https://img.shields.io/badge/Rails-5.2.4-informational?style=flat&logo=<LOGO_NAME>&logoColor=white&color=2bbc8a)
# Sweater Weather API
<hr>

## About This Project
Sweater weather is a rails API backend framework that calls multiple API's to return weather forecast data for a location with an accompanying background picture. Sweater weather returns current, 8 hour, and 5 day forecasts. A user can register an account, obtain a 24-character unique API key, and create a road-trip. Using the API key users can create road-trips by providing origin and destination locations and are served the estimated travel time in addition to temperature and weather condition upon arrival. For more information check out the [Project Overview](https://backend.turing.io/module3/projects/sweater_weather/requirements).

<h3>• [POSTMAN ENDPOINTS](https://github.com/elyhess/sweater_weather/blob/main/sweater_weather.postman_collection.json) •</h3>

## Learning Goals
* Expose an API that aggregates data from multiple external APIs.
* Expose an API that requires an authentication token.
* Expose an API for CRUD functionality.
* Determine completion criteria based on the needs of other developers.
* Research, select, and consume an API based on your needs as a developer.

## Setup Instructions
To get a local copy up and running follow these steps.

1. Clone the repo
   ```
   git clone https://github.com/elyhess/sweater_weather
   ```
2. Install dependencies
   ```
   bundle install
   ```
3. DB creation/migration
   ```
   rails db:{drop,create,migrate}
   ```
3. Run tests and view test coverage
   ```
   bundle exec rspec
   open coverage/index.html
   ```
4. Add API keys as environment variables
   ```
   MAPQUEST_API_KEY: <Your Key Here>
   WEATHER_API_KEY: <Your Key Here>
   UNSPLASH_API_KEY: <Your Key Here>
   ```
5. Run server and navigate to an [endpoint](https://github.com/elyhess/sweater_weather/blob/main/sweater_weather.postman_collection.json)
   ```
   rails s
   ```
   
## Database Architecture
<p align="center">
 <img src="https://github.com/elyhess/sweater_weather/blob/main/database_architecture.png">
</p>

## Acknowledgements
* [OpenWeatherMap API](https://openweathermap.org/api)
* [MapQuest API](https://developer.mapquest.com/documentation/)
* [Unsplash Image API](https://unsplash.com/documentation)
* [Turing School of Software & Design](https://turing.io/) 

## License
* Distributed under the MIT License. See [License]() for more information.