//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit

class BusinessesViewController: SearchViewController, UITableViewDataSource, UITableViewDelegate, BrowseMoreCellDelegate {

    @IBOutlet var showMapBarButton: UIBarButtonItem!
    @IBOutlet var businessesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        super.showMapOrListBarButton = showMapBarButton
        
        // set delegates
        businessesTableView.delegate = self
        businessesTableView.dataSource = self
        
        // tableView set up
        businessesTableView.rowHeight = UITableViewAutomaticDimension
        businessesTableView.estimatedRowHeight = 100
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.yelpResponse != nil)
            ? (self.yelpResponse.businesses.count + 1) // additional one for Browse more cell
            : 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if (indexPath.row == yelpResponse.businesses.count) {
            let browseMoreCell = businessesTableView.dequeueReusableCellWithIdentifier("BrowseMoreCell", forIndexPath: indexPath) as! BrowseMoreCell
            browseMoreCell.delegate = self
            return browseMoreCell
        } else {
            let businessCell = businessesTableView.dequeueReusableCellWithIdentifier("BusinessCell", forIndexPath: indexPath) as! BusinessCell
            businessCell.business = self.yelpResponse.businesses[indexPath.row]
            return businessCell
        }
    }
    
    func browseMoreCellIsTapped(browseMoreCell: BrowseMoreCell) {
        performSearch([String : AnyObject](), offset: yelpResponse.businesses.count + 1, limit: LAZY_FETCH_BATCH_SIZE)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        if segue.destinationViewController is UINavigationController {
            let navigationController = segue.destinationViewController as! UINavigationController
            let nextViewController = navigationController.viewControllers[0]
            if (nextViewController is MapViewController) {
                let mapViewController = nextViewController as! MapViewController
                mapViewController.delegate = self
                mapViewController.yelpResponse = self.yelpResponse
                mapViewController.locationManager = self.locationManager
            }
        }
    }

    override func showNewDataToUser() {
        self.businessesTableView.reloadData()
    }
}
