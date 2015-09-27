//
//  MapViewController.swift
//  Yelp
//
//  Created by Soumya on 9/27/15.
//  Copyright © 2015 Soumya. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    var delegate: BusinessesViewController!
    @IBOutlet weak var mapView: MKMapView!
    
    var businesses: [Business]!
    var userLocation: CLLocationCoordinate2D!
    var businessByAnnotation = [NSValue : Business]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        mapView.setRegion(MKCoordinateRegionMake(userLocation, MKCoordinateSpanMake(0.1, 0.1)), animated: false)
        createAnnotations()
    }
    
    func createAnnotations() {
        let existingAnnotations = mapView.annotations
        mapView.removeAnnotations(existingAnnotations)
        businessByAnnotation = [NSValue : Business]()
        
        for business in businesses {
            if let center = business.center {
                let annotation = MKPointAnnotation()
                annotation.coordinate = CLLocationCoordinate2DMake(center.latitude, center.longitude)
                annotation.title = business.name
                annotation.subtitle = business.categories
                
                businessByAnnotation[NSValue(nonretainedObject: annotation)] = business
                
                mapView.addAnnotation(annotation)
            }
        }
    }
    
    @IBAction func onListBarButtonTap(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    
//    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
//        let temp =  businessByAnnotation[NSValue(nonretainedObject: annotation)]!
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
