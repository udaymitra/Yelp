//
//  Filter.swift
//  Yelp
//
//  Created by Soumya on 9/26/15.
//  Copyright © 2015 Soumya. All rights reserved.
//

import Foundation

class Filter {
    var sectionKey : String
    var sectionDisplayHeader : String
    var filterOptions : [[String:String]]
    var filterType : FilterType
    var switchStates = [Int:Bool]()
    
    init(sectionKey : String, sectionDisplayHeader : String, filterOptions : [[String:String]], filterType: FilterType) {
        self.sectionKey = sectionKey
        self.sectionDisplayHeader = sectionDisplayHeader
        self.filterOptions = filterOptions
        self.filterType = filterType
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

enum FilterType {
    case Toggle, SingleSelect, MultiSelect
}
