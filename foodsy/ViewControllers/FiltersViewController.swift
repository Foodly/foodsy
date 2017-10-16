//
//  FiltersViewController.swift
//  foodsy
//
//  Created by hsherchan on 10/14/17.
//  Copyright © 2017 Foodly. All rights reserved.
//

import UIKit

@objc protocol FiltersViewControllerDelegate {
    @objc optional func filtersViewController(filtersViewController: FiltersViewController, dietChoice: String?, intoleranceChoices: [String]?, typeChoice: String?, cuisineChoices:[String]?)
}

class FiltersViewController: UIViewController {
    
    @IBOutlet weak var tableView: FiltersTableView!
    weak var delegate: FiltersViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onCancelButton(_ sender: Any) {
        dismiss(animated: true, completion:nil)
    }
    
    @IBAction func onSearchButton(_ sender: Any) {
        dismiss(animated: true, completion:nil)
        
        var dietChoice: String!
            
        if tableView.dietSelectState > 0 {
            dietChoice = DIET[tableView.dietSelectState]
        } else {
            dietChoice = ""
        }
    
        var intoleranceChoices = [String]()
        for (row,isSelected) in tableView.intolerancesSwitchStates{
            if isSelected {
                intoleranceChoices.append(INTOLERANCES[row])
            }
        }
        
        var typeChoice: String!
        
        if tableView.typeSelectState > 0 {
            typeChoice = TYPE[tableView.typeSelectState]
        } else {
            typeChoice = ""
        }

        var cuisineChoices = [String]()
        for (row,isSelected) in tableView.cuisineSwitchStates{
            if isSelected {
                cuisineChoices.append(CUISINE[row])
            }
        }
        print (dietChoice)
        print (intoleranceChoices)
        print (typeChoice)
        print (cuisineChoices)
        delegate?.filtersViewController!(filtersViewController: self, dietChoice: dietChoice, intoleranceChoices: intoleranceChoices, typeChoice: typeChoice, cuisineChoices: cuisineChoices)
    }
}

extension FiltersViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tableView = tableView as! FiltersTableView
        if indexPath.section == FiltersTableView.SectionId.DIET.rawValue || indexPath.section == FiltersTableView.SectionId.TYPE.rawValue {
            if tableView.expandedSections[indexPath.section]! {
                let cell = tableView.cellForRow(at: indexPath) as! FiltersSelectCell
                cell.newOptionSelected()
            } else {
                tableView.sectionTapped(section:indexPath.section)
            }
            
        } else if indexPath.section == FiltersTableView.SectionId.CUISINE.rawValue || indexPath.section == FiltersTableView.SectionId.INTOLERANCES.rawValue {
            if (!tableView.expandedSections[indexPath.section]!) && (indexPath.row == tableView.collapsedSwitchCellsSize - 1) {
                tableView.sectionTapped(section:indexPath.section)
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        let tableView = tableView as! FiltersTableView
        return tableView.filterSectionData.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let tableView = tableView as! FiltersTableView
        return tableView.filterSections[section]
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let tableView = tableView as! FiltersTableView
        if tableView.expandedSections[section]! {
            return (tableView.filterSectionData[section]?.count)!
        } else {
            if (section == FiltersTableView.SectionId.CUISINE.rawValue) || (section == FiltersTableView.SectionId.INTOLERANCES.rawValue){
                return tableView.collapsedSwitchCellsSize
            } else {
                return tableView.collapsedSelectCellsSize
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableView = tableView as! FiltersTableView
        switch (indexPath.section){
        case FiltersTableView.SectionId.DIET.rawValue, FiltersTableView.SectionId.TYPE.rawValue:
            if tableView.expandedSections[indexPath.section]! {
                let cell = tableView.dequeueReusableCell(withIdentifier: "FiltersSelectCell", for: indexPath) as! FiltersSelectCell
                cell.selectLabel.text = tableView.filterSectionData[indexPath.section]?[indexPath.row]
                cell.delegate = self
                
                var selectState: Int?
                
                if indexPath.section == FiltersTableView.SectionId.DIET.rawValue {
                    selectState = tableView.dietSelectState
                } else {
                    selectState = tableView.typeSelectState
                }
                
                
                if selectState == indexPath.row {
                    let image = UIImage(named: "check") as UIImage!
                    cell.selectBtn.setBackgroundImage(image, for: UIControlState.normal)
                } else {
                    cell.selectBtn.setBackgroundImage(nil, for: UIControlState.normal)
                    cell.selectBtn.backgroundColor = .gray
                }
                
                return cell
            } else {
                let cell =  tableView.dequeueReusableCell(withIdentifier: "FiltersCollapsedCell", for: indexPath) as! FiltersCollapsedCell
                var selectState: Int!
                
                if indexPath.section == FiltersTableView.SectionId.DIET.rawValue {
                    selectState = tableView.dietSelectState
                } else {
                    selectState = tableView.typeSelectState
                }
                cell.collapsedLabel.text = tableView.filterSectionData[indexPath.section]?[selectState]
                return cell
            }
        case FiltersTableView.SectionId.INTOLERANCES.rawValue, FiltersTableView.SectionId.CUISINE.rawValue:
            if !tableView.expandedSections[indexPath.section]! {
                if (indexPath.row < tableView.collapsedSwitchCellsSize - 1) {
                 let cell = tableView.dequeueReusableCell(withIdentifier: "FiltersSwitchCell", for: indexPath) as! FiltersSwitchCell
                cell.switchLabel.text = tableView.filterSectionData[indexPath.section]?[indexPath.row]
                    
                if indexPath.section == FiltersTableView.SectionId.INTOLERANCES.rawValue {
                    cell.onSwitch.isOn = tableView.intolerancesSwitchStates[indexPath.row] ?? false
                }else{
                    cell.onSwitch.isOn = tableView.cuisineSwitchStates[indexPath.row] ?? false
                }
                cell.delegate = self
                 return cell
                } else {
                    let cell =  tableView.dequeueReusableCell(withIdentifier: "FiltersCollapsedCell", for: indexPath) as! FiltersCollapsedCell
                    cell.collapsedLabel.text = "See More"
                    return cell
                }
            } else {
                let cell =  tableView.dequeueReusableCell(withIdentifier: "FiltersSwitchCell", for: indexPath) as! FiltersSwitchCell
                cell.switchLabel.text = tableView.filterSectionData[indexPath.section]?[indexPath.row]
                if indexPath.section == FiltersTableView.SectionId.INTOLERANCES.rawValue {
                    cell.onSwitch.isOn = tableView.intolerancesSwitchStates[indexPath.row] ?? false
                }else{
                    cell.onSwitch.isOn = tableView.cuisineSwitchStates[indexPath.row] ?? false
                }
                cell.delegate = self
                return cell
            }
            
        default:
            break
        }
        
        return UITableViewCell()
    }
    
}

extension FiltersViewController: SwitchCellDelegate, SelectCellDelegate {
    func switchCell(switchCell: FiltersSwitchCell, didChangeValue value: Bool) {
       let indexPath = tableView.indexPath(for: switchCell)!
        if indexPath.section == FiltersTableView.SectionId.INTOLERANCES.rawValue {
            tableView.intolerancesSwitchStates[indexPath.row] = value
        } else if indexPath.section == FiltersTableView.SectionId.CUISINE.rawValue {
            tableView.cuisineSwitchStates[indexPath.row] = value
        }
    }
    
    func selectCell(selectCell: FiltersSelectCell, isSelected value: Bool) {
        let indexPath = tableView.indexPath(for: selectCell)!
        if indexPath.section == FiltersTableView.SectionId.TYPE.rawValue {
            tableView.typeSelectState = indexPath.row
        } else if indexPath.section == FiltersTableView.SectionId.DIET.rawValue {
            tableView.dietSelectState = indexPath.row
        }
        tableView.sectionTapped(section: indexPath.section)
    }
}
