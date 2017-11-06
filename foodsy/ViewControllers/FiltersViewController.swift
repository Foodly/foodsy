//
//  FiltersViewController.swift
//  foodsy
//
//  Created by hsherchan on 10/14/17.
//  Copyright © 2017 Foodly. All rights reserved.
//

import UIKit

class FiltersViewController: UIViewController {
    
    @IBOutlet weak var applyFilters: UIButton!
    @IBOutlet weak var tableView: FiltersTableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        applyFilters.isHidden = true
        
        tableView.dietSelectState = Filters.sharedInstance.getDietState()
        tableView.typeSelectState = Filters.sharedInstance.getTypeSelectState()
        tableView.intolerancesSwitchStates = Filters.sharedInstance.getIntolerancesStates()
        tableView.cuisineSwitchStates = Filters.sharedInstance.getCuisineStates()
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onCancelButton(_ sender: Any) {
        dismiss(animated: true, completion:nil)
    }
    
    @IBAction func onResetButton(_ sender: Any) {
        applyFilters.isHidden = true
        tableView.dietSelectState = 0
        tableView.typeSelectState = 0
        tableView.intolerancesSwitchStates = [Int:Bool]()
        tableView.cuisineSwitchStates = [Int:Bool]()
        Filters.sharedInstance.setFilters(dietState: tableView.dietSelectState, typeState: tableView.typeSelectState, intolerancesStates: tableView.intolerancesSwitchStates, cuisineStates: tableView.cuisineSwitchStates)
        tableView.reloadData()
    }
    
    @IBAction func onApplyFilters(_ sender: Any) {
        Filters.sharedInstance.setFilters(dietState: tableView.dietSelectState, typeState: tableView.typeSelectState, intolerancesStates: tableView.intolerancesSwitchStates, cuisineStates: tableView.cuisineSwitchStates)
        applyFilters.isHidden = true
    }
    
    func checkForFiltersChange() {
        if Filters.sharedInstance.areAllDifferent(dietState: tableView.dietSelectState, typeState: tableView.typeSelectState, intolerancesStates: tableView.intolerancesSwitchStates, cuisineStates: tableView.cuisineSwitchStates) {
            applyFilters.isHidden = false
        } else {
            applyFilters.isHidden = true
        }
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
            } else {
                let value = tableView.getSwitchState(section: indexPath.section, row: indexPath.row)
                tableView.setSwitchState(section: indexPath.section, row: indexPath.row, value: !value)
                checkForFiltersChange()
                tableView.reloadData()
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        let tableView = tableView as! FiltersTableView
        return tableView.filterSectionData.count
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
                    let image = UIImage(named: "record") as UIImage!
                    cell.selectBtn.setBackgroundImage(image, for: UIControlState.normal)
                } else {
                    let image = UIImage(named: "empty-record") as UIImage!
                    cell.selectBtn.setBackgroundImage(image, for: UIControlState.normal)
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
                cell.collapsedLabel.font = UIFont(name: "Nunito-Bold", size: 16)
                cell.collapsedLabel.text = tableView.filterSectionData[indexPath.section]?[selectState]
                return cell
            }
        case FiltersTableView.SectionId.INTOLERANCES.rawValue, FiltersTableView.SectionId.CUISINE.rawValue:
            if !tableView.expandedSections[indexPath.section]! {
                if (indexPath.row < tableView.collapsedSwitchCellsSize - 1) {
                 let cell = tableView.dequeueReusableCell(withIdentifier: "FiltersSwitchCell", for: indexPath) as! FiltersSwitchCell
                cell.switchLabel.text = tableView.filterSectionData[indexPath.section]?[indexPath.row]
                
                let value = tableView.getSwitchState(section: indexPath.section, row: indexPath.row)
                
                    if value == false {
                        cell.checkImageView.isHidden = true
                    } else {
                        cell.checkImageView.isHidden = false
                    }
                 return cell
                } else {
                    let cell =  tableView.dequeueReusableCell(withIdentifier: "FiltersCollapsedCell", for: indexPath) as! FiltersCollapsedCell
                    cell.collapsedLabel.font = UIFont(name: "Nunito-Light", size: 9)
                    
                    if indexPath.section == FiltersTableView.SectionId.INTOLERANCES.rawValue {
                        cell.collapsedLabel.text = "SEE ALL ALLERGY FILTERS"
                    } else {
                        cell.collapsedLabel.text = "SEE ALL CUISINE FILTERS"
                    }
                    
                    return cell
                }
            } else {
                let cell =  tableView.dequeueReusableCell(withIdentifier: "FiltersSwitchCell", for: indexPath) as! FiltersSwitchCell
                cell.switchLabel.text = tableView.filterSectionData[indexPath.section]?[indexPath.row]
                let value = tableView.getSwitchState(section: indexPath.section, row: indexPath.row)
                
                if value == false {
                    cell.checkImageView.isHidden = true
                } else {
                    cell.checkImageView.isHidden = false
                }
                return cell
            }
        default:
            break
        }
        
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let tableView = tableView as! FiltersTableView
        let headerView = UIView()
        let bottomSeparatorView = UIView()
        bottomSeparatorView.backgroundColor = Utils.getSecondaryColor()
        bottomSeparatorView.frame =  CGRect(x:0, y:headerView.bounds.height-1, width: UIScreen.main.bounds.width, height: 1)
        headerView.backgroundColor = UIColor.white
        let label = UILabel()
        label.text = tableView.filterSections[section]
        label.addTextSpacing(spacing: 1.39)
        label.frame = CGRect(x:5, y: 5, width: 100, height: 35)
        headerView.addSubview(label)
        headerView.addSubview(bottomSeparatorView)
        label.textColor = Utils.getTextColor()
        label.font = UIFont(name: "Nunito-SemiBold", size: 13)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        bottomSeparatorView.translatesAutoresizingMaskIntoConstraints = false
        headerView.addConstraint(NSLayoutConstraint(item: label, attribute: .leading, relatedBy: .equal, toItem: headerView, attribute: .leading, multiplier: 1, constant: 16))
        headerView.addConstraint(NSLayoutConstraint(item: label, attribute: .centerY, relatedBy: .equal, toItem: headerView, attribute: .centerY, multiplier: 1, constant: 0))
        
        headerView.addConstraint(NSLayoutConstraint(item: bottomSeparatorView, attribute: .leading, relatedBy: .equal, toItem: headerView, attribute: .leading, multiplier: 1, constant: 0))
        headerView.addConstraint(NSLayoutConstraint(item: bottomSeparatorView, attribute: .trailing, relatedBy: .equal, toItem: headerView, attribute: .trailing, multiplier: 1, constant: 0))
        headerView.addConstraint(NSLayoutConstraint(item: bottomSeparatorView, attribute: .bottom, relatedBy: .equal, toItem: headerView, attribute: .bottom, multiplier: 1, constant: 0))
        headerView.addConstraint(NSLayoutConstraint(item: bottomSeparatorView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 1))
        return headerView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
}

extension FiltersViewController: SelectCellDelegate {
    func selectCell(selectCell: FiltersSelectCell, isSelected value: Bool) {
        let indexPath = tableView.indexPath(for: selectCell)!
        if indexPath.section == FiltersTableView.SectionId.TYPE.rawValue {
            tableView.typeSelectState = indexPath.row
            checkForFiltersChange()
        } else if indexPath.section == FiltersTableView.SectionId.DIET.rawValue {
            tableView.dietSelectState = indexPath.row
            checkForFiltersChange()
        }
        tableView.sectionTapped(section: indexPath.section)
    }
}
