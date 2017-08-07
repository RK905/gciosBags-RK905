//
//  WeatherApi.swift
//  gciosBags
//
//  Created by Rayen Kamta on 8/7/17.
//  Copyright © 2017 GameChanger. All rights reserved.
//


import Foundation

class WeatherApi {

    init(delegate: WeatherApiDelegate) {
        self.delegate = delegate
    }
    private let openWeatherMapBaseURL = "http://api.openweathermap.org/data/2.5/weather"
    private let openWeatherMapAPIKey = "8855d8df419b9e97c03b5c7fc9297d06"
     private var delegate: WeatherApiDelegate

    func getGPSWeather(lat: String, long: String){
        let url = URL(string: "\(openWeatherMapBaseURL)?APPID=\(openWeatherMapAPIKey)&lat=\(lat)&lon=\(long)")!
        let session = URLSession.shared
        let task = session.dataTask(with: url) { (data:Data?, response:URLResponse?, error:Error?) in
            if let error = error {
                print("Error:\n\(error)")
            }
            else {
                let dataString = String(data: data!, encoding: String.Encoding.utf8)
                do {
                    let weatherJson = try JSONSerialization.jsonObject(
                        with: data!,
                        options: .mutableContainers) as! [String: AnyObject]
     
                    let weather = Weather(weatherData: weatherJson)
                    self.delegate.didGetWeather(weather: weather)
                    
                }
                catch let jsonError as NSError {
                    print("JSON error description: \(jsonError.description)")
                }
            }
            
        }
        
        task.resume()
        
    }
}



protocol WeatherApiDelegate {
    func didGetWeather(weather: Weather)
    func didNotGetWeather(error: NSError)
}
