//
//  Place.swift
//  Detourist
//
//  Created by Lauren Cardella on 1/21/18.
//  Copyright © 2018 Lauren Cardella. All rights reserved.
//

import Foundation
import Firebase

struct Place {
    
    var key: String
    var placeId: String
    var name: String
    var address: String
    var coordinate: String
    
    init(key: String, name: String, placeId: String, address: String, coordinate: String) {
        self.key = key
        self.name = name
        self.placeId = placeId
        self.address = address
        self.coordinate = coordinate
    }
    
    init(snapshot: DataSnapshot) {
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        name = snapshotValue["name"] as! String
        placeId = snapshotValue["placeId"] as! String
        address = snapshotValue["address"] as! String
        coordinate = snapshotValue["coordinate"] as! String
    }
    
    func toAnyObject() -> [String: String] {
        return [
            "name": name,
            "placeId": placeId,
            "address": address,
            "coordinate": coordinate,
        ]
    }
}
