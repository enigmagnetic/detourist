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
    
    var mapView: GMSMapView?
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
        
        let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: 16.0)
        self.mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        self.mapView?.delegate = self
        
        self.mapView?.isMyLocationEnabled = true
        self.mapView?.settings.myLocationButton = true
        showMarker(position: camera.target)
        self.view = self.mapView
    }
    
    func showMarker(position: CLLocationCoordinate2D) {
        let marker = GMSMarker()
        marker.position = position
        marker.map = mapView
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.stopUpdatingLocation()
    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController, didAutocompleteWith place: GMSPlace) {
        searchController?.isActive = false
        // Do something with the selected place.
        
        self.mapView?.animate(toLocation: place.coordinate)

        showMarker(position: place.coordinate)
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

extension SearchViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        print("didTapInfoWindowOf")
    }
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        let view = UIView(frame: CGRect.init(x: 0, y: 0, width: 200, height: 100))
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 6
        
        let placeName = UILabel(frame: CGRect.init(x: 8, y: 8, width: view.frame.size.width - 16, height: 15))
        placeName.text = marker.title
        view.addSubview(placeName)
        
        let addButton = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 50))
        addButton.setTitle("Add to List", for: .normal)
        addButton.addTarget(self, action: #selector(addToList), for: .touchUpInside)
        view.addSubview(addButton)
        
        return view
    }
    
    @objc func addToList(sender: UIButton!) {
        print("Button tapped")
    }}

extension SearchViewController: UITableViewDelegate {
    func tableView (_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
