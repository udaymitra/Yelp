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

class MapViewController: UIViewController, MKMapViewDelegate {
    var delegate: BusinessesViewController!
    @IBOutlet weak var mapView: MKMapView!
    weak var locationManager : CLLocationManager!
    
    var yelpResponse: YelpResponse!
    var businessByAnnotation = [NSValue : Business]()
    var firstAnnotation : MKPointAnnotation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
