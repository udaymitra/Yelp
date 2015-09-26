//
//  FiltersViewController.swift
//  Yelp
//
//  Created by Soumya on 9/24/15.
//  Copyright © 2015 Soumya. All rights reserved.
//

import UIKit

@objc protocol FiltersViewControllerDelegate {
    optional func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filters: [String:AnyObject])
}

class FiltersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SwitchCellDelegate {
    @IBOutlet weak var tableView: UITableView!
    var filterSections : [Filter]!
    
    weak var delegate: FiltersViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        filterSections = YelpFilters().filterSections
        
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 20
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onCancelButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func onSearchButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
        var selectedFilters = [String : AnyObject]()
        for filterSection in filterSections {
                selectedFilters[filterSection.sectionKey] = filterSection.getSelectedFilterOptions()
        }
        
        delegate?.filtersViewController?(self, didUpdateFilters: selectedFilters)

    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SwitchCell", forIndexPath: indexPath) as! SwitchCell
        let section = indexPath.section
        let row = indexPath.row
        let filter = filterSections[section]
        cell.switchLabel.text = filter.filterOptions[row]["name"]
        cell.delegate = self
        
        // initial state
        var imageToShow : String?
        switch(filter.filterType) {
        case .Toggle:
            let isToggleOn = !filter.getSelectedFilterOptions().isEmpty
            imageToShow = (isToggleOn) ? "Check" : "Uncheck"
            break
        case .SingleSelect:
            if (filter.isUserInteractingWithFilter) {
                let isSwitchOn = filter.switchStates[row] ?? false
                imageToShow = (isSwitchOn) ? "Check" : "Uncheck"
            } else {
                if let selectedOption = filter.getSelectedOption() {
                    cell.switchLabel.text = filter.filterOptions[selectedOption]["name"]
                }
                imageToShow = "Dropdown"
            }
            break
        case .MultiSelect:
            let isSwitchOn = filter.switchStates[row] ?? false
            imageToShow = (isSwitchOn) ? "Check" : "Uncheck"
            break
        }
        
        cell.switchImageView.image = UIImage(named: imageToShow!)
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let filter = filterSections[section]
        switch(filter.filterType) {
        case .Toggle, .SingleSelect:
            return filter.isUserInteractingWithFilter
                ? filter.filterOptions.count
                : 1
        case .MultiSelect:
            return filter.filterOptions.count
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return filterSections.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return filterSections[section].sectionDisplayHeader
    }
    
    func switchCellIsTapped(switchCell: SwitchCell) {
        let indexPath = tableView.indexPathForCell(switchCell)!
        let filter = filterSections[indexPath.section]
        let rowPicked = indexPath.row
        if (filter.filterType == .SingleSelect) {
            if (filter.isUserInteractingWithFilter) {
                filter.markOptionAsTapped(rowPicked)
                filter.isUserInteractingWithFilter = false
            } else {
                filter.isUserInteractingWithFilter = true
            }
        } else {
            // change selected state of the toggle/multi select
            filter.markOptionAsTapped(rowPicked)
        }
        
        // TODO: look into reloading just the section
        tableView.reloadData()
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
