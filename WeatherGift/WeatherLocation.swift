//
//  WeatherLocation.swift
//  WeatherGift
//
//  Created by Bryan Kim on 4/11/18.
//  Copyright © 2018 Bryan Kim. All rights reserved.
//

import Foundation

class WeatherLocation: Codable{
    var name: String
    var coordinates: String
    
    init(name: String, coordinates: String){
        self.name = name
        self.coordinates = coordinates
    }
}

