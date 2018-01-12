//
//  SearchViewController.swift
//  Detourist
//
//  Created by Lauren Cardella on 1/6/18.
//  Copyright © 2018 Lauren Cardella. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps
import GooglePlaces

class SearchViewController: UIViewController, CLLocationManagerDelegate, GMSAutocompleteResultsViewControllerDelegate {
    
    @IBOutlet weak var mapView: GMSMapView!
    let locationManager = CLLocationManager()
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController?.delegate = self
        
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController
        
        // Put the search bar in the navigation bar
        searchController?.searchBar.sizeToFit()
        navigationItem.titleView = searchController?.searchBar
        
        // When UISearchController presents the results view, present it in this view controller, not the one further up the chain
        definesPresentationContext = true
        
        // Prevent the navigation bar from being hidden when searching.
        searchController?.hidesNavigationBarDuringPresentation = false
        
        let latitude = locationManager.location?.coordinate.latitude ?? 23.1136
        let longitude = locationManager.location?.coordinate.longitude ?? 82.3666
        
        let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: 10.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        self.view = mapView
        self.mapView?.isMyLocationEnabled = true
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
         // locationManager.stopUpdatingLocation()
    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController, didAutocompleteWith place: GMSPlace) {
        searchController?.isActive = false
        // Do something with the selected place.
        
        let marker = GMSMarker(position: (place.coordinate))
        marker.title = place.name
        marker.snippet = place.formattedAddress
        
        let markerLat = place.coordinate.latitude
        let markerLon = place.coordinate.longitude
        let camera = GMSCameraPosition.camera(withLatitude: markerLat, longitude: markerLon, zoom: 13.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        self.view = mapView

        print("Place name: \(place.name)")
        print("Place address: \(String(describing: place.formattedAddress))")
    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    func didRequestAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView (_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
