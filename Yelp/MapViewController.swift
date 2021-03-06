//
//  MapViewController.swift
//  Yelp
//
//  Created by Soumya on 9/27/15.
//  Copyright © 2015 Soumya. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: SearchViewController, MKMapViewDelegate {
    weak var delegate: BusinessesViewController!
    @IBOutlet weak var mapView: MKMapView!
    var businessByAnnotation = [NSValue : Business]()
    var firstAnnotation : MKPointAnnotation?
    
    @IBOutlet weak var listViewBarButtomItem: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        super.showMapOrListBarButton = listViewBarButtomItem
    }
    
    override func showNewDataToUser() {
        mapView.setRegion(MKCoordinateRegionMake(yelpResponse.mapRegionCenter, yelpResponse.coordinateSpan
            ), animated: false)
        createAnnotations()
    }
    
    func createAnnotations() {
        let existingAnnotations = mapView.annotations
        mapView.removeAnnotations(existingAnnotations)
        businessByAnnotation = [NSValue : Business]()
        firstAnnotation = nil

        for business in yelpResponse.businesses {
            if let center = business.center {
                let annotation = MKPointAnnotation()
                annotation.coordinate = CLLocationCoordinate2DMake(center.latitude, center.longitude)
                annotation.title = business.name
                annotation.subtitle = business.categories
                
                businessByAnnotation[NSValue(nonretainedObject: annotation)] = business
                
                mapView.addAnnotation(annotation)
                if (firstAnnotation == nil) {
                    firstAnnotation = annotation
                }
            }
        }
        
        if (firstAnnotation != nil) {
            mapView.selectAnnotation(firstAnnotation!, animated: false)
        }
    }
    
    @IBAction func onListBarButtonTap(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
