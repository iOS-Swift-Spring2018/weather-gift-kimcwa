//
//  ListVC.swift
//  WeatherGift
//
//  Created by Bryan Kim on 3/18/18.
//  Copyright © 2018 Bryan Kim. All rights reserved.
//

import UIKit
import GooglePlaces

class ListVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var editBarButton: UIBarButtonItem!
    @IBOutlet weak var addBarButton: UIBarButtonItem!
    
    
    var locationsArray = [WeatherLocation]()
    var currentPage = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "unwindToPageVC" {
            let destination = segue.destination as! PageVC
            currentPage = (tableView.indexPathForSelectedRow?.row)!
            destination.currentPage = currentPage
            destination.locationsArray = locationsArray
        }
    }
    
    @IBAction func editBarButtonPressed(_ sender: UIBarButtonItem) {
        if tableView.isEditing == true {
            tableView.setEditing(false, animated: true)
            editBarButton.title = "Edit"
            addBarButton.isEnabled = true
        } else {
            tableView.setEditing(true, animated: true)
            editBarButton.title = "Done"
            addBarButton.isEnabled = false
        }
    }
    
    @IBAction func addBarButtonPressed(_ sender: UIBarButtonItem) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }
    
}


extension ListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath)
        cell.textLabel?.text = locationsArray[indexPath.row].name
        return cell
    }
    
    //MARK:- TableView editing Functions
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            locationsArray.remove(at: indexPath.row)   // INDEX PATH IS THE ROW, and INDEXPATH.ROW is the specific country
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let itemToMove = locationsArray[sourceIndexPath.row]
        locationsArray.remove(at: sourceIndexPath.row)
        locationsArray.insert(itemToMove, at: destinationIndexPath.row)
    }
    
    // MARK:- tableView methods to freeze the first cell
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool { // precent the first cell from being able to be edited
        return (indexPath.row != 0 ? true : false)
    }
    
    func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath      proposedDestinationIndexPath: IndexPath) -> IndexPath { // prevent any cell being moved into the position of the first cell
        return (proposedDestinationIndexPath.row == 0 ? sourceIndexPath : proposedDestinationIndexPath)
    }
    
    func updateTable(place: GMSPlace){ // put searched location in table
        let newIndexPath = IndexPath(row: locationsArray.count, section: 0)
        var newWeatherLocation = WeatherLocation()
        newWeatherLocation.name = place.name
        let latitude = place.coordinate.latitude
        let longitude = place.coordinate.longitude
        newWeatherLocation.coordinates = ("\(latitude),\(longitude)")
        print(newWeatherLocation.coordinates)
        locationsArray.append(newWeatherLocation)
        tableView.insertRows(at: [newIndexPath], with:.automatic)
    }
    
    }

extension ListVC: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(place.name)")
        print("Place address: \(place.formattedAddress)")
        print("Place attributions: \(place.attributions)")
        dismiss(animated: true, completion: nil)
        updateTable(place: place)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}

