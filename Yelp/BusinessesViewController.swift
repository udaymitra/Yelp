//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit

class BusinessesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, FiltersViewControllerDelegate {

    var businesses: [Business]!
    
    @IBOutlet weak var businessesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        businessesTableView.delegate = self
        businessesTableView.dataSource = self
        
        businessesTableView.rowHeight = UITableViewAutomaticDimension
        businessesTableView.estimatedRowHeight = 100
        
//        Business.searchWithTerm("Thai", completion: { (businesses: [Business]!, error: NSError!) -> Void in
//            self.businesses = businesses
//            
//            for business in businesses {
//                println(business.name!)
//                println(business.address!)
//            }
//        })
        
        Business.searchWithTerm("Restaurants", sort: .Distance, categories: ["asianfusion", "burgers"], deals: false) { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            // reload table view
            self.businessesTableView.reloadData()
            
            for business in businesses {
                print(business.name!)
                print(business.address!)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (businesses != nil)
            ? businesses!.count
            : 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let businessCell = businessesTableView.dequeueReusableCellWithIdentifier("BusinessCell", forIndexPath: indexPath) as! BusinessCell
        businessCell.business = businesses[indexPath.row]
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

        let location = CLLocationCoordinate2D(latitude: 37.785771, longitude: -122.406165)
        
        Business.searchWithTerm("Restaurants", sort: yelpSortMode, categories: categories, deals: showDeals, location: location, radius: distance) { (businesses:[Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            self.businessesTableView.reloadData()
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let navigationController = segue.destinationViewController as! UINavigationController
        let filtersViewController = navigationController.topViewController as! FiltersViewController
        filtersViewController.delegate = self
    }

}
