//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit

class BusinessesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, FiltersViewControllerDelegate, UISearchBarDelegate {

    var yelpResponse: YelpResponse!
    var searchBar:UISearchBar!
    var customSearchCancelBarButton: UIBarButtonItem!
    var lastSearchString:String!
    
    let defaultLocation = CLLocationCoordinate2D(latitude: 37.785771, longitude: -122.406165)
    
    @IBOutlet weak var businessesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        businessesTableView.delegate = self
        businessesTableView.dataSource = self
        
        // tableView set up
        businessesTableView.rowHeight = UITableViewAutomaticDimension
        businessesTableView.estimatedRowHeight = 100
        
        // populate some initial results
        getBusinessResultsForSearchStringWithoutFilters(lastSearchString)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.yelpResponse != nil) ? self.yelpResponse.businesses.count : 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let businessCell = businessesTableView.dequeueReusableCellWithIdentifier("BusinessCell", forIndexPath: indexPath) as! BusinessCell
        businessCell.business = self.yelpResponse.businesses[indexPath.row]
        return businessCell        
    }
    
    func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filters: [String : AnyObject]) {
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

        Business.searchWithTerm(lastSearchString, sort: yelpSortMode, categories: categories, deals: showDeals, location: defaultLocation, radius: distance) { (yelpResponse:YelpResponse?, error: NSError!) -> Void in
            self.yelpResponse = yelpResponse!
            self.businessesTableView.reloadData()
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        if segue.destinationViewController is UINavigationController {
            let navigationController = segue.destinationViewController as! UINavigationController
            let nextViewController = navigationController.viewControllers[0]
            if (nextViewController is FiltersViewController) {
                let filtersViewController = nextViewController as! FiltersViewController
                filtersViewController.delegate = self
            }
            if (nextViewController is MapViewController) {
                let mapViewController = nextViewController as! MapViewController
                mapViewController.delegate = self
                mapViewController.yelpResponse = self.yelpResponse
            }
        }
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        navigationItem.rightBarButtonItem = customSearchCancelBarButton
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        lastSearchString = searchText
        getBusinessResultsForSearchStringWithoutFilters(searchText)
    }
    
    func customSearchBarCancelButtonClicked() {
        searchBar.resignFirstResponder()
        navigationItem.rightBarButtonItem = nil
        searchBar.text = ""
        searchBar.placeholder = lastSearchString
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        customSearchBarCancelButtonClicked()
    }
    
    func getBusinessResultsForSearchStringWithoutFilters(searchString: String) {
        Business.searchWithTerm(searchString, sort: nil, categories: nil, deals: false, location: defaultLocation, radius: nil) { (yelpResponse: YelpResponse?, error: NSError!) -> Void in
            self.yelpResponse = yelpResponse!
            // reload table view
            self.businessesTableView.reloadData()
        }
    }
}
