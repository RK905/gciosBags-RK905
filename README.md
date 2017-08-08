# GC Baggo

GC Baggo is a simple Cornhole scoring application. Cornhole is a game where teams of two players play each other by throwing a bag full of corn to a board that has a hole on it. Each round consists of four throws for each team. If a bag lands in the ground, the team gets no points. If it lands in the board, the team gets 1 point. And if the bag goes in the hole, the team gets 3 points. At the end of each round, the team with the most points wins and adds the point difference to their total score.

There's two alternatives to decide the winning team:

 - At the end of a round, if a team has a total score of more than 21 points and has a lead of 2 or more points over the other team, they are declared the winners.
 - At the end of a round, if a team has a total score of 21 points exactly, they're the winners. If the team goes over their total score is reverted back to 11.

You can check the full rules of Cornhole in http://www.cornholehowto.com/how-to-play/.


#Weather Task
In order to make the experience more immersive we want the background image to change depending on actual weather conditions. To do that we'll query OpenWeatherMap's API at the beginning of each game and change the grass background depending on the response.

There will be three possible backgrounds: sunBG, rainBG, and cloudyBG. These assets are already included in the app's asset catalog.

In the future we will want to query the API with location specific data, but for now we're fine just assuming that most of the users are located in New York.

API documentation: https://openweathermap.org/current

API Key: 8855d8df419b9e97c03b5c7fc9297d06

Endpoint url: http://api.openweathermap.org/data/2.5/weather

Arguments:

lat: Latitude
lon: Longitude
APPID: Api key
Latitude and Longitude for 86 Chambers: 40.714628, -74.007315

Example response:

{"coord":{"lon":139,"lat":35},
"sys":{"country":"JP","sunrise":1369769524,"sunset":1369821049},
"weather":[{"id":804,"main":"clouds","description":"overcast clouds","icon":"04n"}],
"main":{"temp":289.5,"humidity":89,"pressure":1013,"temp_min":287.04,"temp_max":292.04},
"wind":{"speed":7.31,"deg":187.002},
"rain":{"3h":0},
"clouds":{"all":92},
"dt":1369824698,
"id":1851632,
"name":"Shuzenji",
"cod":200}
Posible values for weather.main

Sunny BG:
Clear
Additional
Rain BG:
Thunderstorm
Drizzle
Rain
Snow
Extreme
Cloudy BG:
Atmosphere
Clouds
