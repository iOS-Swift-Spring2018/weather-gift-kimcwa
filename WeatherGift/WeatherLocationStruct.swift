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

struct WeatherLocation {
    var name = ""
    var coordinates = ""
    var currentTemp = "--"
    
    func getWeather(completed: @escaping () -> ()) {
        
        let weatherURL = urlBase + urlAPIKey + coordinates
        print(weatherURL)
        
        Alamofire.request(weatherURL).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("***** json: \(json)")
                if let temperature = json["currently"]["temperature"].double {
                    print("***** temperature inside getWeather = \(temperature)")
                    let roundedTemp = String(format: "%3.f", temperature)
                    self.currentTemp = roundedTemp + "°"
                } else {
                    print("Could not return temperature")
                }
            case .failure(let error):
                print(error)
        }
            completed()
    }
}

}
