//
//  YelpResponse.swift
//  Yelp
//
//  Created by Soumya on 9/27/15.
//  Copyright © 2015 Soumya. All rights reserved.
//

import Foundation
import MapKit

class YelpResponse {
    var businesses: [Business]
    let mapRegionCenter: CLLocationCoordinate2D
    let coordinateSpan: MKCoordinateSpan
    
    init(businesses: [Business], mapRegionCenter: CLLocationCoordinate2D, coordinateSpan: MKCoordinateSpan) {
        self.businesses = businesses
        self.mapRegionCenter = mapRegionCenter
        self.coordinateSpan = coordinateSpan
    }
    
    convenience init(businesses: [Business], centerLat: Double, centerLng: Double, spanLatitudeDelta: Double, spanLongitudeDelta: Double) {
        let mapRegionCenter = CLLocationCoordinate2DMake(centerLat, centerLng)
        let span = MKCoordinateSpanMake(spanLatitudeDelta, spanLongitudeDelta)
        self.init(businesses: businesses, mapRegionCenter: mapRegionCenter, coordinateSpan: span)
    }
}
