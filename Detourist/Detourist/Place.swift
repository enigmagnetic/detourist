//
//  Place.swift
//  Detourist
//
//  Created by Lauren Cardella on 1/21/18.
//  Copyright © 2018 Lauren Cardella. All rights reserved.
//

import Foundation
import Firebase
import CoreLocation

struct Place {
    
    var key: String
    var placeId: String
    var name: String
    var address: String
    var coordinate: [String: Double]
    var ref: DatabaseReference?
    var visited: Bool
    
    init(key: String = "", name: String, placeId: String, address: String, coordinate: [String: Double], visited: Bool) {
        self.key = key
        self.name = name
        self.placeId = placeId
        self.address = address
        self.coordinate = coordinate
        self.visited = false
        self.ref = nil
    }
    
    init(snapshot: DataSnapshot) {
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        name = snapshotValue["name"] as! String
        placeId = snapshotValue["placeId"] as! String
        address = snapshotValue["address"] as! String
        coordinate = snapshotValue["coordinate"] as! [String: Double]
        visited = snapshotValue["visited"] as! Bool
        ref = snapshot.ref
    }
    
  func toAnyObject() -> Any {
        return [
            "name": name,
            "placeId": placeId,
            "address": address,
            "coordinate": coordinate,
            "visited": visited
        ]
    }
}
