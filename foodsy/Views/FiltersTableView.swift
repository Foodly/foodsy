//
//  FiltersTableView.swift
//  foodsy
//
//  Created by hsherchan on 10/15/17.
//  Copyright © 2017 Foodly. All rights reserved.
//

import UIKit

class FiltersTableView: UITableView {
    
    enum SectionId : Int {
        case DIET = 0
        case INTOLERANCES = 1
        case TYPE = 2
        case CUISINE = 3
    }
    
    var dietSelectState = 0
    var typeSelectState = 0
    var intolerancesSwitchStates = [Int: Bool]()
    var cuisineSwitchStates = [Int: Bool]()
    
    
    var expandedSections: [Int:Bool] = [SectionId.DIET.rawValue: false, SectionId.INTOLERANCES.rawValue: false, SectionId.TYPE.rawValue: false, SectionId.CUISINE.rawValue: false]
    let collapsedSwitchCellsSize = 4
    let collapsedSelectCellsSize = 1
    let filterSections: [String] = [DIET_SECTION_TITLE, INTOLERANCES_SECTION_TITLE, TYPE_SECTION_TITLE, CUISINE_SECTION_TITLE]
    let filterSectionData: [Int:[String]] = [SectionId.DIET.rawValue: DIET_FILTER_OPTIONS, SectionId.INTOLERANCES.rawValue: INTOLERANCES_FILTER_OPTIONS, SectionId.TYPE.rawValue: TYPE_FILTER_OPTIONS, SectionId.CUISINE.rawValue: CUISINE_FILTER_OPTIONS]
    
    override func awakeFromNib() {
        self.estimatedRowHeight = 100
        self.rowHeight = UITableViewAutomaticDimension
        
        let filterSwitchCellNib = UINib(nibName: "FiltersSwitchCell", bundle: nil)
        let filterSelectCellNib = UINib(nibName: "FiltersSelectCell", bundle: nil)
        let filterCollapsedCellNib = UINib(nibName: "FiltersCollapsedCell", bundle: nil)
        self.register(filterSwitchCellNib, forCellReuseIdentifier: "FiltersSwitchCell")
        self.register(filterSelectCellNib, forCellReuseIdentifier: "FiltersSelectCell")
        self.register(filterCollapsedCellNib, forCellReuseIdentifier: "FiltersCollapsedCell")
    }
    

    func sectionTapped(section: Int) {
        let updatedSection = !self.expandedSections[section]!
        self.expandedSections[section] = updatedSection
        self.reloadSections([section], with: UITableViewRowAnimation.automatic)
    }
    
    func getSwitchState(section: Int, row:Int) -> Bool {
        var state:Bool = false
        if section == SectionId.INTOLERANCES.rawValue {
            state = self.intolerancesSwitchStates[row] ?? false
        }else if section == SectionId.CUISINE.rawValue{
            state = self.cuisineSwitchStates[row] ?? false
        }
        return state
    }
    
    func setSwitchState(section: Int, row:Int, value:Bool) {
        if section == SectionId.INTOLERANCES.rawValue {
            self.intolerancesSwitchStates[row] = value
        } else if section == SectionId.CUISINE.rawValue {
            self.cuisineSwitchStates[row] = value
        }
    }
}
