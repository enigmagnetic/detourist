//
//  SearchViewController.swift
//  Detourist
//
//  Created by Lauren Cardella on 1/6/18.
//  Copyright © 2018 Lauren Cardella. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class SearchViewController: UIViewController, GMSMapViewDelegate {
    @IBOutlet fileprivate weak var mapView: GMSMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let camera = GMSCameraPosition.camera(withLatitude: 37.36, longitude: -122.0, zoom: 6.0)
        mapView.camera = camera
    }
}
