//
//  FiltersSwitchCell.swift
//  foodsy
//
//  Created by hsherchan on 10/14/17.
//  Copyright © 2017 Foodly. All rights reserved.
//

import UIKit

@objc protocol SwitchCellDelegate {
    @objc optional func switchCell(switchCell: FiltersSwitchCell, didChangeValue value:Bool)
}

class FiltersSwitchCell: UITableViewCell {

    @IBOutlet weak var switchLabel: UILabel!
    @IBOutlet weak var onSwitch: UISwitch!
    
    weak var delegate: SwitchCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        onSwitch.addTarget(self, action: #selector(FiltersSwitchCell.switchValueChanged), for: UIControlEvents.valueChanged)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @objc func switchValueChanged() {
        print ("Switch Value Changed")
        delegate?.switchCell?(switchCell: self, didChangeValue: (onSwitch?.isOn)!)
    }
    
}
