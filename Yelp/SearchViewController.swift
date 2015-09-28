//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit

// number of businesses to fetch at a time from server

class SearchViewController: UIViewController, FiltersViewControllerDelegate, UISearchBarDelegate, CLLocationManagerDelegate {
    var yelpResponse: YelpResponse!
    var searchBar:UISearchBar!
    var customSearchCancelBarButton: UIBarButtonItem!
    var lastSearchString:String!

    var showMapOrListBarButton: UIBarButtonItem!
    var locationManager : CLLocationManager!
    
    let LAZY_FETCH_BATCH_SIZE = 20

    // set default location
    var lastLocation = CLLocationCoordinate2D(latitude: 37.785771, longitude: -122.406165)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // initialise core location manager
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.distanceFilter = 200
        locationManager.requestWhenInUseAuthorization()
        
        // add search bar to navigation bar
        searchBar = UISearchBar()
        searchBar.sizeToFit()
        lastSearchString = "Restaurant"
        searchBar.placeholder = lastSearchString
        navigationItem.titleView = searchBar
        
        // create custom search cancel button
        customSearchCancelBarButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: "customSearchBarCancelButtonClicked")
        customSearchCancelBarButton.tintColor = UIColor.whiteColor()
        
        // set status bar content color to white
        UIApplication.sharedApplication().statusBarStyle = .LightContent

        // set delegates
        searchBar.delegate = self

        // populate some initial results
        performSearch([String : AnyObject](), offset: 0, limit: LAZY_FETCH_BATCH_SIZE)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    
    func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filters: [String : AnyObject]) {
        performSearch(filters, offset: 0, limit: LAZY_FETCH_BATCH_SIZE)
    }
    
    func performSearch(filters: [String : AnyObject], offset: Int, limit: Int) {
        let categories = filters["categories"] as? [String]
        
        var yelpSortMode : YelpSortMode?
        if let sortmode = filters["sortmode"] as? [String] {
            if (!sortmode.isEmpty) {
                yelpSortMode = YelpSortMode(rawValue: Int(sortmode[0])!)
            }
        }
        
        let deals = filters["deals"] as? [String]
        let showDeals = deals != nil && !deals!.isEmpty
        
        var distance : Double?
        if let distanceStrings = filters["distance"] as? [String] {
            if (!distanceStrings.isEmpty) {
                distance = Double(distanceStrings[0])
            }
        }
        
        Business.searchWithTerm(lastSearchString, sort: yelpSortMode, categories: categories, deals: showDeals, location: lastLocation, radius: distance, offset: offset, limit: limit) { (yelpResponse:YelpResponse?, error: NSError!) -> Void in
            if (offset == 0) {
                self.yelpResponse = yelpResponse
            } else {
                // paging
                self.yelpResponse.businesses += yelpResponse!.businesses
            }
            self.showNewDataToUser()
        }
    }

    // need to override this function in sub classes
    // TODO: This is ugly. Figure out how to define abstract methods in swift
    func showNewDataToUser() {}
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        if segue.destinationViewController is UINavigationController {
            let navigationController = segue.destinationViewController as! UINavigationController
            let nextViewController = navigationController.viewControllers[0]
            if (nextViewController is FiltersViewController) {
                let filtersViewController = nextViewController as! FiltersViewController
                filtersViewController.delegate = self
            }
        }
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        navigationItem.rightBarButtonItem = customSearchCancelBarButton
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        lastSearchString = searchText
        performSearch([String : AnyObject](), offset: 0, limit: LAZY_FETCH_BATCH_SIZE)
    }
    
    func customSearchBarCancelButtonClicked() {
        searchBar.resignFirstResponder()
        searchBar.text = ""
        searchBar.placeholder = lastSearchString

        navigationItem.rightBarButtonItem = showMapOrListBarButton
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        customSearchBarCancelButtonClicked()
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.AuthorizedWhenInUse {
            manager.startUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.first
        lastLocation = location!.coordinate
    }
}
