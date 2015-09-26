//
//  Filter.swift
//  Yelp
//
//  Created by Soumya on 9/26/15.
//  Copyright © 2015 Timothy Lee. All rights reserved.
//

import Foundation

class Filter {
    var sectionKey : String
    var sectionDisplayHeader : String
    var filterOptions : [[String:String]]
    var switchStates = [Int:Bool]()
    
    init(sectionKey : String, sectionDisplayHeader : String, filterOptions : [[String:String]]) {
        self.sectionKey = sectionKey
        self.sectionDisplayHeader = sectionDisplayHeader
        self.filterOptions = filterOptions
    }
    
    func getSelectedFilterOptions() -> [String] {
        var selectedCategories = [String]()
        for (row, isSwitchOn) in switchStates {
            if (isSwitchOn) {
                selectedCategories.append(filterOptions[row]["code"]!)
            }
        }
        return selectedCategories
    }
}
