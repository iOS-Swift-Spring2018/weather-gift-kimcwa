//
//  WeatherLocationStruct.swift
//  WeatherGift
//
//  Created by Bryan Kim on 3/21/18.
//  Copyright © 2018 Bryan Kim. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class WeatherDetail: WeatherLocation{
    
    struct DailyForecast{
        var dailyMaxTemp: Double
        var dailyMinTemp: Double
        var dailyDate: Double
        var dailyIcon: String
        var dailySummary: String
    }
    
    struct HourlyForecast{
        var hourlyTime: Double
        var hourlyTemperature: Double
        var hourlyPrecipProb: Double
        var hourlyIcon: String
    }
    
    var currentTemp = "--"
    var currentSummary = ""
    var currentIcon = ""
    var currentTime = 0.0
    var timeZone = ""
    var hourlyForecastArray = [HourlyForecast]()
    var dailyForecastArray = [DailyForecast]()
    
    func getWeather(completed: @escaping () -> ()){
        let weatherURL = urlBase + urlAPIKey + coordinates
        
        Alamofire.request(weatherURL).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                if let temperature = json["currently"]["temperature"].double {
                    print("temp:\(temperature)")
                    let roundedTemp = String(format: "%3.f", temperature)
                    self.currentTemp = roundedTemp + "°"
                }else{
                    print("couldn't get temperature")
                }
                //daily summary
                if let summary = json["daily"]["summary"].string {
                    self.currentSummary = summary
                    print("The summary for \(self.name) is \(self.currentSummary).")
                }else{
                    print("couldn't get summary")
                }
                //current icon
                if let icon = json["currently"]["icon"].string {
                    self.currentIcon = icon
                    print("The summary for \(self.name) is \(self.currentSummary).")
                }else{
                    print("couldn't get icon")
                }
                //current timeZone
                if let timeZone = json["timezone"].string {
                    self.timeZone = timeZone
                    print("Timezone for \(self.name) is \(self.timeZone).")
                }else{
                    print("couldn't get timeZone")
                }
                //current time
                if let time = json["currently"]["time"].double {
                    self.currentTime = time
                    print("Time for \(self.name) is \(time).")
                }else{
                    print("couldn't get timeZone")
                }
                
                let dailyDataArray = json["daily"]["data"]
                self.dailyForecastArray = []
                let days = min(7, dailyDataArray.count-1)
                for day in 1...days{
                    let maxTemp = json["daily"]["data"][day]["temperatureHigh"].doubleValue
                    let minTemp = json["daily"]["data"][day]["temperatureLow"].doubleValue
                    let dateValue = json["daily"]["data"][day]["time"].doubleValue
                    let icon = json["daily"]["data"][day]["icon"].stringValue
                    let dailySummary = json["daily"]["data"][day]["summary"].stringValue
                    let newDailyForecast = DailyForecast(dailyMaxTemp: maxTemp, dailyMinTemp: minTemp, dailyDate: dateValue, dailyIcon: icon, dailySummary: dailySummary)
                    self.dailyForecastArray.append(newDailyForecast)
                }
                
                let hourlyDataArray = json["hourly"]["data"]
                self.hourlyForecastArray = []
                let hours = min(24, hourlyDataArray.count-1)
                for hour in 1...hours{
                    let hourlyTime = json["hourly"]["data"][hour]["time"].doubleValue
                    let hourlyTemperature = json["hourly"]["data"][hour]["temperature"].doubleValue
                    let hourlyPrecipProb = json["hourly"]["data"][hour]["precipProbability"].doubleValue
                    let hourlyIcon = json["hourly"]["data"][hour]["icon"].stringValue
                    let newHourlyForecast = HourlyForecast(hourlyTime: hourlyTime, hourlyTemperature: hourlyTemperature, hourlyPrecipProb: hourlyPrecipProb, hourlyIcon: hourlyIcon)
                    self.hourlyForecastArray.append(newHourlyForecast )
                    
                }
                
            case .failure(let error):
                print(error)
            }
            completed()
        }
    }
}
