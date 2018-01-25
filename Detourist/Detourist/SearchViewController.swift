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
import Firebase

class SearchViewController: UIViewController, CLLocationManagerDelegate, GMSAutocompleteResultsViewControllerDelegate, GMSMapViewDelegate {
    
    @IBOutlet var mapView: GMSMapView?
    @IBOutlet weak var placeInfoView: PlaceInfoView!
    
    let userKey = Auth.auth().currentUser?.uid
    
    
    let locationManager = CLLocationManager()
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?
    
    var currentPlace: GMSPlace?
    
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
        
        let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: 12.0)
        self.mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        self.mapView?.delegate = self
        
        self.mapView?.isMyLocationEnabled = true
        self.mapView?.settings.myLocationButton = true
        self.view = self.mapView
        self.view.addSubview(placeInfoView)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.stopUpdatingLocation()
    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController, didAutocompleteWith place: GMSPlace) {
        searchController?.isActive = false
        // Do something with the selected place.
        
        let marker = GMSMarker(position: place.coordinate)
        
        self.placeInfoView?.placeNameLabel.text = place.name
        self.placeInfoView?.placeAddressLabel.text = place.formattedAddress
        self.currentPlace = place

        self.mapView?.animate(toLocation: place.coordinate)
        marker.map = mapView
        self.placeInfoView?.isHidden = false
        self.placeInfoView.addButton.addTarget(self, action: #selector(addPlace), for: .touchUpInside)
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
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        // self.placeInfoView?.isHidden = true
    }
    
    @IBAction func addPlace() {
        print("add Button pressed")
        let currentCoordinate = ["latitude": currentPlace?.coordinate.latitude, "longitude": currentPlace?.coordinate.longitude]
        
        let userPlacesRef = Database.database().reference().child("users").child(userKey!).child("places")
        let placeRef = userPlacesRef.childByAutoId()
        let newPlace = Place(name: (currentPlace?.name)!, placeId: (currentPlace?.placeID)!, address: (currentPlace?.formattedAddress)!, coordinate: currentCoordinate as! [String : Double], visited: false)
        
        if currentPlace != nil {
            placeRef.setValue(newPlace.toAnyObject())
        } else {
            // add error handling
        }
        
        
        
       /* self.placeInfoView.addButton.removeTarget(self, action: #selector(addPlace(place:)), for: .touchUpInside)
        self.placeInfoView.addButton.setTitle("Place Added!", for: .disabled) */
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView (_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
