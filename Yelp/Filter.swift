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
    var sectionDisplayHeader : String?
    var filterOptions : [[String:String]]
    var filterType : FilterType
    var switchStates = [Int:Bool]()
    var isUserInteractingWithFilter : Bool
    
    init(sectionKey : String, sectionDisplayHeader : String?, filterOptions : [[String:String]], filterType: FilterType) {
        self.sectionKey = sectionKey
        self.sectionDisplayHeader = sectionDisplayHeader
        self.filterOptions = filterOptions
        self.filterType = filterType
        self.isUserInteractingWithFilter = false
        
        if (filterType == .SingleSelect) {
            // mark the first choice as selected by default
            switchStates[0] = true
        }
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
    
    // this returns the first selected option in case of Single Select filter
    // if filter is not of type Single select, returns nil
    func getSelectedOption() -> Int? {
        if (filterType == .SingleSelect) {
            for (row, isSwitchOn) in switchStates {
                if (isSwitchOn) {
                    return row
                }
            }
        }
        return nil
    }
    
    func markOptionAsTapped(tappedRow: Int) {
        if (filterType == .SingleSelect) {
            for row in 0..<filterOptions.count {
                if (row == tappedRow)
                {
                    switchStates[row] = true
                } else {
                    switchStates[row] = false
                }
            }
        } else {
            let currentSwitchState = switchStates[tappedRow] ?? false
            switchStates[tappedRow] = !currentSwitchState
        }
    }
}

enum FilterType {
    case Toggle, SingleSelect, MultiSelect
}
