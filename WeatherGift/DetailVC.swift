//
//  DetailVC.swift
//  WeatherGift
//
//  Created by Bryan Kim on 3/18/18.
//  Copyright © 2018 Bryan Kim. All rights reserved.
//

import UIKit
import CoreLocation

class DetailVC: UIViewController {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var currentImage: UIImageView!
    
    var currentPage = 0
    var locationsArray = [WeatherLocation]()
    var locationManager: CLLocationManager!
    var currentLocation: CLLocation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if currentPage != 0 {
            self.locationsArray[currentPage].getWeather {
                self.updateUserInterface()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if currentPage == 0 {
            getLocation()
        }
    }

    func updateUserInterface() {
        locationLabel.text = locationsArray[currentPage].name
        dateLabel.text = locationsArray[currentPage].coordinates
        temperatureLabel.text = locationsArray[currentPage].currentTemp
        print("%%%% currentTemp inside updateUserInterface = \(locationsArray[currentPage].currentTemp)")
    }
    


}

extension DetailVC: CLLocationManagerDelegate {
    
    func getLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
    }
    
    func handleLocationAuthorizationStatus(status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedAlways, .authorizedWhenInUse: // location allowed
            locationManager.requestLocation()
        case .denied:
            print("I'm sorry, can't show location. USer has not authorized it.")
        case .restricted:
            print("Access denied. Likely parental controls retrict location services in this app")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) { // changing privacy in settings
        handleLocationAuthorizationStatus(status: status) // only happens once when you first download the app
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) { // when we get a location this is called
      let geoCoder = CLGeocoder()
      var place = ""
      currentLocation = locations.last
      let currentLatitude = currentLocation.coordinate.latitude
      let currentLongitude = currentLocation.coordinate.longitude
      let currentCoordinates = "\(currentLatitude),\(currentLongitude)"
//      print(currentCoordinates)
      dateLabel.text = currentCoordinates
      geoCoder.reverseGeocodeLocation(currentLocation, completionHandler: {
        placemarks, error in
        if placemarks != nil {
            let placemark = placemarks?.last
            place = (placemark?.name)!
        } else {
            print("Error retrieving place. Error code: \(error!)")
            place = "Unknown Weather Location"
        }
        self.locationsArray[0].name = place
        self.locationsArray[0].coordinates = currentCoordinates
        self.locationsArray[0].getWeather {
            self.updateUserInterface()
        }
      })
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get user location.")
    }
}
