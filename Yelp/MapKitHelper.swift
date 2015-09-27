//
//  MapKitHelper.swift
//  Yelp
//
//  Created by Soumya on 9/26/15.
//  Copyright © 2015 Soumya. All rights reserved.
//

import Foundation
import MapKit

// Ended up not using this class
func MapBoundsFromCenterAndDistance(location: CLLocationCoordinate2D, distanceInMeters: Double) -> MapBounds {
    let span = MKCoordinateRegionMakeWithDistance(location, distanceInMeters, distanceInMeters).span
    var northWestCorner = CLLocationCoordinate2D()
    var southEastCorner = CLLocationCoordinate2D()
    
    northWestCorner.latitude = location.latitude + (span.latitudeDelta / 2)
    if (northWestCorner.latitude > 90) {
        northWestCorner.latitude = 90
    }
    northWestCorner.longitude = location.longitude - (span.longitudeDelta / 2)
    if (northWestCorner.longitude < -180) {
        northWestCorner.longitude += 180
    }
    
    southEastCorner.latitude = location.latitude - (span.latitudeDelta / 2)
    if (southEastCorner.latitude < -90) {
        southEastCorner.latitude = -90
    }
    southEastCorner.longitude = location.longitude + (span.longitudeDelta / 2)
    if (southEastCorner.longitude > 180) {
        southEastCorner.longitude -= 180
    }
    
    return MapBounds(northWest: northWestCorner, southEast: southEastCorner)
}

class MapBounds {
    var northWest : CLLocationCoordinate2D
    var southEast : CLLocationCoordinate2D
    
    init(northWest : CLLocationCoordinate2D, southEast : CLLocationCoordinate2D) {
        self.northWest = northWest
        self.southEast = southEast
    }
}
